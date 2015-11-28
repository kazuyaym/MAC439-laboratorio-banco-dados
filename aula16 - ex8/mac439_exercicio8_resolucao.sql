/******************************************************
Laboratório de Bancos de Dados - MAC0439
Lista de Exercícios 8 - 2015 - Proposta de Resolução
*******************************************************/

-- (a) Escreva uma consulta SQL que retorne os pares de cidade (x,y) tais que é possível chegar em y a partir de x, por meio de um ou mais  voos.

WITH RECURSIVE Conectadas(origem,destino,partida,chegada) AS (
	(SELECT origem, destino, partida, chegada FROM Voo)
	UNION
	(SELECT C.origem, V.destino, C.partida, V.chegada 
		FROM Conectadas as C, Voo as V 
		WHERE C.destino = V.origem and C.chegada < V.partida) )
SELECT origem, destino FROM Conectadas;
	

-- (b) Encontre o menor tempo de viagem entre Los Angeles e New York, por meio de nenhuma ou mais conexões realizadas num mesmo dia.


WITH RECURSIVE ConectadasLA(cidade,partida,chegada) AS (
	(SELECT destino, partida, chegada FROM Voo WHERE origem = 'Los Angeles')
	UNION
	(SELECT V.destino, C.partida, V.chegada 
		FROM ConectadasLA as C, Voo as V 
		WHERE C.cidade = V.origem and C.chegada < V.partida) )
SELECT MIN(chegada - partida) FROM ConectadasLA WHERE cidade = 'New York';
	
-- (c) Escreva uma consulta SQL que retorne os pares de cidade (x,y) tais que é possível chegar em y a partir de x  numa mesma data, mas não existe um voo direto de  x para y.

WITH RECURSIVE Conectadas(origem,destino,partida,chegada) AS (
	(SELECT origem, destino, partida, chegada FROM Voo)
	UNION
	(SELECT C.origem, V.destino, C.partida, V.chegada 
		FROM Conectadas as C, Voo as V 
		WHERE C.destino = V.origem and C.chegada < V.partida) )
(SELECT origem, destino FROM Conectadas)
EXCEPT
(SELECT origem, destino FROM Voo);

--ou

WITH RECURSIVE Conectadas(origem,destino,partida,chegada) AS (
	(SELECT V1.origem, V2.destino, V1.partida, V2.chegada 
		FROM Voo as V1, Voo as V2
		WHERE V1.destino = V2.origem AND V1.chegada < V2.partida)
	UNION
	(SELECT C.origem, V.destino, C.partida, V.chegada 
		FROM Conectadas as C, Voo as V 
		WHERE C.destino = V.origem and C.chegada < V.partida) )
SELECT distinct origem, destino FROM Conectadas;

-- (d) Escreva uma consulta SQL que retorne os pares de cidade (x,y) tais que é possível chegar em y a partir de x  numa mesma data, mas não existe um voo direto entre x e y, e nem é possível chegar em y a partir de x por meio de uma única escala.

WITH RECURSIVE Conectadas(origem,destino,partida,chegada) AS (
	(SELECT V1.origem, V3.destino, V1.partida, V3.chegada 
		FROM Voo as V1, Voo as V2, Voo as V3 
		WHERE V1.destino = V2.origem AND V2.destino = V3.origem 
		       AND V1.chegada < V2.partida AND V2.chegada < V3.partida)
	UNION
	(SELECT C.origem, V.destino, C.partida, V.chegada 
		FROM Conectadas as C, Voo as V 
		WHERE C.destino = V.origem and C.chegada < V.partida) )
SELECT distinct origem, destino FROM Conectadas;

-- a consulta a seguir não é correta pois NÃO considera destinos com conexões diferentes para as mesmas cidades (x,y)

WITH RECURSIVE Conectadas(origem,destino,partida,chegada) AS (
	(SELECT origem, destino, partida, chegada FROM Voo)
	UNION
	(SELECT C.origem, V.destino, C.partida, V.chegada 
		FROM Conectadas as C, Voo as V 
		WHERE C.destino = V.origem and C.chegada < V.partida) )
(SELECT origem, destino FROM Conectadas)
EXCEPT
((SELECT origem, destino FROM Voo)
UNION
(SELECT V1.origem, V2.destino 
	FROM Voo as V1, Voo as V2
	WHERE V1.destino = V2.origem AND V1.chegada < V2.partida));

-- uma forma de corrigir seria:

WITH RECURSIVE Conectadas(origem,destino,partida,chegada) AS (
	(SELECT origem, destino, partida, chegada FROM Voo)
	UNION
	(SELECT C.origem, V.destino, C.partida, V.chegada 
		FROM Conectadas as C, Voo as V 
		WHERE C.destino = V.origem and C.chegada < V.partida) )
