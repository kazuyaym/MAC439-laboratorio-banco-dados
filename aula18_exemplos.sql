CREATE OR REPLACE FUNCTION olamundo() RETURNS INT AS
$$
    SELECT 1;
$$ LANGUAGE sql;
SELECT olamundo();  -- ex. de chamada

CREATE OR REPLACE FUNCTION soma_numeros(IN nr1 INT, IN nr2 INT)
RETURNS INT AS
$$
    SELECT $1 + $2;
$$ LANGUAGE sql;
SELECT soma_numeros(300, 700) AS resposta;   -- ex. de chamada

------------------------------------------------

CREATE TEMP TABLE Empregados (
     nome TEXT, salario NUMERIC, idade INTEGER, baia POINT);
 
INSERT INTO empregados VALUES('João',2200,21,point('(1,1)'));
INSERT INTO empregados VALUES('José',4200,30,point('(2,1)'));
 
CREATE FUNCTION dobrar_salario(emp Empregados) RETURNS NUMERIC AS $$
        SELECT emp.salario * 2 AS salario;
$$ LANGUAGE SQL;
 
SELECT nome, dobrar_salario(empregados.*) AS salario_sonhado
FROM empregados WHERE nome = 'João';
-- ou
SELECT nome, dobrar_salario(ROW(nome, salario*1.1, idade, baia)) 
  AS salario_sonhado FROM empregados;

------------------------------------------------

CREATE OR REPLACE FUNCTION novo_empregado() RETURNS empregados AS $$
   SELECT text 'Nenhum' AS nome, 1000.0 AS salario,
          25 AS idade, point '(2,2)' AS baia;
$$ LANGUAGE SQL;
-- OU
CREATE OR REPLACE FUNCTION novo_empregado() RETURNS empregados AS $$
   SELECT ROW('Nenhum', 1000.0, 25, '(2,2)')::empregados;
$$ LANGUAGE SQL;

-- Chamar assim:

SELECT novo_empregado();
-- ou
SELECT * FROM novo_empregado();

------------------------------------------------

CREATE TEMP TABLE teste (testeid INT, testesubid INT, testename text);
INSERT INTO teste VALUES (1, 1, 'João');
INSERT INTO teste VALUES (1, 2, 'José');
INSERT INTO teste VALUES (2, 1, 'Maria');
 
CREATE FUNCTION getteste(INT) RETURNS teste AS $$
   SELECT * FROM teste WHERE testeid = $1;
$$ LANGUAGE SQL;
SELECT *, UPPER(testename) FROM getteste(1) AS t1;

DROP FUNCTION getteste(INT);

CREATE OR REPLACE FUNCTION getteste(INT) RETURNS SETOF teste AS $$
SELECT * FROM teste WHERE testeid = $1;
$$ LANGUAGE SQL;
SELECT * FROM getteste(1) AS t1;

------------------------------------------------

CREATE OR REPLACE FUNCTION constroi_matriz(anyelement, anyelement) RETURNS anyarray AS $$
        SELECT ARRAY[$1, $2];
$$ LANGUAGE SQL;
 
SELECT constroi_matriz(1, 2) AS intarray, constroi_matriz('a'::text, 'b') AS textarray;
 
CREATE OR REPLACE  FUNCTION eh_maior(anyelement, anyelement) RETURNS BOOLEAN AS $$
        SELECT $1 > $2;
$$ LANGUAGE SQL;
 
SELECT eh_maior(char 'b' , char'a');

------------------------------------------------


CREATE OR REPLACE FUNCTION func_escopo() RETURNS INTEGER AS $$
DECLARE
   quantidade INTEGER := 30;
BEGIN
   RAISE NOTICE 'Aqui a quantidade é %', quantidade;  -- A quantidade aqui é 30
   quantidade := 50;
   
   -- Criar um sub-bloco
   DECLARE
       quantidade INTEGER := 80;
   BEGIN
       RAISE NOTICE 'Aqui a quantidade é %', quantidade;  -- A quantidade aqui é 80
   END;
   RAISE NOTICE 'Aqui a quantidade é %', quantidade;  -- A quantidade aqui é 50
   RETURN quantidade;
END;  $$ LANGUAGE plpgsql;  

SELECT func_escopo();

------------------------------------------------
CREATE FUNCTION func(VARCHAR, INTEGER) RETURNS INTEGER AS $$
DECLARE
  param1 ALIAS FOR $1;
  param2 ALIAS FOR $2; 
BEGIN
  RETURN length(param1) + param2; 
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION func(param1 VARCHAR, param2 INTEGER) RETURNS INTEGER AS $$
BEGIN
  RETURN length(param1) + param2; 
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION  func(VARCHAR, INTEGER);
CREATE OR REPLACE FUNCTION func(VARCHAR, INTEGER) RETURNS INTEGER AS $$
BEGIN
  RETURN length($1) + $2; 
END;
$$ LANGUAGE plpgsql;

select func('oi',5);
------------------------------------------------

