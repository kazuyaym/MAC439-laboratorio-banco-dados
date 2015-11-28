/******************************************************
Laboratório de Bancos de Dados - MAC0439
Lista de Exercícios 10 - 2015 - Proposta de Resolução
*******************************************************/

/** Exercício ***************************************/

-- a) Faça uma função que receba como parâmetro de entrada o nome de um navio e que devolva a sua idade.  (Dica: a função extract(year from d) do PostgreSQL devolve o ano de uma data d e a função now() devolve a data atual.)

CREATE OR REPLACE FUNCTION IdadeNavio(nome_navio VARCHAR(20)) RETURNS INTEGER AS $$
   SELECT (extract(year from now())::int  - lancamento)as idade FROM navios WHERE nome = nome_navio;
$$ LANGUAGE 'sql';

-- select IdadeNavio('Yamato');

-- b) Faça uma função que receba como entrada uma string e que devolva os nomes das batalhas que começam com essa string. Você deve considerar também os nomes de batalhas que aparecem na relação Resultados, além dos que aparecem em Batalhas.

CREATE OR REPLACE FUNCTION BuscaBatalhas(prefixo_batalha VARCHAR(20)) RETURNS SETOF VARCHAR(20) AS $$
   (SELECT nome FROM Batalhas WHERE nome like prefixo_batalha || '%')
   UNION
   (SELECT navio FROM Resultados WHERE navio like prefixo_batalha || '%');
$$ LANGUAGE 'sql';

-- select BuscaBatalhas('Gua');

-- c) Faça uma função que receba um ano como entrada e que devolva o nome do navio cujo ano de lançamento foi o mais próximo desse ano (se houver mais um de navio nessas condições, você pode devolver qualquer um deles).

CREATE OR REPLACE FUNCTION NavioMaisProximo(ano INT) RETURNS VARCHAR(20) AS $$
  DECLARE primeira_tupla BOOLEAN := TRUE;
  DECLARE menor_dif INT;
  DECLARE navio_resp VARCHAR(20) := NULL;
  DECLARE tupla RECORD;
BEGIN
  FOR tupla IN SELECT nome, lancamento FROM Navios LOOP
      IF primeira_tupla OR abs(ano - tupla.lancamento) < menor_dif THEN
         navio_resp := tupla.nome;
         menor_dif := abs(ano - tupla.lancamento);
         primeira_tupla := FALSE;
      END IF;
  END LOOP;
RETURN navio_resp;
END; $$ LANGUAGE 'plpgsql';

-- select * from NavioMaisProximo(1915);

-- ou, para o caso de mais de um navio lancado num mesmo ano:

CREATE OR REPLACE FUNCTION NavioMaisProximo2(ano INT) RETURNS SETOF VARCHAR(20) AS $$
  DECLARE primeira_tupla BOOLEAN := TRUE;
  DECLARE menor_dif INT;
  DECLARE tupla RECORD;
BEGIN
  FOR tupla IN SELECT nome, lancamento FROM Navios LOOP
      IF primeira_tupla OR abs(ano - tupla.lancamento) < menor_dif THEN
         menor_dif := abs(ano - tupla.lancamento);
         primeira_tupla := FALSE;
      END IF;
  END LOOP;
  FOR tupla IN SELECT nome FROM Navios WHERE abs(ano - lancamento) = menor_dif LOOP
      RETURN NEXT tupla.nome;
  END LOOP;
  RETURN;
END; $$ LANGUAGE 'plpgsql';
-- select * from NavioMaisProximo2(1915);


-- d) Faça um procedimento que receba um nome de uma batalha como parâmetro de entrada e determine se dessa batalha participaram navios cujo ano de lançamento é posterior ao ano da batalha. Se sim, o procedimento deve alterar o ano de lançamento do navio  para o ano em que a batalha ocorreu. 


CREATE OR REPLACE FUNCTION VerificaDataBatalha(nome_batalha VARCHAR(20)) RETURNS VOID AS $$
  DECLARE ano_batalha INT;
BEGIN
    ano_batalha := (SELECT extract(year from data)::int FROM Batalhas WHERE nome = nome_batalha);

    UPDATE Navios SET lancamento = ano_batalha
    WHERE nome IN
    	(SELECT navio FROM Resultados JOIN Navios ON navio = nome AND batalha = nome_batalha AND lancamento > ano_batalha);
    	
END; $$ LANGUAGE 'plpgsql';

--update Navios set lancamento = 1950 where navio = 'Washington';
--select VerificaDataBatalha('Guadalacanal');
--select * from navios;

-- e) Faça um procedimento que receba um nome de navio, uma classe e um ano de lançamento como parâmetros de entrada e que insira esses dados como um novo navio no BD. Entretanto, se já existir um outro navio com o mesmo nome na relação Navios (problema que será assinalado por meio de uma exceção com SQLSTATE igual a '23000', correspondente  a uma violação da restrição de primary key), acrescente um sufixo numérico no nome navio e tente inseri-lo novamente. Caso o novo nome também já exista, vá “incrementando” o número do sufixo até encontrar um nome de navio que ainda não esteja no BD. Por exemplo, caso o procedimento seja chamado para incluir o navio “Rei dos Mares”, mas esse nome de navio já esteja no BD, então modifique o nome do novo navio para “Rei dos Mares 2” e tente a inclusão novamente. Caso esse novo nome também já esteja no BD, tente incluir “Rei dos Mares 3”,  e assim por diante.

CREATE OR REPLACE FUNCTION InsereNavio(nome_navio VARCHAR(20), classe_navio VARCHAR(20), ano_navio INT) RETURNS VOID AS $$
  DECLARE sufixo INT := 2;
  DECLARE base_nome VARCHAR(20) := nome_navio;
BEGIN
  LOOP
     BEGIN
        INSERT INTO Navios (nome, classe, lancamento) VALUES (nome_navio,classe_navio,ano_navio);
        EXIT;
        
        EXCEPTION WHEN SQLSTATE '23000' THEN 
        BEGIN
	   nome_navio := base_nome || sufixo;
	   sufixo := sufixo + 1;
        END;
     END;
  END LOOP; 
END; $$ LANGUAGE 'plpgsql';

--select InsereNavio('Yamato', 'Yamato', 2000);
--select * from navios;
