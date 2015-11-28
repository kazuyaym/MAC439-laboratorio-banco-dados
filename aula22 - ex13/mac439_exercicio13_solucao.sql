/******************************************************
Laboratório de Bancos de Dados - MAC0439
Lista de Exercícios 13 - 2015 - Proposta de Resolução
*******************************************************/

/** Exercício ***************************************/

-- Tabela Estatísticas

CREATE SCHEMA aula22;
SET search_path TO aula22;

CREATE TABLE Estatisticas
(
	data DATE,
	tituloLivro VARCHAR(255),
	categoria VARCHAR(255),
	quantidade INT,
	precoTotal NUMERIC(10,2),
	PRIMARY KEY (data, tituloLivro)
);


INSERT INTO Estatisticas VALUES ('2010-01-01', 'Jogos Vorazes', 'Ficção Científica', 5, 150.00);
INSERT INTO Estatisticas VALUES ('2010-02-08', 'Jogos Vorazes', 'Ficção Científica', 10, 200.00);
INSERT INTO Estatisticas VALUES ('2011-05-30', 'Em Chamas', 'Ficção Científica', 3, 120.00);
INSERT INTO Estatisticas VALUES ('2011-04-05', 'Em Chamas', 'Ficção Científica', 2, 80.00);
INSERT INTO Estatisticas VALUES ('2011-10-31', 'A Esperança', 'Ficção Científica', 10, 500.00);
INSERT INTO Estatisticas VALUES ('2011-11-10', 'A Esperança', 'Ficção Científica', 5, 250.00);
INSERT INTO Estatisticas VALUES ('2000-06-25', 'Padrões de projeto', 'Computação', 2, 179.80);
INSERT INTO Estatisticas VALUES ('2006-12-01', 'C++ Como programar', 'Computação', 1, 459.90);
INSERT INTO Estatisticas VALUES ('2013-06-25', 'Malala', 'Biografia', 30, 300.00);
INSERT INTO Estatisticas VALUES ('2013-07-02', 'Malala', 'Biografia', 2, 20.00);
INSERT INTO Estatisticas VALUES ('2015-04-03', 'Um Passe de Magica', 'Policial', 2, 30.00);
INSERT INTO Estatisticas VALUES ('2014-07-05', 'Assassinato no Expresso do Oriente', 'Policial', 2, 42.00);
INSERT INTO Estatisticas VALUES ('2014-06-05', 'Uma carta de amor', 'Romance', 2, 42.00);
INSERT INTO Estatisticas VALUES ('2014-04-05', 'Querido John', 'Romance', 2, 28.80);


-- a) Escreva comandos SQL para a criação das visões TitulosLivros e VendasPorCategoria.

create view TitulosLivros as
	select distinct tituloLivro
	from Estatisticas;

create view VendasPorCategoria as
	select categoria, sum(precoTotal) as totalVendas  
	from Estatisticas
	group by categoria;

-- b) O seu sócio Fulano precisa saber o total de vendas das categorias de livro "romance" e "policial". Quais privilégios você deve dar a ele, para que ele possa consultar apenas essa informação no BD? Escreva o comando SQL correspondente. Obs.: Cada um dos seus sócios possui um usuário no BD com identificador igual ao seu nome.


create view VendasPorCategoriaPolicialRomance as
	select categoria, sum(precoTotal) as totalVendas  
	from Estatisticas 
	where categoria = 'Policial' or categoria = 'Romance'
	group by categoria;
	
grant usage on schema aula22 to Fulano;
grant select on VendasPorCategoriaPolicialRomance to Fulano;

-- ou 
grant usage on schema aula22 to Fulano;
grant select on VendasPorCategoria To Fulano;

-- Observe que é impossível permitir que o usuário acesse somente o total de livros das categorias "Romance" e "Policial" se dermos a permissão de acesso a VendasPorCategoria. Se nós queremos realmente ocultar do usuário o total vendido nas outras categorias, nós não temos escolha a não ser criar outra view.