CREATE FUNCTION concat_atrib_selecionados(tupla empregados)
                                             RETURNS text AS $$
BEGIN
   RETURN tupla.nome || tupla.salario || tupla.idade;
END;
$$ LANGUAGE plpgsql;

select concat_atrib_selecionados(empregados.*)
from empregados limit 1;
------------------------------------------------

CREATE OR REPLACE FUNCTION somar_tres_valores(v1 anyelement,
                            v2 anyelement, v3 anyelement)
RETURNS anyelement AS $$
DECLARE
   resultado ALIAS FOR $0; 
BEGIN
   resultado := v1 + v2 + v3;
   RETURN resultado;
END;
 
$$ LANGUAGE plpgsql;
 
SELECT somar_tres_valores(10,20,30);

------------------------------------------------
CREATE TEMP TABLE datas(data date, hora time);
CREATE OR REPLACE FUNCTION data_ctl(opcao CHAR, vdata DATE, vhora TIME) RETURNS CHAR(10) AS $$
DECLARE
    retorno CHAR(10);
BEGIN
    IF opcao = 'I' THEN 
        INSERT INTO datas (data, hora) VALUES (vdata, vhora);
        retorno := 'INSERT';
    ELSIF opcao = 'U' THEN 
        UPDATE datas SET data = vdata, hora = vhora WHERE data='1995-11-01';
        retorno := 'UPDATE';
    ELSIF opcao = 'D' THEN 
        DELETE FROM datas WHERE data = vdata;
        retorno := 'DELETE';
    ELSE
        retorno := 'NENHUMA';
    END IF;     
    RETURN retorno;
END;
$$ LANGUAGE plpgsql;

select data_ctl('I','1995-11-01', '08:15');
SELECT data_ctl('U','1997-11-01','06:36');
SELECT data_ctl('D','1997-11-01','06:36');
SELECT * FROM datas;

------------------------------------------------

drop function nome_empregado(numeric);
CREATE OR REPLACE FUNCTION nome_empregado (NUMERIC)
   RETURNS SETOF TEXT AS $$
   DECLARE
        registro RECORD;
        sal ALIAS FOR $1;
   BEGIN
        FOR registro IN SELECT * FROM empregados WHERE salario >= sal LOOP
                RETURN NEXT registro.nome;
        END LOOP;
        RETURN;
   END;
$$ LANGUAGE 'plpgsql';
 
SELECT * FROM nome_empregado (2200);
------------------------------------------------
CREATE TYPE salario_por_idade AS (idade INT, salario NUMERIC);

CREATE FUNCTION obtem_salarios() RETURNS SETOF salario_por_idade AS $$
DECLARE
   registro RECORD;
BEGIN
   FOR registro IN SELECT idade, AVG(salario) FROM empregados GROUP BY idade LOOP
                RETURN NEXT registro;
        END LOOP;
        RETURN;
END
$$ LANGUAGE 'plpgsql';


SELECT obtem_salarios();

CREATE FUNCTION obtem_salarios2() RETURNS SETOF salario_por_idade AS $$
BEGIN
   RETURN QUERY 
       SELECT idade, AVG(salario) FROM empregados GROUP BY idade ;
END
$$ LANGUAGE 'plpgsql';


SELECT obtem_salarios2();

------------------------------------------------

CREATE OR REPLACE FUNCTION ContaAteDez1() RETURNS SETOF INT AS $$ 
DECLARE
   contador INT := 0;
BEGIN 
    LOOP
        IF contador < 10 THEN
            contador := contador + 1;
            RETURN NEXT contador;
	ELSE
	    EXIT; -- sai do laco
	END IF;
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;

SELECT ContaAteDez1();

CREATE OR REPLACE FUNCTION ContaAteDez2() RETURNS SETOF INT AS $$ 
DECLARE
   contador INT := 0;
BEGIN 
    LOOP
         contador := contador + 1;
         RETURN NEXT contador;

	 EXIT WHEN contador = 10; -- sai do laco
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;

SELECT ContaAteDez2();

------------------------------------------------

CREATE TABLE Departamento(cod INT PRIMARY KEY, nome VARCHAR(20)); 
CREATE TABLE Funcionario(nome VARCHAR(30) PRIMARY KEY, cod_dept INT REFERENCES Departamento(cod));

CREATE OR REPLACE FUNCTION insereFunc(nome_func VARCHAR(30), cod_dept INT) 
RETURNS VOID AS $$
BEGIN
    BEGIN   -- Comeca bloco de tratamento de excecoes
       INSERT INTO Funcionario VALUES (nome_func, cod_dept);
           
       EXCEPTION WHEN SQLSTATE '23503' THEN
       BEGIN
           RAISE NOTICE 'O departamento informado para o func. nao existe!';
           RETURN;
       END;
    END;
    RAISE NOTICE 'O func. foi inserido com sucesso!';
END;
$$
LANGUAGE plpgsql;

-- SELECT insereFunc('John', 1);