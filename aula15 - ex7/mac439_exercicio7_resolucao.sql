/******************************************************
Laboratório de Bancos de Dados - MAC0439
Lista de Exercícios 7 - 2015 - Proposta de Resolução
*******************************************************/

Produto (fabricante, modelo, tipo) 
PC(modelo, velocidade, ram, hd, cd, preco) 
Laptop (modelo, velocidade, ram, hd, tela, preco) 
Impressora(modelo, colorida, tipo, preco)


/** Exercício 1 ***************************************/


a) Uma visao ImpressorasColoridas, que fornece modelo, tipo e preço das impressoras coloridas.

create view ImpressorasColoridas as
	select modelo, tipo, preco from impressora where colorida; 

b) Uma visão PCsPotentes, que fornece o modelo, a velocidade e o preco de todos os PCs com velocidade superior a 1000 MHz.

CREATE VIEW PCsPotentes AS 
	select modelo, velocidade, preco from pc where velocidade > 1000;


c) Uma visão LaptopsIguaisPCs, que fornece todos os atributos dos laptops que possuem velocidade igual a de um PC do BD.

-- opcao 1
create view LaptopsIguaisPCs as
	select L.* from laptop as L, pc as P where L.velocidade = P.velocidade;

-- ou 

-- opcao 2
create view LaptopsIguaisPCs as
	select * from laptop where velocidade in (select velocidade from pc);


d) Uma visão InfoImpressoras que fornece o nome do fabricante, o modelo, o tipo e o preço das impressoras. 

CREATE VIEW InfoImpressoras AS
	SELECT fabricante, modelo, Impressora.tipo, preco
	FROM Produto as P JOIN Impressora as I ON P.modelo = I.modelo;

-- Cuidado! Esse join nao pode ser do tipo "natural join" pois impressora e produto tem dois atributos com o mesmo nome: modelo e tipo. Mas o atributo tipo de produto não tem o mesmo significado que o tipo da impressora. 

e) Uma visão NaviosMaisNovos, que mostra o nome, a classe e o ano de lancamento dos navios lançados mais recentemente.

create view NaviosMaisNovos as
	select * from navios where lancamento >= ALL (select lancamento from navios);  


f) Uma visao NaviosAfundados, que mostra o nome e o ano de lancamento de todos os navios que afundaram em batalha.

-- opcao 1
CREATE VIEW NaviosAfundados as
	select nome, lancamento from navios join resultados on nome = navio 
	where desfecho = 'afundado';

-- ou 

-- opcao 2
CREATE VIEW NaviosAfundados as
	select nome, lancamento from navios 
	where nome in (select navio from resultados where desfecho = 'afundado');

g) Uma visão NaviosPorClasse, que possui três atributos - classe, numNavios, ultLancamento - que mostra, para cada classe, o número de navios na classe e o ano do último lançamento de navio na classe. Na visão, as classes devem ser listadas por ordem decrescente de número de navios. Uma classe que não tiver navios não precisa aparecer na visão.

create view NumNaviosPorClasse(classe, numNavios, ultLancamento) as
	select classe, count(nome), max(lancamento) from navios group by classe order by count(nome) desc;

/** Exercício 2 ***************************************/
-- a) Listar o modelo e preço das impressoras laser coloridas.

select modelo, preco from ImpressorasColoridas where tipo = 'laser'; 

-- b) Listar o modelo, a velocidade e o preço dos PCs potentes de menor preço.

select * from PCsPotentes where preco = (select MIN(preco) from PCsPotentes);

-- c) Listar o país das classes de navios encouraçados que  possuem mais do que 2 navios.

select pais from NumNaviosPorClasse natural join classes where tipo = 'ne' and numNavios > 2; 

-- d) Exibir o número médio de armas dos navios que afundaram em batalhas.

select avg(numArmas) from navios natural join classes natural join NaviosAfundados;

/** Exercício 3 ***************************************/

-- a e b) 
-- Quais das visões do Exercício 1 não são atualizáveis?  Justifique sua resposta. 
-- Para cada visão que você indicou na resposta do item (a), quando isso for possível,  torne a visão atualizável. 

