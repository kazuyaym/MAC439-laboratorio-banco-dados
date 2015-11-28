/*******************************************

MAC0439 - Laboratório de Banco de Dados
Exercício 11

Marcos Kazuya Yamazaki
7577622

*******************************************/

Aula 19: Linguagem SQL
SQL Embutida + Transações

Exercício 1: Os exercícios a seguir envolvem programas que manipulam as seguintes relações:

Produto (fabricante, modelo, tipo)
PC(modelo, velocidade, ram, hd, cd, preco)
Laptop (modelo, velocidade, ram, hd, tela, preco)
Impressora(modelo, colorida, tipo, preco)

Usando SQL embutida, faça os seguintes programas em C. Não se esqueça de executar os
comandos BEGIN TRANSACTION, COMMIT e ROLLBACK quando for apropriado e de dizer ao
sistema que suas transações são do tipo “somente leitura” quando for o caso. Para testar o seus
programas, use o banco de dados que pode ser criado por meio do script
“criacao_bd_computadores.sql”.

-- a) Dado um número de modelo de um equipamento, remova-o do BD. (Atenção: isso requer uma
--    modificação em dados de mais de uma tabela do BD).

-- b) Dado um fabricante, aumente o preço dos Laptops desse fabricante em R$200.

-- c) Dados um fabricante, um número de modelo, um tipo de impressora, a indicação de que a
--    impressora é ou não colorida e um preço, insira essas informações do novo equipamento nas tabelas
--    Impressora e Produto. Caso já exista no BD um produto com o mesmo número de modelo que o
--    fornecido, use como número de modelo para o novo equipamento o menor número de modelo ainda
--    não existente no BD que seja maior que o número inicialmente fornecido.

-- d) Dados uma velocidade e um preço, liste os Laptops com a velocidade e preços dados, mostrando
--    o número do modelo e o nome do fabricante.

Exercício 2: Para cada um dos programas dos Exercício 1, discuta os problemas de atomicidade (se
             houver algum) que podem ocorrer no caso de uma falha (queda) do sistema no meio da
             execução do programa.

Exercício 3: Suponha que tenhamos uma transação T que é uma função que executa “eternamente”
             e que a cada hora verifica se existe um equipamento do fabricante 'A' que seja vendido por mais de
             R$2500,00. Se ela encontrar algum equipamento desse tipo, ela imprime as informações do
             equipamento e termina. Durante esse tempo, outras transações que são execuções de um dos quatro
             programas descritos no Exercício 1 podem rodar. Para cada um dos quatro níveis de isolamento
             possíveis – SERIALIZABLE, REPEATABLE READ, READ COMMITED e READ
             UNCOMMITED – diga qual é o efeito sobre T da execução nesse nível de isolamento.

-- Referência:
-- Capítulo 8 do livro “Database Systems – The Complete Book” (1ª edição), Garcia-Molina, Ullman e Widom