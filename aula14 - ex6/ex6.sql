/*******************************************

MAC0439 - Laboratório de Banco de Dados
Exercício 6

Marcos Kazuya Yamazaki
7577622

*******************************************/

/*--------------------------------------------------------------

classes(classe, tipo, pais, numArmas, calibre, deslocamento)
navios(nome, classe, lancamento)
batalhas(nome, data)
resultados(navio, batalha, desfecho)

Todo navio possui uma classe, que indica o estilo da estrutura
usada na construção do navio. Assim, navios que possuem uma 
estrutura parecida pertencem a uma mesma classe. Geralmente,
atribui-se como nome para uma classe o nome do primeiro navio
construído nela. A relação Classes registra o nome da classe,
o tipo (‘ne’ para navios encouraçados ou ‘nc’ para navios
cruzadores de batalha), o país que construiu o navio, o número
de armas, o calibre (diâmetro das bocas-de-fogo, em polegadas) 
e o deslocamento (massa de água, em toneladas, deslocada pelo
navio quando ele flutua). A relação Navios registra o nome do
navio, o nome de sua classe e o ano em que o navio foi lançado.
A relação Batalhas fornece o nome e a data das batalhas envolvendo
esses navios, enquanto a relação Resultados indica o desfecho
(afundado, danificado, ou ok) dos navios nas batalhas.

--------------------------------------------------------------*/

---- Exercício 1: Escreva as consultas a seguir em SQL. 
--                Use apenas as operações e cláusulas que vimos
--                até a aula de hoje.

-- a) Encontre o deslocamento médio das classes de navios.
select avg(deslocamento) from classes;

-- b) Encontre o número de classes de navios cruzadores de batalha.
select count(*) from classes where tipo like 'nc';

-- c) Encontre o número médio de armas das classes de navios
--    que têm deslocamento acima de 40000.
select avg(numArmas) from classes where deslocamento > 40000;

-- d) Encontre o número médio de armas dos navios das classes
--    que têm deslocamento acima de 40000. (Atente para a diferença
--    entre este item e o anterior! É ou não preciso levar em conta nesse
--    cálculo o número de navios nas classes?)
select avg(c1.numArmas)
from navios as n1, classes as c1 
where n1.classe in (
	  select classe from classes where deslocamento > 40000)
  and c1.classe = n1.classe;

SELECT AVG(numarmas) FROM navios NATURAL             JOIN classes WHERE deslocamento > 40000;
SELECT AVG(numarmas) FROM navios NATURAL RIGHT OUTER JOIN classes WHERE deslocamento > 40000;

-- e) Encontre o ano em que o primeiro navio do país 'USA' foi lançado.
select min(lancamento) from navios where classe in (
	select classe from classes where pais like 'USA'
);

-- f) Encontre o número de navios de cada país.
select c1.pais, count(*) from navios as n1, classes as c1
where c1.classe like n1.classe
group by c1.pais;

-- g) Encontre, para cada classe, o número de navios da
--    classe que “sobreviveram” a uma batalha.
select c1.classe, count(*) from classes as c1, navios as n1
where n1.nome in
		((select nome from navios)
		except
		(select navio 
		from resultados 
		where desfecho like 'afundado'))
		and n1.classe = c1.classe
group by c1.classe;

select classe, count(nome) from navios 
where nome in (select navio from resultados where desfecho <> 'afundado')
group by classe;   

-- h) Encontre as classes que possuem pelo menos três navios.
select c1.classe from navios as n1, classes as c1
where n1.classe like c1.classe
group by c1.classe
having count(*) >= 3;

-- i) Encontre, para cada calibre de classe de navio maior que 15,
--    o deslocamento médio.
select calibre, avg(deslocamento) from classes 
where calibre > 15
group by calibre;

-- j) Encontre o número de navios para cada classe de navio
--    que possua pelo menos dois navios lançados antes de 1920.
select c1.classe, count(n1.classe) 
from classes as c1, navios as n1
where c1.classe = n1.classe and n1.lancamento < 1920
group by c1.classe
having count(n1.classe) > 1;

-- k) O peso (em libras) de um morteiro disparado por uma arma
--    naval é aproximadamente a metade do cubo do seu calibre (em polegadas). 
--    Encontre o peso médio do morteiro dos navios para cada país.
select c1.pais, avg((c1.calibre^3)/2) as peso_Libras
from classes as c1, navios as n1
where n1.classe = c1.classe
group by c1.pais;

-- l) Encontre, para cada classe que possui pelo menos três navios,
--    o número de navios da classe que participaram de uma batalha.
select n0.classe, count(r1.navio)
from navios as n0, resultados as r1
where n0.nome = r1.navio and n0.classe in (
	select n1.classe
	from navios as n1
	group by n1.classe
	having count(n1.classe) > 2
)
group by n0.classe;

---- Exercício 2 (Use apenas as relações Classes e Navios):  
--               Escreva uma consulta em SQL que produza todas as informações
--               disponíveis sobre navios, incluindo as informações disponíveis na
--               relação Classes. Você não deve produzir informações sobre uma
--               classe se não existir nenhum navio da classe na relação Navios.
--               Dica: Use a operação join para resolver este exercício .
select * from navios natural join classes;

---- Exercício 3: Repita o exercício 2, mas também inclua no resultado
--                as classes que não aparecem em Navios.
--                Dica: Use junções externas para resolver este exercício.
select * from classes natural left outer join navios;