NÃO ATUALIZÁVEIS:
>>> PCsPotentes 
-- teste
insert into produto values ('B', 10002, 'pc');
insert into PCsPotentes values (10002, 1200, 2000);

Embora a visão PCsPotentes esteja definida sobre uma única relação (PC), os atributos ram e hd de PC são NOT NULL e não estão presentes na 
visão.
Para tornar essa visão atualizável, podemos remover a restrição NOT NULL desses atributos ou definir um valor DEFAULT para eles:

ALTER TABLE pc ALTER ram DROP NOT NULL;
ALTER TABLE pc ALTER hd DROP NOT NULL;

ALTER TABLE pc ALTER ram SET DEFAULT 128;
ALTER TABLE pc ALTER hd SET DEFAULT 20;


>>> LaptopsIguaisPCs 

A opção 1 não é atualizável porque há mais de uma relação na cláusula FROM da consulta de definição da visão.
A opção 2 é a versão atualizável dessa visão. A opção 2 tem uma subconsulta na cláusula WHERE, mas como essa subconsulta não envolve a relação Laptop, a visão é atualizável.

-- teste
insert into produto values ('C', 10003, 'laptop');
insert into LaptopsIguaisPCs values (10003, 700,  64,  5, 12.1, 1448);
 
>>> InfoImpressoras

A visão não é atualizável porque suas tuplas são formadas por atributos que vêm de duas relações diferentes: Produto e Impressoras. 
Não há como tornar essa visão atualizável.

>>> NaviosAfundados

A opção 1 não é atualizável porque há mais de uma relação na cláusula FROM da consulta de definição da visão.
A opção 2 é também não é atualizável, porque embora nela a visão esteja definida sobre uma única relação (Navios), o atributo classe em Navios é NOT NULL e não está presente na visão. 
Para tornar a opção 2 atualizável, podemos remover a restrição NOT NULL do atributo classe ou definir um valor DEFAULT para ele:

ALTER TABLE navios ALTER classe DROP NOT NULL;
ou
ALTER TABLE navios ALTER classe SET DEFAULT 'Classe X';

-- teste
insert into NaviosAfundados values ('Navio Y','2015');


>>> NaviosPorClasse

Essa visão não é atualizável porque possui atributos provenientes de agregações. Não há como torná-la atualizável.

--------

-- c) Em quais das visões atualizáveis que você criou no Exercício 1 e no item (b) deste exercício podem ocorrer modificações com anomalias? 
VISÕES ATUALIZÁVEIS:

>>> ImpressorasColoridas
-- teste
insert into produto values ('A', 10001, 'impressora');
insert into ImpressorasColoridas (10001, 'laser', 500);

Como o valor default para o atributo colorida de Impressora é TRUE, não podem ocorrer inserções com anomalias na visão ImpressorasColoridas.
E como o atributo colorida não faz parte da visão, não é possível alterar o seu valor por meio de um comando UPDATE sobre ImpressorasColoridas. Assim, anomalias na alteração também não são possíveis.

>>> LaptopsIguaisPCs (opção 2 - a atualizável)

Ocorreria uma anomalia de modificação nessa visão se atribuíssemos a uma tupla dessa relação um valor para o atributo velocidade que não existe como valor de velocidade em PC. Por exemplo, o comando abaixo faria com que todas as tuplas da visão "desaparecessem", já que ele atribui aos laptops em LaptopsIguaisPCs uma velocidade maior que a velocidade de todos os PCs:

update LaptopsIguaisPCs
set velocidade = (select MAX(velocidade) + 1 from PC);


>>> NaviosMaisNovos
Para gerar uma anomalia de modificação nessa visão, basta decrementarmos o ano de lancamento de uma de suas tuplas. Isso fará com que a tupla "desapareça" da relação:

update NaviosMaisNovos set lancamento = lancamento - 1 where nome = 'Missouri';

>>> NaviosAfundados
 
Qualquer inserção na versão atualizável dessa visão (opção 2) gera uma anomalia, já que um navio que acaba de ser inserido no BD não terá participado de nenhuma batalha e, portanto, não aparecerá em NaviosAfundados. Ex.:

insert into NaviosAfundados values ('Navio Y','2015');
