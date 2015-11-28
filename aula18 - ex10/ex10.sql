/*******************************************

MAC0439 - Laboratório de Banco de Dados
Exercício 10

Marcos Kazuya Yamazaki
7577622

*******************************************/

-- Stored Procedures
-- Exercício: Escreva as seguintes funções ou procedimentos, com base no esquema a seguir:
-- BD Navios importantes da 2ª Guerra Mundial

	classes(classe, tipo, pais, numArmas, calibre, deslocamento)
	navios(nome, classe, lancamento)
	batalhas(nome, data)
	resultados(navio, batalha, desfecho)

-- a) Faça uma função que receba como parâmetro de entrada o nome de um navio e que devolva a sua
--    idade. (Dica: a função extract(year from d) do PostgreSQL devolve o ano de uma data d e a função
--    now() devolve a data atual.)

create or replace function idadeNavio(nomeNavio varchar(255)) returns integer as $$
begin 
	return (select extract(year from now())-lancamento from navios where nome like nomeNavio);
end;  $$ LANGUAGE plpgsql;  

-- b) Faça uma função que receba como entrada uma string e que devolva os nomes das batalhas que
--    começam com essa string. Você deve considerar também os nomes de batalhas que aparecem na
--    relação Resultados, além dos que aparecem em Batalhas. (Dica: o operador || concatena duas
--    strings.)

create or replace function batalhaNome(string varchar) returns setof varchar as $$
declare
	tupla RECORD;
begin 
	for tupla in select batalha from resultados where batalha like string || '%' loop
		return next tupla;
	end loop;

	for tupla in select nome from batalhas where nome like string || '%' loop
		return next tupla;
	end loop;

	return;
end;  $$ LANGUAGE plpgsql;  

-- c) Faça uma função que receba um ano como entrada e que devolva o nome do navio cujo ano de
--    lançamento foi o mais próximo desse ano. (Dica: a função abs(n) devolve o valor absoluto de um
--    número n.)

create or replace function navioProximo(int) returns varchar as $$
declare
	tupla record;
	return_navio varchar;
	year_mais_prox int := null;
begin 
	for tupla in select * from navios loop
		if year_mais_prox is null then 
			year_mais_prox := abs($1-tupla.lancamento);
			return_navio := tupla.nome;
		elseif abs($1-tupla.lancamento) < year_mais_prox then
			year_mais_prox := abs($1-tupla.lancamento);
			return_navio := tupla.nome;
		end if;
	end loop;

	return return_navio;
end;  $$ LANGUAGE plpgsql;  

-- d) Faça um procedimento que receba um nome de uma batalha como parâmetro de entrada e
--    determine se dessa batalha participaram navios cujo ano de lançamento é posterior ao ano da
--    batalha. Se sim, o procedimento deve alterar o ano de lançamento do navio para o ano em que a
--    batalha ocorreu.

create or replace function alteraAno(varchar) returns void as $$
declare
	tupla record;
	ano INT;
begin 
	ano := (select extract(year from data) from batalhas where nome like $1);

	for tupla in (select navio from resultados where batalha like $1) loop
		if ano < (select lancamento from navios where nome like tupla.navio) then
			update navios set lancamento = ano where nome like tupla.navio;
		end if;
	end loop;
	
end;  $$ LANGUAGE plpgsql;  

-- TESTE --------------------------------------------------------------------------------------------
-- insert into navios (nome, classe, lancamento) values ('kazuya', 'Tennessee', 2014);
-- insert into resultados (navio, batalha, desfecho) values ('kazuya', 'North Atlantic', 'afundado');
-- select alteraAno('North Atlantic');
-----------------------------------------------------------------------------------------------------

-- e) Faça um procedimento que receba um nome de navio, uma classe e um ano de lançamento como
--    parâmetros de entrada e que insira esses dados como um novo navio no BD. Entretanto, se já existir
--    um outro navio com o mesmo nome na relação Navios (problema que será assinalado por meio de
--    uma exceção com SQLSTATE igual a '23000', correspondente a uma violação da restrição de
--    primary key), acrescente um sufixo numérico no nome do navio e tente inseri-lo novamente. Caso o
--    novo nome também já exista, vá “incrementando” o número do sufixo até encontrar um nome de
--    navio que ainda não esteja no BD. Por exemplo, caso o procedimento seja chamado para incluir o
--    navio “Rei dos Mares”, mas esse nome de navio já esteja no BD, então modifique o nome do novo
--    navio para “Rei dos Mares 2” e tente a inclusão novamente. Caso esse novo nome também já esteja
--    no BD, tente incluir “Rei dos Mares 3”, e assim por diante.

create or replace function insere(varchar, varchar, int) returns void as $$
declare
	tupla record;
	contador INT;
begin 
	insert into navios values($1, $2, $3);
	exception when sqlstate '23000' then
	begin
		contador := 2;
		loop
			if not exists (select nome from navios where (nome like ($1 || ' ' || contador))) then
				insert into navios values($1 || ' ' || contador, $2, $3);
				exit;
			end if;
			contador := contador + 1; 
		end loop;
	end;
end;  $$ LANGUAGE plpgsql;  

-- select insere('teste', 'classe', 2015);