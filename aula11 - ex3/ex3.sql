/*****************************************

MAC0439 - Laboratório de Banco de Dados
Exercício 3

Marcos Kazuya Yamazaki
7577622

******************************************/

/**********************************************************************************************

MAC439 – Laboratório de Bancos de Dados 23/09/2015

Aula 11: Linguagem SQL - Comandos para alteração de esquemas e consultas básicas
(Lista de Exercícios 3)

A descrição de banco de dados a seguir será usada no exercício 1.
BD Computadores
O esquema desse banco de dados é composto pelas relações com os esquemas descritos a seguir:

Produto (fabricante, modelo, tipo)
PC(modelo, velocidade, ram, hd, cd, preco)
Laptop (modelo, velocidade, ram, hd, tela, preco)
Impressora(modelo, colorida, tipo, preco)

A relação Produto armazena o fabricante, o número do modelo e o tipo (PC, laptop, ou
impressora) de vários produtos. Por conveniência, suponha que os números dos modelos são
únicos sobre todos os fabricantes e tipos de produtos (ou seja, o número do modelo identifica
univocamente um produto). Entretanto, essa suposição não é realística; um banco de dados real
deveria incluir um código do fabricante como parte do número do modelo. A relaçãoPC fornece,
para cada número de modelo que corresponde a um PC, a velocidade (do processador, em
megahertz), a quantidade de memoria RAM (em megabytes), o tamanho do HD (em gigabytes), a
velocidade do driver de CD (6x, 8x, etc.) e o preço. A relação Laptop é similar, exceto pelo fato
de possuir um atributo para o tamanho da tela (em polegadas) no lugar do atributo cd. A relação
Impressora registra para cada modelo de impressora se ela imprime colorido (Verdadeiro ou
Falso), o tipo do processo de impressão (geralmente, laser ou ink-jet) e o preço.
Obs.: Esses eram os produtos de informática vendidos por volta do ano 2000. :) 
Exercício 1: As consultas a seguir se referem ao BD de computadores descrito acima. Escreva-as
em SQL usando apenas o que foi visto na aula de hoje. Confira suas respostas executando suas
consultas no BD criado por meio dos script SQL “aula11_esquema_computadores.sql” e populado
por meio do script “aula11_dados_computadores.sql” (ambos disponíveis no Paca).

a) Encontre os números dos modelos, a quantidade de RAM e o preço de todos os laptops cuja
   velocidade é de pelo 800 megahertz.
b) Faça o mesmo que no item (a), mas renomeie a coluna de quantidade de RAM como
   gigabytes a coluna de preço como R$.
c) Encontre todas as tuplas de PCs que custam entre R$1.000,00 e R$2.000,00.
d) Encontre o número do modelo e o preço dos laptops que possuem tela com tamanho 12.1 ou 15.1
e que tenham pelo menos 96 megabytes de RAM.
e) Encontre todas as tuplas da relação Impressora que correspondam a impressoras coloridas
   mas que não sejam do tipo ink-jet.
f) Encontre os modelos dos produtos dos fabricantes cujo nome começa com uma letra que está
   entre as cinco primeiras do alfabeto.
g) Encontre a tuplas de PCs que possuem um preço maior que o seu número de modelo.
h) Encontre os tipos de produtos vendidos pelos fabricantes que possuem 3 ou mais palavras em seu
   nome.
i) Encontre os tipos de produtos vendidos pelos fabricantes que possuem exatamente 2 palavras em
   seu nome.

A descrição de banco de dados a seguir será usada no Exercício 2.

BD Vendas

Cliente(idC, nomeC, corFavorita)
-- Cada tupla nessa relação representa um cliente, com número de identificação idC, um nome e
uma cor favorita.
Produto(idP, nomeP, fabricante, preco)
-- Cada tupla nessa relação representa um produto com número de identificação idP, um nome, o
nome de seu fabricante e o seu preço.
Produto_Cor(idP, cor)
-- Cada tupla nessa relação indica a disponibilidade de um produto em uma dada cor.
Venda(idC, idP, cor, data)
-- Cada tupla nessa relação registra a venda de um produto de uma dada cor a um cliente em uma
dada data.

Exercício 2: Escreva instruções da SQL para alterar o esquema do BD de vendas criado por meio
dos comandos do script SQL “aula11_esquema_vendas.sql” (disponível para download no Paca).
Observe que esse script cria a estrutura do BD sem incluir nenhuma restrição sobre ela. Você deve,
por meio de comandos SQL de alteração de esquemas, incluir nas tabelas as chaves primárias e as
restrições necessárias para garantir que:

	• todo cliente tenha um nome e todo produto tenha um nome e um preço
	• não haja dois produtos com um mesmo nome
	• o preço de um produto não seja superior a R$500,00
	• em PRODUTO_COR, idP corresponda à identificação de um produto cadastrado no BD
		◦ na remoção de um produto ou na alteração de seu identificador na relação PRODUTO, a
		operação precisa ser propagada para os registros em PRODUTO_COR associados a ele
	• em VENDA, idC corresponda à identificação de um cliente cadastrado no BD
		◦ não deve ser permitido remover um cliente quando houver vendas associadas a ele
		◦ na alteração do identificador de um cliente, a modificação precisa ser propagada para as
		vendas associadas a esse cliente
	• em VENDA, (idP,cor) corresponda a um par produto/cor cadastrado no BD
		◦ não deve ser permitido remover uma tupla de PRODUTO_COR caso haja alguma venda
		associada a ela
		◦ toda alteração no valor do identificador de uma tupla de PRODUTO_COR deve ser
		propagada para as tuplas associadas em VENDA

*****************************************************************************************************/

---- Parte 1

-- a)
select modelo, ram, preco
from laptop
where velocidade >= 800;

-- b)
select modelo, ram as gigabytes, preco as R$
from laptop
where velocidade >= 800;

-- c)
select *
from pc
where (preco >= 1000 and preco <= 2000);

-- d) 
select modelo, preco
from laptop
where (tela = 12.1 or tela = 15.1) and ram >= 96; 

-- e) 
select *
from impressora
where (tipo not like 'ink-jet') and colorida;

-- f) 
select modelo
from produto
where fabricante < 'f'; 

-- g)
select *
from pc
where preco > modelo;

-- h) 
select tipo
from produto
where fabricante like '___%';

-- i) 
select tipo
from produto
where fabricante like '_% _%' and
      fabricante not like '% % %';

---- Parte 2

/*

• todo cliente tenha um nome e todo produto tenha um nome e um preço
• não haja dois produtos com um mesmo nome
• o preço de um produto não seja superior a R$500,00 
• em PRODUTO_COR, idP corresponda à identificação de um produto cadastrado no BD 
	◦ na remoção de um produto ou na alteração de seu identificador na relação PRODUTO, a operação precisa ser propagada para os registros em PRODUTO_COR associados a ele
• em VENDA, idC corresponda à identificação de um cliente cadastrado no BD
	◦ não deve ser permitido remover um cliente quando houver vendas associadas a ele     
	◦ na alteração do identificador de um cliente, a modificação precisa ser propagada para as vendas associadas a esse cliente
•em VENDA, (idP,cor) corresponda a um par produto/cor cadastrado no BD
	◦ não deve ser permitido remover uma tupla de PRODUTO_COR caso haja alguma venda associada a ela
	◦ toda   alteração   no   valor   do   identificador   de uma tupla de PRODUTO_COR deve ser propagada para as tuplas associadas em VENDA

*/