SELECT distinct origem,destino FROM
(
(SELECT origem, destino, partida, chegada FROM Conectadas)
EXCEPT
((SELECT origem, destino, partida, chegada FROM Voo)
UNION
(SELECT V1.origem, V2.destino, V1.partida, V2.chegada
	FROM Voo as V1, Voo as V2
	WHERE V1.destino = V2.origem AND V1.chegada < V2.partida))) as uma_ou_duas_escalas;

--(e) Encontre todos os números de voos que chegam em Albuquerque antes que o voo 425 parta de Albuquerque, mas não mais do que três horas antes que esse voo parta de Albuquerque.

WITH PartidaVoo425(partida) AS 
	( SELECT partida FROM Voo WHERE nvoo = 425 )

SELECT nvoo, partida FROM Voo   
WHERE destino = 'Albuquerque' 
	AND partida < (SELECT partida FROM PartidaVoo425) 
	AND partida + interval '0 03:00:00' > (SELECT partida FROM PartidaVoo425); 

--(f) Encontre todas as cidades possíveis de se alcançar a partir de Los Angeles fazendo uma conexão em Las Vegas (podem haver outras conexões, eventualmente) numa mesma data.

WITH RECURSIVE Conectadas(origem,destino,partida,chegada) AS (
	(SELECT origem, destino, partida, chegada FROM Voo)
	UNION
	(SELECT C.origem, V.destino, C.partida, V.chegada 
		FROM Conectadas as C, Voo as V 
		WHERE C.destino = V.origem and C.chegada < V.partida) )

SELECT destino FROM Conectadas WHERE origem = 'Las Vegas' 
	AND EXISTS (SELECT * FROM Conectadas WHERE origem =  'Los Angeles' AND destino = 'Las Vegas');

--(g) Escreva uma consulta SQL que retorne o conjunto de cidades x que possuem pelo menos dois voos que partem dela. Isto é, existe t e s distintos tais que t e s são cidades destino de voos que partem de x.

SELECT DISTINCT V1.origem FROM Voo V1, Voo V2 WHERE V1.origem = V2.origem AND V1.destino <> V2.destino;

-- (h) Escreva uma consulta SQL que retorne o conjunto de cidades x que podem ser o ponto de partida para se chegar em pelo menos duas outras cidades numa mesma data. Observe que ambas podem estar diretamente ligadas a x por meio de um voo, em vez de uma estar diretamente ligada e outra estar ligada por meio de uma escala.

WITH RECURSIVE Conectadas(origem,destino,partida,chegada) AS (
	(SELECT origem, destino, partida, chegada FROM Voo)
	UNION
	(SELECT C.origem, V.destino, C.partida, V.chegada 
		FROM Conectadas as C, Voo as V 
		WHERE C.destino = V.origem and C.chegada < V.partida) )

SELECT DISTINCT C1.origem FROM Conectadas C1, Conectadas C2 WHERE C1.origem = C2.origem AND C1.destino <> C2.destino;

	
-- (i) Encontre o número de todos os voos que não partem de Los Angeles ou de uma cidade que é possível alcançar a partir de Las Vegas por voo direto ou por uma ou mais conexões  numa mesma data.

WITH RECURSIVE Conectadas(origem,destino,partida,chegada) AS (
	(SELECT origem, destino, partida, chegada FROM Voo)
	UNION
	(SELECT C.origem, V.destino, C.partida, V.chegada 
		FROM Conectadas as C, Voo as V 
		WHERE C.destino = V.origem and C.chegada < V.partida) )

SELECT nvoo FROM Voo WHERE origem <> 'Los Angeles' 
	AND origem NOT IN (SELECT destino FROM Conectadas WHERE origem = 'Las Vegas');


-- (j) Escreva uma consulta SQL que retorne o conjunto de pares de cidades (x,y) tais que é possível chegar em y a partir de x  numa mesma data e que, a partir de y, pode-se chegar a no máximo uma cidade.

WITH RECURSIVE Conectadas(origem,destino,partida,chegada) AS (
	(SELECT origem, destino, partida, chegada FROM Voo)
	UNION
	(SELECT C.origem, V.destino, C.partida, V.chegada 
		FROM Conectadas as C, Voo as V 
		WHERE C.destino = V.origem and C.chegada < V.partida) )

SELECT nvoo FROM Voo WHERE destino NOT IN 
	(SELECT origem FROM Conectadas GROUP BY origem HAVING COUNT(DISTINCT destino) > 1);
