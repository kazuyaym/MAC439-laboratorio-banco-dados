-- Laboratorio de Bancos de Dados - MAC0439
-- Lista de Exercicios 4 - 2015 - Proposta de Resolucao

--a) Encontre o tipo e o calibre do navio Haruna.

select tipo, calibre from Classes as C, Navios as N
where C.classe = N.classe and nome like 'Haruna'; 

--OU

select tipo, calibre from Classes 
where classe = (select classe from Navios where nome like 'Haruna');

--b) O tratado de Washington (de 1921) proibiu navios de guerra com deslocamento maior que 35000 toneladas. Liste os navios que não violaram esse tratado.

select nome from Navios as N, Classes as C 
where N.classe = C.classe and deslocamento <= 35000;

-- OU

select nome from Navios 
where classe not in (select classe from Classes where deslocamento > 35000);

--c) Encontre os paises das classes de navios que possuem o menor deslocamento.

select pais from Classes where deslocamento <= ALL (
	select deslocamento from Classes ); 

--d) Liste o nome dos navios que participaram de batalhas, mas que não aparecem na relação Navios.

select navio from Resultados
where navio not in (select nome from Navios);

--e) Liste a classe, o lançamento e o tipo dos navios que não foram afundados em batalha. O resultado deve estar em ordem decrescente de classe e, para cada classe, em ordem crescente de lançamento. 

-- Nesta primeira solução, são incluídos também na resposta o navios que nunca participaram de batalha nenhuma.
select N.classe, lancamento, tipo from Navios as N, Classes as C
where N.classe = C.classe and nome not in (
	select navio from Resultados where desfecho = 'afundado' )
order by N.classe desc, lancamento asc;

-- Esta segunda solução "varre" somente os navios em Navios que participaram de alguma batalha. Mas ela tem um problema em potencial: se o navio participou de mais de uma batalha e só afundou na última delas, ele acaba sendo incluído (erroneamente!) no conjunto resposta. Por essa razão, considere somente meio correto para quem optou por essa resolução. (A resposta fica bem diferente da anterior.)

select N.classe, lancamento, tipo from Navios as N, Classes as C, Resultados as R 
where N.classe = C.classe and R.navio = N.nome and desfecho <> 'afundado'
order by N.classe desc, lancamento asc;

-- Esta terceira solução é a versão correta da anterior. (Para os dados que estão no BD de teste, a resposta dessa e da anterior ficam iguais.)

select N.classe, lancamento, tipo from Navios as N, Classes as C, Resultados as R 
where N.classe = C.classe and R.navio = N.nome and N.nome not in (
	select navio from Resultados where desfecho = 'afundado' )
order by N.classe desc, lancamento asc;

--f) Encontre o numero de armas dos navios que foram lançados mais recentemente.  

select numArmas from Classes as C, Navios as N 
where C.classe = N.classe and lancamento >= all (
	select lancamento from Navios );

--g) Encontre os nomes dos navios cujo deslocamento era o maior entre os navios do mesmo tipo.

select nome from Navios as N, Classes as C 
where C.classe = N.classe and deslocamento >= ALL (
	select deslocamento from Classes where tipo = C.tipo );

--h) Encontre os pares de navios que pertencem a uma mesma classe e que cujos lançamentos ocorreram em um intervalo de tempo inferior a 2 anos.  Um par de nomes deve ser listado uma única vez. Por exemplo, se o par (Musashi, Resolution) é listado, então (Resolution, Musashi) não deve ser listado.

select N1.nome, N2.nome from Navios as N1, Navios as N2
where N1.classe = N2.classe and 
      ( (N1.lancamento <=  N2.lancamento and N2.lancamento - N1.lancamento < 2) or  
	(N1.lancamento >  N2.lancamento and N1.lancamento - N2.lancamento < 2) ) and
      N1.nome < N2.nome;

--i) Encontre os navios que lutaram em mais de uma batalha.

select navio from Resultados as R where exists (
	select * from Resultados where navio = R.navio and batalha <> R.batalha );

-- OU

select R1.navio from Resultados as R1, Resultados as R2
where R1.navio = R2.navio and R1.batalha <> R2.batalha; 

--j) Encontre os países que têm ao menos um navio que não participou de nenhuma batalha ou que não foi afundado em batalha.

select pais from Classes as C, Navios as N 
where C.classe = N.classe and (nome not in (select navio from Resultados) or
		not exists (select * from Resultados where navio = N.nome and desfecho = 'afundado'));

--k) Encontre os nomes dos navios que participaram de batalhas que ocorreram depois da batalha de Guadalacanal. 

select navio from Resultados as R, Batalhas as B 
where R.batalha = B.nome and data > (select data from Batalhas where nome = 'Guadalacanal');

--l) Encontre os navios que “sobreviveram para combater novamente”, ou seja, os navios que foram danificados em uma batalha,  mas que participaram de outra depois.

select R1.navio from Resultados as R1, Resultados as R2, Batalhas as B1, Batalhas as B2
where R1.navio = R2.navio and R1.desfecho = 'danificado' 
	and R1.batalha = B1.nome and R2.batalha = B2.nome 
	and B1.data < B2.data;
	 
--m) Encontre os países que não possuem os navios mais antigos.

select pais from Classes where classe not in (
	select classe from Navios where lancamento >= all (select lancamento from Navios));

--n) Encontre os navios mais antigos entre os navios das classes que possuem menos armas.

select nome from Navios where classe in (
	(select classe from Classes where numArmas <= ALL(select numArmas from Classes)))
	and lancamento <= ALL (select lancamento from Navios where classe in (
		(select classe from Classes where numArmas <= ALL(select numArmas from Classes))));