-- c)Você precisa de ajuda para manter a tabela Estatísticas atualizada. Por essa razão, quer autorizar seu sócio Sicrano a realizar inserções nela, modificar a categoria de uma tupla, verificar se um dado livro aparece nas estatísticas e consultar a venda total por categoria. Quais privilégios você deve atribuir a Sicrano? Escreva os comandos correspondentes.

-- Para realizar inserções em Estatísticas, precisamos que ele tenha permissão de INSERT em Estatísticas
-- Para realizar modificações em uma categoria de Estatísticas, precisamos que ele tenha permissão de UPDATE somente em categoria na tabela Estatisticas
-- Para verificar se um livro aparece em Estatistica, precisamos que ele tenha acesso a consultas por meio de SELECT em TitulosLivros ou somente ao atributo tituloLivro de Estatísticas.
-- Para consultar a venda total por categoria, precisamos que ele tenha acesso a consultas por meio de SELECT na visão VendasPorCategoria.

grant usage on schema aula22 to Sicrano;

grant insert, update(categoria), select(tituloLivro) on Estatisticas to Sicrano;
grant select on TitulosLivros to Sicrano;
grant select on VendasPorCategoria to Sicrano;


-- d) Você não quer que o seu sócio Sicrano seja capaz de consultar o valor total de vendas de cada livro individualmente. A sua resposta para o item anterior garante isso? Mais especificamente: Sicrano pode eventualmente descobrir o total de vendas de alguns livros (dependendo do conjunto corrente de tuplas no BD)? Sicrano pode sempre descobrir o total de vendas de qualquer livro que ele quiser consultar?

-- A resposta anterior garante que Sicrano não acesse diretamente o preçoTotal em Estatisticas nem consiga selecionar o total de vendas de um livro específico por meio da visão VendasPorCategoria. 
-- Entretanto, eventualmente, se houver apenas um ou dois tipos de livros no BD e uma ou duas categorias, o Sicrano poderia deduzir o total de vendas de cada livro apenas.
-- Além disso, ele pode descobrir o total de vendas de qualquer livro, pois ele pode mudar um livro para uma categoria nova e, por meio da visão VendasPorCategoria, descobrir o valor total.

-- e) Você quer que Sicrano possa permitir que outras pessoas acessem para leitura a visão TitulosLivros. Escreva o comando apropriado.

grant usage on schema aula22 to Sicrano with grant option;
grant select on TitulosLivros to Sicrano with grant option;

-- f) Sicrano deu autorização para que o Fulano pudesse ler da relação TitulosLivros. Mas, pouco tempo depois, Sicrano brigou com vocês e deixou abruptamente a sociedade da empresa. Com raiva do ocorrido, você então revoga os privilégios do seu ex-sócio Sicrano . O que acontece com os privilégios de Fulano nesse caso?

revoke grant option for usage on schema aula22 from Sicrano cascade; 
revoke grant option for select on TitulosLivros from Sicrano cascade;


revoke usage on schema aula22 from Sicrano cascade; 
revoke insert, update(categoria), select(tituloLivro) on Estatisticas from Sicrano;
revoke select on TitulosLivros from Sicrano cascade;
revoke select on VendasPorCategoria from Sicrano;


-- Os privilégios de Sicrano só poderiam ser revogados por meio da opção CASCADE (já que  RESTRICT não permitiria a revogação). Fulano terá sua permissão de leitura da view TitulosLivros e de acesso ao schema aula22 revogada.
-- Fulano só conseguirá o acesso novamente essas informações se outra pessoa, com os mesmos privilégios de Sicrano, conceder o privilégio de leitura a ele.

--g)Você precisa fazer uma longa viagem a negócios e, para garantir que a tabela Estatisticas continue sendo atualizada, você autoriza o sócio Fulano a ler e modificar a relação Estatisticas. Fulano deve poder também delegar autoridade, já que ele está sempre bastante atarefado, cuidando da parte administrativa da empresa. Mostre os comandos SQL apropriados para isso. Fulano poderá ler dados da visão VendasPorCategoria?
grant usage on schema aula22 to Fulano with grant option;
grant select, insert, update on Estatisticas to Fulano with grant option;

