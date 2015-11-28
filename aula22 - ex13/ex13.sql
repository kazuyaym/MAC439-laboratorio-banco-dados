/*******************************************

MAC0439 - Laboratório de Banco de Dados
Exercício 13

Marcos Kazuya Yamazaki
7577622

*******************************************/

-- Autorização

-- Você e mais dois amigos computeiros – Fulano e Sicrano – criaram uma site para a venda de livros.
-- Você é o DBA (administrador de BD) da empresa e o único que tem “acesso livre” aos objetos que já
-- existem no BD.
-- Para acompanhar mais facilmente o andamento dos negócios, você criou uma tabela chamada
-- Estatisticas, onde cada linha contém a quantidade total vendida de um dado livro num dado dia. A
-- tabela tem a seguinte estrutura:

-- Estatisticas(data, tituloLivro, categoria, quantidade, precoTotal)

-- Para facilitar o controle de autorização sobre a tabela Estatisticas, você criou duas visões:
-- TitulosLivros (que tem um único atributo chamado titulo e que lista, sem repetições, os títulos dos
-- livros) e VendasPorCategoria com os atributos categoria e totalVendas (que lista o valor total
-- vendido para cada categoria de livro).

-- a) Escreva comandos SQL para a criação das visões TitulosLivros e VendasPorCategoria.
create table Estatisticas (
	data			date,
	tituloLivro 	varchar(255),
	categoria 		varchar(255),
	quantidade 		int,
	precoTotal		real,

	primary key(data, tituloLivro)
);

create view TitulosLivros as select distinct tituloLivro as titulo from Estatisticas;
create view VendasPorCategoria as select categoria, sum(precoTotal) as totalVendas from Estatisticas group by categoria;

-- insert into Estatisticas values ('2015-07-28', 'Kazuya o maravilhoso', 'comedia', 5, 100.99);
-- insert into Estatisticas values ('2015-07-27', 'Kazuya o ridiculo', 'comedia', 2, 10.99);
-- insert into Estatisticas values ('2015-07-26', 'Kazuya o escroto', 'comedia', 1, 140.99);
-- insert into Estatisticas values ('2015-07-24', 'Kazuya o docinho', 'comedia', 7, 200.99);

-- insert into Estatisticas values ('2015-08-16', 'Erika Midori', 'terror', 1, 140.99);
-- insert into Estatisticas values ('2015-08-17', 'A vida solitaria de erika', 'terror', 2, 200.00);

-- b) O seu sócio Fulano precisa saber o total de vendas das categorias de livro “romance” e
--    “policial”. Quais privilégios você deve dar a ele, para que ele possa consultar apenas essa
--    informação no BD? Escreva o comando SQL correspondente.
--    Obs.: Cada um dos seus sócios possui um usuário no BD com identificador igual ao seu nome.

grant select on VendasPorCategoria to Fulano;

grant select(tituloLivro) on VendasPorCategoria to Fulano; 

Neste caso, como o Fulano já sabe as categorias que ele quer pesquisar, não há necessidade
de aparecer as categorias, pois assim o Fulano vai saber de todas as categorias que existem.
(Que eu não sei se isso seria restrição para ser tratada ou não).

-- c) Você precisa de ajuda para manter a tabela Estatísticas atualizada. Por essa razão, quer
--    autorizar seu sócio Sicrano a realizar inserções nela, modificar a categoria de uma tupla,
--    verificar se um dado livro aparece nas estatísticas e consultar a venda total por categoria. Quais
--    privilégios você deve atribuir a Sicrano? Escreva os comandos correspondentes.

grant insert, update(categoria) on Estatisticas to Sicrano;
grant select on TitulosLivros, VendasPorCategoria to Sicrano;

-- d) Você não quer que o seu sócio Sicrano seja capaz de consultar o valor total de vendas de cada
--    livro individualmente. A sua resposta para o item anterior garante isso? Mais especificamente:
--    Sicrano pode eventualmente descobrir o total de vendas de alguns livros (dependendo do
--    conjunto corrente de tuplas no BD)? Sicrano pode sempre descobrir o total de vendas de
--    qualquer livro que ele quiser consultar?

Eventualmente, o Sicrano pode conseguir sim decobrir o valor total de vendas de cada livro individualmente,
pois como ele sabe todas as categorias através das VendasPorCategoria, e como ele também tem a permissão de
mudar a categoria de um determinado livro (que ele tem acesso aos nomes de todos os livros em TitulosLivros!).
Sicrano pode, com más intenções, mudar a categoria de um livro que ele queira saber o total de vendas, para uma
categoria que ele sabe que não existe. Logo ele consegue consultar a visão VendasPorCategoria novamente,
e agora aparecerá essa nova categoria com o valor, que ele sabe que aquele livro é o unico que tem essa categoria. 

-- e) Você quer que Sicrano possa permitir que outras pessoas acessem para leitura a visão
--    TitulosLivros. Escreva o comando apropriado.
grant select on TitulosLivros to Sicrano with grant option;

-- f) Sicrano deu autorização para que o Fulano pudesse ler da relação TitulosLivros. Mas, pouco
--    tempo depois, Sicrano brigou com vocês e deixou abruptamente a sociedade da empresa. Com
--    raiva do ocorrido, você então revoga os privilégios do seu ex-sócio Sicrano. O que acontece
--    com os privilégios de Fulano nesse caso?

Os privilégios do Fulano nesse caso não são interferidas, pois a opção cascade não foi usada. 

-- g) Você precisa fazer uma longa viagem a negócios e, para garantir que a tabela Estatisticas
--    continue sendo atualizada, você autoriza o sócio Fulano a ler e modificar a relação
--    Estatisticas. Fulano deve poder também delegar autoridade, já que ele está sempre bastante
--    atarefado, cuidando da parte administrativa da empresa. Mostre os comandos SQL apropriados
--    para isso. Fulano poderá ler dados da visão VendasPorCategoria?

grant select, update on Estatisticas to Fulano with grant option;

A permissão a Fulano só foi dada na Relação Estatisticas, logo ele não consegue acessar a visão 
VendasPorCategoria. A não ser que seja levada em conta a resolução do execício b)

-- h) Ao voltar de viagem, você descobre que Fulano autorizou a namorada dele (a Beltrana) a ler a
--    relação Estatisticas. Você quer revogar esse privilégio dado à Beltrana, mas não quer
--    revogar as permissões que deu a Fulano (nem mesmo temporariamente, afinal ele é sócio
--    também). Você pode fazer isso em SQL? Se sim, mostre como.

revoke grant option for select on Estatisticas from Beltrana;

-- i) Uma vez que passou a ter permissões de acesso ao BD, Fulano tomou gosto pela SQL. Somente
--    por diversão, ele definiu uma nova visão chamada TitulosLongos (para títulos com mais de 3
--    palavras) usando a visão TitulosLivros. Depois, Fulano deu à sua namorada Beltrana e ao seu
--    ex-sócio Sicrano o direito à leitura na visão TitulosLongos. Você decide que, mesmo que isso
--    aborreça o Fulano por tirar dele alguns de seus privilégios, você simplesmente precisa impedir
--    que a Beltrana e o Sicrano possam continuar vendo os dados da empresa. Para fazer isso, qual
--    comando REVOKE você precisa executar? Quais privilégios Fulano terá sobre Estatisticas
--    depois desse comando ser executado? Quais visões serão removidas como consequência?

revoke grant option for select on Estatisticas from Fulano cascade;