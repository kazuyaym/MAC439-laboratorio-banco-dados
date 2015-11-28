/*******************************************

MAC0439 - Laboratório de Banco de Dados
Exercício 8

Marcos Kazuya Yamazaki
7577622

*******************************************/

-- voo(nvoo, origem, destino, partida, chegada)

-- Obs.: Considere que os trajetos ocorrem dentro do intervalo de um mesmo dia, ou seja, Partida e
-- Chegada são horários diferentes de uma mesma data.

-- Escreva as seguintes consultas em SQL (nem todas são recursivas). Para testar suas respostas,
-- execute-as sobre o banco de dados que pode ser criado por meio do script “criacao_bd_voos.sql”.

-- (a) Escreva uma consulta SQL que retorne os pares de cidade (x,y) tais que é possível chegar em y a
--     partir de x, por meio de um ou mais voos realizados numa mesma data.
with recursive 
	cidades_aux as (
		select origem, destino, partida, chegada from voo),
	cidades(origem, destino, partida, chegada) as (
		(select * from cidades_aux)
		union
		(select cidades_aux.origem, cidades.destino, cidades.partida, cidades_aux.chegada
		from cidades_aux, cidades
		where cidades.origem = cidades_aux.destino and cidades_aux.chegada < cidades.partida))
select origem, destino from cidades order by origem;

-- (b) Encontre o menor tempo de viagem entre Los Angeles e New York, por meio de nenhuma ou
--     mais conexões realizadas numa mesma data.
with recursive 
	pares as (
		select origem, destino, partida, chegada from voo),
	cidades(origem, destino, partida, chegada) as (
		(select * from pares)
		union
		(select pares.origem, cidades.destino, pares.partida, cidades.chegada
		from pares, cidades
		where cidades.origem = pares.destino and pares.chegada < cidades.partida))
select origem, destino, (chegada-partida) as tempoviagem from cidades where origem like 'Los Angeles' and destino like 'New York' 
     and (chegada-partida) <= all(select chegada-partida from cidades where origem like 'Los Angeles' and destino like 'New York');

-- (c) Escreva uma consulta SQL que retorne os pares de cidade (x,y) tais que é possível chegar em y a
--     partir de x numa mesma data, mas não existe um voo direto de x para y.
with recursive 
	pares as (
		select origem, destino, partida, chegada from voo),
	cidades(origem, destino, partida, chegada) as (
		(select * from pares)
		union
		(select pares.origem, cidades.destino, pares.partida, cidades.chegada
		from pares, cidades
		where cidades.origem = pares.destino and pares.chegada < cidades.partida))
select origem, destino from cidades where (origem, destino) not in (select origem, destino from voo);

-- (d) Escreva uma consulta SQL que retorne os pares de cidade (x,y) tais que é possível chegar em y a
--     partir de x numa mesma data, mas não existe um voo direto entre x e y, e nem é possível chegar em
--     y a partir de x por meio de uma única escala.
with recursive 
	pares as (
		select origem, destino, partida, chegada from voo),
	cidades(origem, destino, partida, chegada) as (
		(select * from pares)
		union
		(select pares.origem, cidades.destino, pares.partida, cidades.chegada
		from pares, cidades
		where cidades.origem = pares.destino and pares.chegada < cidades.partida))
select origem, destino from cidades where ((origem, destino) not in (select origem, destino from voo v1)) and
										  ((origem, destino) not in (select v1.origem, v2.destino from voo v1, voo v2 where v1.destino = v2.origem)); 

-- (e) Encontre todos os números de voos que chegam em Albuquerque antes que o voo 425 parta de
--     Albuquerque, mas não mais do que três horas antes que esse voo parta de Albuquerque.
with recursive 
	pares as (
		select nvoo, origem, destino, partida, chegada from voo),
	cidades(nvoo, origem, destino, partida, chegada) as (
		(select * from pares)
		union
		(select pares.nvoo, pares.origem, cidades.destino, pares.partida, cidades.chegada
		from pares, cidades
		where cidades.origem = pares.destino and pares.chegada < cidades.partida))