-- Caso o privilégio para ler os dados de VendasPorCategoria tenha sido concedido no item b, Fulano poderá acessar os dados de VendasPorCategoria.
-- Caso tenha sido construída outra visão, Fulano não poderá ler os dados da visão VendasPorCategoria diretamente, mas poderá executar a mesma consulta sobre a tabela Estatisticas.

--h) Ao voltar de viagem, você descobre que Fulano autorizou a namorada dele (a Beltrana) a ler a relação Estatisticas. Você quer revogar esse privilégio dado à Beltrana, mas não quer revogar as permissões que deu a Fulano (nem mesmo temporariamente, afinal ele é sócio também). Você pode fazer isso em SQL? Se sim, mostre como.

-- comandos executados por Fulano
grant usage on schema aula22 to Beltrana with grant option;
grant select on Estatisticas to Beltrana with grant option;

-- Não existe uma forma de fazer isso em SQL: mesmo que você concenda os privilégios para Fulano e Fulano concenda os privilégios para Beltrana, você não pode revogar os privilégios de Beltrana sem revogar os privilégios de Fulano também.

--A única solução que não tiraria a autorização de Fulano sobre a consulta e manipulação de dados seria remover o direito a conceder privilégios a terceiros, mas ainda sim, estaríamos alterando as permissões de Fulano.

revoke grant option
for select, insert, update
on Estatisticas
from Fulano cascade;

--i) Uma vez que passou a ter permissões de acesso ao BD, Fulano tomou gosto pela SQL. Somente por diversão, ele definiu uma nova visão chamada TitulosLongos (para títulos com mais de 3 palavras) usando a visão TitulosLivros. Depois, Fulano deu à sua namorada Beltrana e ao seu ex-sócio Sicrano o direito à leitura na visão TitulosLongos. Você decide que, mesmo que isso aborreça o Fulano por tirar dele alguns de seus privilégios, você simplesmente precisa impedir que a Beltrana e o Sicrano possam continuar vendo os dados da empresa. Para fazer isso, qual comando REVOKE você precisa executar? Quais privilégios Fulano terá sobre Estatisticas depois desse comando ser executado? Quais visões serão removidas como consequência?


-- Supondo que Fulano ganhou acesso a TitulosLivros:
grant select on TitulosLivros to Fulano;
-- E a permissão para criar visões, tabelas, etc: 
grant create on schema aula22 to Fulano;

-- Visão criada por Fulano
create view TitulosLongos as
	select * from TitulosLivros where tituloLivro like '% % %';
	
-- Obs.: mesmo sem acesso a view TitulosLivros, Fulano poderia criar a view TitulosLongos utilizando a mesma consulta de TitulosLivros.	
	
create view TitulosLongos as
	select * from (select distinct tituloLivro
	from Estatisticas) as titulosLivros where tituloLivro like '% % %';	
	
	
-- Comandos executados por Fulano
grant usage on schema aula22 to Beltrana,Sicrano with grant option;
grant select on TitulosLongos to Beltrana, Sicrano;


-- Para remover o acesso de Beltrana e Sicrano, seria suficiente executar:

revoke grant option 
for usage on schema aula22
from Fulano cascade;

-- Outra opção:

-- Para remover o acesso de Beltrana e Sicrano aos dados da empresa, poderíamos remover a autorizaçao de Fulano para conceder acesso aos dados da visao TitulosLivros ou Estatisticas, mas isso não resolveria o problema! A permissão de acesso concedida a Beltrana e Sicrano é relacionada a TitulosLongos (cujo dono é o Fulano e tem acesso a TitulosLivros ou Estatisticas).

revoke grant option
for select
on TitulosLivros
from Fulano cascade;

revoke grant option
for select, insert, update
on Estatisticas
from Fulano cascade;


-- Só removeríamos o acesso de Beltrana e Sicrano retirando a permissão de consulta da view TitulosLivros:

revoke select
on TitulosLivros
from Fulano cascade;

-- Ou a permissão de consulta da tabela Estatisticas (caso a view TitulosLongos tenha sido criada por meio dela):
revoke select
on Estatisticas
from Fulano cascade;


