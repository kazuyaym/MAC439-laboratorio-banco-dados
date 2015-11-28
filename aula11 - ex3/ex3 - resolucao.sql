http://paca.ime.usp.br/pluginfile.php/76326/mod_resource/content/1/mac439_exercicio3_resolucao.sql

-- EXERCICIO 1
-- a) Encontre os números dos modelos, a quantidade de RAM e o preço de todos os laptops cuja velocidade é de pelo 800 megahertz. 
select modelo, ram, preco from laptop where velocidade >= 800; 

-- b) Faça o mesmo que no item (a), mas renomeie a coluna de quantidade de RAM como gigabytes a coluna de preço como R$.

select modelo, ram as gigabytes, preco as R$ from laptop where velocidade >= 800; 

-- c) Encontre todas as tuplas de PCs que custam entre  R$1.000,00 e R$2.000,00.

select * from pc where preco >= 1000 and preco <= 2000;

-- d) Encontre o número do modelo e o preço dos laptops que possuem tela com tamanho 12.1 ou 15.1 e que tenham pelo menos 96 megabytes de RAM. 

select modelo, preco from laptop where (tela = 12.1 or tela = 15.1 ) and ram >= 96; 

-- e) Encontre todas as tuplas da relação Impressora que correspondam a impressoras coloridas mas que não sejam do tipo ink-jet. 

select * from impressora where colorida and tipo != 'ink-jet';

-- f) Encontre os modelos dos produtos dos fabricantes cujo nome começa com uma letra que está entre as cinco primeiras do alfabeto.

select modelo, fabricante from produto where fabricante >= 'A' and fabricante < 'F';

-- ou 

select modelo, fabricante from produto where fabricante like 'A%' or fabricante like 'B%' or fabricante like 'C%' or fabricante like 'D%' or fabricante like 'E%';

-- g) Encontre a tuplas de PCs  que possuem um preço maior que o seu número de modelo.

select * from pc where preco > modelo; 

-- h) Encontre os tipos de produtos vendidos pelos fabricantes que possuem 3 ou mais palavras em seu nome.

select * from produto where fabricante like '% % %';

-- i) Encontre os tipos de produtos vendidos pelos fabricantes que possuem exatamente 2 palavras em seu nome.

select * from produto where fabricante like '% %' and fabricante not like '% % %';


-- EXERCICIO 2
-- Definição das chaves primárias
alter table Cliente add primary key(idC); 
alter table Produto add primary key(idP);
alter table Produto_Cor add primary key(idP,cor);
alter table Venda add primary key(idC,idP,cor,data);

-- todo cliente tenha um nome e todo produto tenha um nome e um preço
alter table Cliente alter column nomeC set not null;
alter table Produto alter column nomeP set not null;
alter table Produto alter column preco set not null;

-- não haja dois produtos com um mesmo nome
alter table Produto add unique (nomeP);

-- o preço de um produto não seja superior a R$500,00 
alter table Produto add check (preco <= 500);

-- em PRODUTO_COR, idP corresponda à identificação de um produto cadastrado no BD 
-- na remoção de um produto ou na alteração de seu identificador na relação PRODUTO, a operação precisa ser propagada para os registros em PRODUTO_COR associados a ele
alter table Produto_Cor add foreign key (idP) references Produto (idP) on update cascade on delete cascade;

-- em VENDA, idC corresponda à identificação de um cliente cadastrado no BD
-- não deve ser permitido remover um cliente quando houver vendas associadas a ele     
-- na alteração do identificador de um cliente, a modificação precisa ser propagada para as vendas associadas a esse cliente
alter table Venda add foreign key (idC) references Cliente (idC) on delete restrict on update cascade;

-- em VENDA, (idP,cor) corresponda a um par produto/cor cadastrado no BD
-- não deve ser permitido remover uma tupla de PRODUTO_COR caso haja alguma venda associada a ela
-- toda alteração no valor do identificador de uma tupla de PRODUTO_COR deve ser propagada para as tuplas associadas em VENDA 
alter table Venda add foreign key (idP,cor) references Produto_Cor(idP,cor) on delete restrict on update cascade;