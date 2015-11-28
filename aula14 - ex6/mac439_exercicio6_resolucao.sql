/******************************************************
Laboratório de Bancos de Dados - MAC0439
Lista de Exercícios 6 - 2015 - Proposta de Resolução
*******************************************************/

/** Exercício 1 ***************************************/

--a) Encontre o deslocamento médio das classes de navios.
select avg(deslocamento) from classes;

-- b) Encontre o número de classes de navios cruzadores de batalha.
select count(*) from classes where tipo = 'nc'; 

--c) Encontre o número médio de armas das classes de navios que têm deslocamento acima de 40000.
select avg(numArmas) from classes where deslocamento > 40000;

--d) Encontre o número médio de armas dos navios das classes que têm deslocamento acima de 40000. (Atente para a diferença entre este item e o anterior! É ou não preciso levar em conta nesse cálculo o número de navios nas classes?)
SELECT AVG(numarmas) FROM navios NATURAL JOIN classes WHERE deslocamento > 40000;
-- Elaine, o jeito mais correto seria fazer usando um outer join (pois existe classes na relação CLASSES que não possuem nenhum navio). 
-- Mas eu disse para os alunos que eles não precisavam usar outer joins neste primeiro exercício. Então considere como correto quem respondeu da forma acima. 
SELECT AVG(numarmas) FROM navios NATURAL RIGHT OUTER JOIN classes WHERE deslocamento > 40000;

--e) Encontre o ano em que o primeiro navio do país 'USA' foi lançado.
select min(lancamento) from navios natural join classes where pais = 'USA';

--f) Encontre o número de navios de cada país. 
select pais, count(nome) from classes natural join navios group by pais; 

--g) Encontre, para cada classe, o número de navios da classe que “sobreviveram” a uma batalha. 
select classe, count(nome) from navios 
where nome in (select navio from resultados where desfecho <> 'afundado')
group by classe;   

--h) Encontre as classes que possuem pelo menos três navios.
select classe from navios group by classe having count(nome) >= 3;

--i) Encontre, para cada calibre de classe de navio maior que 15, o deslocamento médio.
select calibre, avg(deslocamento) from classes group by calibre having calibre > 15;
-- ou 
select calibre, avg(deslocamento) from classes where calibre > 15 group by calibre;

--j) Encontre o número de navios para cada classe de navio que possua pelo menos dois navios lançados antes de 1920.
select classe, count(nome) from navios as N group by classe 
having 2 <= (select count(*) from navios where classe = N.classe and lancamento < 1920);
-- ou 
select classe, count(nome) from navios as N 
where 2 <= (select count(*) from navios where classe = N.classe and lancamento < 1920)
group by classe;

--k) O peso (em libras) de um morteiro disparado por uma arma naval é aproximadamente a metade do cubo do seu calibre (em polegadas). Encontre o peso médio do morteiro dos navios para cada país.
SELECT pais,AVG((calibre*calibre*calibre)/2) FROM navios NATURAL JOIN classes GROUP BY pais;

--l) Encontre, para cada classe que possui pelo menos três navios, o número de navios da classe que participaram de uma batalha.
SELECT classe, COUNT(nome) FROM navios JOIN resultados ON nome = navio  
WHERE classe IN 
   (SELECT classe FROM navios NATURAL JOIN classes GROUP BY classe HAVING COUNT(navios.nome) >= 3)
GROUP BY classe;

/** Exercício 2 ***************************************/
/** (Use apenas as relações Classes e Navios): Escreva uma consulta em SQL que produza todas as informações disponíveis sobre navios, incluindo as informações disponíveis na relação Classes. Você não deve produzir informações sobre uma classe se não existir nenhum navio da classe na relação Navios.**/
SELECT * FROM navios NATURAL LEFT OUTER JOIN classes;

/** Exercício 3 ***************************************/
/** Repita o exercício 3, mas também inclua no resultado, para qualquer classe C que não aparece em Navios, informações sobre o navio que possui o mesmo nome C que a sua classe. **/
/** Para testar a resposta, é precisao que haja ao menos uma classe em Classes que não foi citada em Navios. **/
SELECT * FROM navios NATURAL FULL OUTER JOIN classes;