select * from cidades where destino like 'Albuquerque' and chegada < (select chegada from voo where nvoo = 425) 
                                                       and chegada > (select (chegada - interval '3:00:00') from voo where nvoo = 425);

-- (f) Encontre todas as cidades possíveis de se alcançar a partir de Los Angeles fazendo uma conexão
--     em Las Vegas (podem haver outras conexões, eventualmente) numa mesma data.
with recursive 
	pares as (
		select nvoo, origem, destino, partida, chegada from voo),
	cidades(nvoo, origem, destino, partida, chegada) as (
		(select * from pares)
		union
		(select pares.nvoo, pares.origem, cidades.destino, pares.partida, cidades.chegada
		from pares, cidades
		where cidades.origem = pares.destino and pares.chegada < cidades.partida))
select c2.destino from cidades c1, cidades c2 where c1.origem like 'Los Angeles' 
                                                and c1.destino like 'Las Vegas' 
                                                and c2.origem like 'Las Vegas' 
                                                and c2.partida > c1.chegada;

-- (g) Escreva uma consulta SQL que retorne o conjunto de cidades x que possuem pelo menos dois
--     voos que partem dela. Isto é, existe t e s distintos tais que t e s são cidades destino de voos que
--     partem de x.
select origem from voo group by origem having count(origem) > 1;

-- (h) Escreva uma consulta SQL que retorne o conjunto de cidades x que podem ser o ponto de
--     partida para se chegar em pelo menos duas outras cidades numa mesma data. Observe que ambas
--     podem estar diretamente ligadas a x por meio de um voo, em vez de uma estar diretamente ligada e
--     outra estar ligada por meio de uma escala.
with recursive 
	pares as (
		select nvoo, origem, destino, partida, chegada from voo),
	cidades(nvoo, origem, destino, partida, chegada) as (
		(select * from pares)
		union
		(select pares.nvoo, pares.origem, cidades.destino, pares.partida, cidades.chegada
		from pares, cidades
		where cidades.origem = pares.destino and pares.chegada < cidades.partida))
select origem from cidades group by origem having count(origem) > 1;

-- (i) Encontre o número de todos os voos que não partem de Las Vegas ou de uma cidade que é
--     possível alcançar a partir de Los Angeles por voo direto ou por uma ou mais conexões numa
--     mesma data.
with recursive 
	pares as (
		select nvoo, origem, destino, partida, chegada from voo),
	cidades(nvoo, origem, destino, partida, chegada) as (
		(select * from pares)
		union
		(select pares.nvoo, pares.origem, cidades.destino, pares.partida, cidades.chegada
		from pares, cidades
		where cidades.origem = pares.destino and pares.chegada < cidades.partida))
select distinct nvoo from cidades where (nvoo not in (select nvoo from voo     where origem like 'Las Vegas'))
                                     or (nvoo not in (select nvoo from cidades where origem like 'Los Angeles')); 

-- (j) Escreva uma consulta SQL que retorne o conjunto de pares de cidades (x,y) tais que é possível
--     chegar em y a partir de x numa mesma data e que, a partir de y, pode-se chegar a no máximo uma
--     cidade.
with recursive 
	pares as (
		select nvoo, origem, destino, partida, chegada from voo),
	cidades(nvoo, origem, destino, partida, chegada) as (
		(select * from pares)
		union
		(select pares.nvoo, pares.origem, cidades.destino, pares.partida, cidades.chegada
		from pares, cidades
		where cidades.origem = pares.destino and pares.chegada < cidades.partida))
select c.origem, c.destino from cidades c, voo v where c.destino = v.origem 
                                                   and v.origem in (select origem from voo group by origem having count(origem) <= 1); 