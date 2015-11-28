/*******************************************

MAC0439 - Laboratório de Banco de Dados
Exercício 7

Marcos Kazuya Yamazaki
7577622

*******************************************/

---- Exercício 1: A partir das seguintes tabelas

/*
Escreva comandos SQL para construir as visões descritas a seguir. Teste seus comandos no
banco de dados que pode ser criado por meio do script “aula15_esquema_dados.sql”
disponível no Paca.

produto (fabricante, modelo, tipo)
pc(modelo, velocidade, ram, hd, cd, preco)
laptop (modelo, velocidade, ram, hd, tela, preco)
impressora(modelo, colorida, tipo, preco)

classes(classe, tipo, pais, numArmas, calibre, deslocamento)
navios(nome, classe, lancamento)
batalhas(nome, data)
resultados(navio, batalha, desfecho)

*/

-- a) Uma visão ImpressorasColoridas, que fornece modelo, tipo e preço das impressoras coloridas.
create view ImpressorasColoridas as
	select modelo, tipo, preco from impressora where colorida;

-- b) Uma visão PCsPotentes, que fornece o modelo, a velocidade e o preço de todos os PCs com
--    velocidade superior a 1000 MHz.
create view PCsPotentes as 
	select modelo, velocidade, preco from pc where velocidade > 1000;

-- c) Uma visão LaptopsIguaisPCs, que fornece todos os atributos dos laptops que possuem velocidade
--    igual a de um PC do BD.
create view LaptopsIguaisPCs as
	select * from laptop where velocidade in (
		select velocidade from pc
	);

-- d) Uma visão InfoImpressoras que fornece o nome do fabricante, 
--    o modelo, o tipo e o preço das impressoras.
create view InfoImpressoras as
	select p.fabricante, i.modelo, i.tipo, i.preco
	from impressora i, produto p
	where i.modelo = p.modelo;

-- e) Uma visão NaviosMaisNovos, que mostra o nome, a classe e o 
--    ano de lançamento dos navios lançados mais recentemente.
create view NaviosMaisNovos as
	select nome, classe, lancamento
	from navios
	where lancamento >= all (select lancamento from navios);

-- f) Uma visão NaviosAfundados, que mostra o nome e o ano de
--    lançamento de todos os navios que afundaram em batalha.
create view NaviosAfundados as
	select r.navio, n.lancamento
	from navios n, resultados r 
	where r.desfecho like 'afundado' and r.navio = n.nome;

-- g) Uma visão NaviosPorClasse, que possui três atributos – classe, numNavios, ultLancamento –
--    que mostra, para cada classe, o número de navios na classe e o ano do último lançamento de navio
--    na classe. Na visão, as classes devem ser listadas por ordem decrescente de número de navios. Uma
--    classe que não tiver navios não precisa aparecer na visão.
create view NaviosPorClasse(classe, numNavios, ultLancamento) as
	select c.classe, count(n1.nome) as numNavios, max(n1.lancamento) as ultLancamento
	from classes c, navios n1
	where c.classe = n1.classe
	group by c.classe
	order by numNavios desc;

---- Exercício 2: Usando as visões criadas no Exercício 1, escreva consultas SQL para:

-- a) Listar o modelo e o preço das impressoras laser coloridas.
select modelo, preco from ImpressorasColoridas;

-- b) Listar o modelo, a velocidade e o preço dos PCs potentes de menor preço.
select modelo, velocidade from PCsPotentes where preco <= all (
	select preco from PCsPotentes
	); 

-- c) Listar o países das classes de navios encouraçados que possuem mais do que 2 navios.
select pais 
from classes c, NaviosPorClasse n 
where c.classe like n.classe and
      n.numNavios > 2;

-- d) Exibir o número médio de armas dos navios que afundaram em batalhas.
select avg(c.numArmas) 
from classes c, NaviosAfundados naf, navios n 
where naf.navio like n.nome and 
      c.classe like n.classe;

---- Exercício 3: Para responder as questões a seguir, considere as visões que você criou
--                no Exercício 1 e as tabelas + restrições criadas por meio do script
--                “aula15_esquema_dados.sql”.

-- a) Quais das visões do Exercício 1 não são atualizáveis? Justifique sua resposta.
--    Obs.: Uma visão é não atualizável quando não se pode executar comandos de inserção,
--    alteração e remoção diretamente sobre ela.
d)
create view InfoImpressoras as
	select p.fabricante, i.modelo, i.tipo, i.preco
	from impressora i, produto p
	where i.modelo = p.modelo;

Neste caso a view não é atualizavel porque os atributos selecionados fazem parte de duas 
relações, duas tabelas IMPRESSORA e PRODUTO.

O mesmo ocorre com as consultas dos intens f) e g) em
que possuem duas tabelas refereciadas na clausula FROM

e)
create view NaviosMaisNovos as
	select nome, classe, lancamento
	from navios
	where lancamento >= all (select lancamento from navios);

A clausula WHERE dessa consulta, possui uma subconsulta e nessa subconsulta a
mesma tabela referenciada na consulta principal, foi referenciada na subconsulta

-- b) Para cada visão que você indicou na resposta do item (a), quando isso for
--    possível, torne a visão atualizável. Isso pode ser feito de duas maneiras:
--    1) reescrevendo a definição da visão e/ou
--    2) modificando algumas restrições sobre atributos das tabelas base da visão.
f)
create view NaviosAfundados as
	select nome, lancamento
	from navios  
	where nome in (select navio 
		           from resultados 
		           where desfecho like 'afundado');

-- c) Em quais das visões atualizáveis que você criou no Exercício 1 e no item (b) deste exercício
--   podem ocorrer modificações com anomalias? Para cada visão apontada, justifique a sua resposta
--   com pelo menos um exemplo de comando que cause uma anomalia.
--   Obs.: uma modificação com anomalia é um comando INSERT ou UPDATE sobre a visão que é
--         aceito como válido pelo SGBD, mas que causa uma modificação que não é refletida na visão em
--         questão ou que causa o desaparecimento de tuplas na visão.

Podem ocorrer modificações com anomalias no item modificado da f)

Um exemplo seria executar o seguinte comando:
INSERT into NaviosAfundados values ('Desbravadores', 1999);

Como não existe nenhum barco com o nome de 'Desbravadores' na relação resultados,
e muito menos a informação que esse barco foi afundado, a seguinte inserção será traduzida como: 
insert into navios (nome, classe, lancamento) values ('Desbravadores', NULL,  1999);
E a tupla inserida no BD não fará parte da visão.