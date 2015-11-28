/****************************************

MAC0439 - Laboratório de Banco de Dados
Exercício 4

Marcos Kazuya Yamazaki
7577622

*****************************************/

/*******************************************************************************************

MAC439 – Laboratório de Bancos de Dados 25/09/2015

Aula 12: Linguagem SQL – Comandos para consultas envolvendo múltiplas relações

Antes de começar o exercício, execute o script “aula12_esquema_dados.sql”, disponível no
Paca. Ele criará um schema chamado “aula12” e criará dentro dele as tabelas a serem usadas.
BD Navios importantes da 2ª Guerra Mundial - Esse BD envolve as seguintes relações:

Classes(classe, tipo, pais, numArmas, calibre, deslocamento)
Navios(nome, classe, lancamento)
Batalhas(nome, data)
Resultados(navio, batalha, desfecho)

Todo navio possui uma classe, que indica o estilo da estrutura usada na construção do navio.
Assim, navios que possuem uma estrutura parecida pertencem a uma mesma classe. Geralmente,
atribui-se como nome para uma classe o nome do primeiro navio construído nela. A relação
Classes registra o nome da classe, o tipo (‘ne’ para nvaios encouraçados ou ‘nc’ para navios
cruzadores de batalha), o país que construiu o navio, o número de armas, o calibre (diâmetro das
bocas-de-fogo, em polegadas) e o deslocamento (massa de água, em toneladas, deslocada pelo
navio quando ele flutua). A relação Navios registra o nome do navio, o nome de sua classe e o
ano em que o navio foi lançado. A relação Batalhas fornece o nome e a data das batalhas
envolvendo esses navios, enquanto a relação Resultados indica o desfecho (afundado,
danificado, ou ok) dos navios nas batalhas.
Exercício: As consultas a seguir se referem ao BD Navios importantes da 2ª Guerra Mundial.
Escreva-as em SQL. Use apenas as operações e cláusulas que vimos até a aula de hoje e não se
preocupe se o resultado das consultas incluir tuplas repetidas.

a) Encontre o tipo e o calibre do navio Haruna.
b) O tratado de Washington (de 1921) proibiu navios de guerra com deslocamento maior que 35000
   toneladas. Liste os navios que não violaram esse tratado.
c) Encontre os países das classes de navios que possuem o menor deslocamento.
d) Liste o nome dos navios que participaram de batalhas, mas que não aparecem na relação Navios.
e) Liste a classe, o lançamento e o tipo dos navios que não foram afundados em batalha. O resultado
   deve estar em ordem decrescente de classe e, para cada classe, em ordem crescente de lançamento.
f) Encontre o número de armas dos navios que foram lançados mais recentemente.
g) Encontre os nomes dos navios cujo deslocamento era o maior entre os navios do mesmo tipo.
h) Encontre os pares de navios que pertencem a uma mesma classe e que cujos lançamentos
   ocorreram em um intervalo de tempo inferior a 2 anos. Um par de nomes deve ser listado uma
   única vez. Por exemplo, se o par (Musashi, Resolution) é listado, então (Resolution, Musashi) não
   deve ser listado.
i) Encontre os navios que lutaram em mais de uma batalha.
j) Encontre os países que têm ao menos um navio que não participou de nenhuma batalha ou que
   não foi afundado em batalha.
k) Encontre os nomes dos navios que participaram de batalhas que ocorreram depois da batalha de
   Guadalacanal.
l) Encontre os navios que “sobreviveram para combater novamente”, ou seja, os navios que foram
   danificados em uma batalha, mas que participaram de outra depois.
m) Encontre os países que não possuem os navios mais antigos.
n) Encontre os navios mais antigos entre os navios das classes que possuem menos armas.

*****************************************************************************************************/

-- a)
select tipo, calibre
from classes
where classe in (select classe
				 from navios
				 where nome = 'Haruna');

-- b)
select nome
from navios
where classe  not in
			(select classe
			 from classes
			 where deslocamento > 35000);

-- c)
select pais
from classes
where deslocamento <= all (select deslocamento
                           from classes);

-- d)
select navio 
from resultados 
where navio not in (select nome 
	                from navios); 

-- e)
select n.classe, n.lancamento, c.tipo
from navios n, classes c 
where n.nome in (select navio 
                 from resultados 
                 where desfecho <> 'afundado') 
  and n.classe = c.classe
order by n.classe desc, n.lancamento asc;

-- f)
select numArmas from classes where classe in
	(select classe from navios where lancamento >= all 
		(select lancamento from navios
));

-- g)
select nome from navios where classe in(
	select classe from classes as c1 where deslocamento >= all(
		select deslocamento from classes as c2 where c1.tipo = c2.tipo
)); 

-- h)
select n1.nome, n2.nome from navios as n1, navios as n2 
where n1.classe = n2.classe 
and   n1.lancamento - n2.lancamento < 2
and   n1.lancamento - n2.lancamento >= 0
and   n1.nome < n2.nome;

-- i)
select r.navio from resultados r, resultados r2 
where r.navio = r2.navio and r.batalha < r2.batalha;

-- j)
select pais from classes where classe in
	(select classe from navios where nome not in 
		(select navio from resultados where desfecho = 'afundado'
));

-- k)
select navio 
from resultados as r, (select data 
	                   from batalhas 
	                   where nome = 'Guadalacanal') as DATA1
where exists (
	select * 
	from batalhas as b 
	where b.nome = r.batalha 
	  and b.data > DATA1.data
);
	
-- l) Encontre os navios que “sobreviveram para combater novamente”, ou seja, os navios que foram danificados em uma batalha, mas que participaram de outra depois.
select navio 
from resultados as r1
where exists (
	select * 
	from resultados as r2
	where r2.desfecho = 'danificado' and
		  r1.navio = r2.navio 
);

-- m) Encontre os países que não possuem os navios mais antigos.
select c1.pais from classes as c1 where c1.classe not in(
	select c2.classe from classes as c2 where c2.classe in(
		select n.classe from navios as n where n.lancamento <= all(
			select n2.lancamento from navios as n2
)));

-- n) Encontre os navios mais antigos entre os navios das classes que possuem menos armas.
select nome from navios where classe in (
	select n.classe from classes as n where n.numArmas <= all(
		select n2.numArmas from classes as n2
));