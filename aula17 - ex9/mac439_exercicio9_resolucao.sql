/******************************************************
Laboratório de Bancos de Dados - MAC0439
Lista de Exercícios 9 - 2015- Proposta de Resolução
*******************************************************/

/** Exercício 1 ***************************************/

-- a) Na inserção de uma nova tupla em Resultados com desfecho diferente de 'ok', permita que a inserção seja feita, mas mude o desfecho para 'ok'. 

CREATE OR REPLACE FUNCTION MudaDesfechoParaOk()
RETURNS TRIGGER AS $$
BEGIN
   UPDATE Resultados SET desfecho = 'ok' 
	WHERE navio = NEW.navio AND batalha = NEW.batalha;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER GaranteNovoResultadoOk
AFTER INSERT ON Resultados
FOR EACH ROW
WHEN (NEW.desfecho <> 'ok')
EXECUTE PROCEDURE MudaDesfechoParaOk();

-- b) Na inserção ou alteração de um navio, se a classe do navio for informada, garanta que a operação só será realizada se a classe existir na relação Classes.

CREATE OR REPLACE FUNCTION VerificaClasseNavio()
RETURNS TRIGGER AS $$
BEGIN
   IF (NOT EXISTS (SELECT classe FROM Classes WHERE classe = NEW.classe)) THEN
      RETURN NULL; -- CANCELA A OPERACAO
   END IF;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER GaranteClasseNavio
BEFORE INSERT OR UPDATE of classe ON Navios
FOR EACH ROW
WHEN (NEW.classe IS NOT NULL)
EXECUTE PROCEDURE VerificaClasseNavio();

-- c) Na inserção de um novo navio, quando a classe do navio não for informada, use o próprio nome do navio como nome para a classe. Nesse caso, se não existir uma classe com esse nome na relação Classes, insira-a antes (usando 'nc' como tipo,  'EUA' para país e NULL para os demais atributos).

CREATE OR REPLACE FUNCTION VerificaInsereClasseNovoNavio()
RETURNS TRIGGER AS $$
BEGIN
   IF (NOT EXISTS (SELECT classe FROM Classes WHERE classe = NEW.nome)) THEN
      INSERT INTO Classes VALUES (NEW.nome, 'nc', 'EUA', NULL, NULL, NULL);
   END IF;
   NEW.classe = NEW.nome;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER GaranteClasseNovoNavio
BEFORE INSERT ON Navios
FOR EACH ROW
WHEN (NEW.classe IS NULL)
EXECUTE PROCEDURE VerificaInsereClasseNovoNavio();


-- d) Quando a data de uma batalha for modificada, garanta que nenhum navio que lutou na batalha tenha um ano de lançamento posterior ao ano da batalha. (Dica: a função extract(year from d) do PostgreSQL devolve o ano de uma data d.)

CREATE OR REPLACE FUNCTION VerificaDataBatalha()
RETURNS TRIGGER AS $$
BEGIN
   IF (EXISTS (SELECT * 
		FROM (SELECT nome FROM Navios WHERE lancamento > extract(year from NEW.data)) as N,
		     Resultados as R WHERE N.nome = R.navio AND R.batalha = NEW.nome)) THEN
	RETURN NULL;
   END IF;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER GaranteDataBatalha
BEFORE UPDATE OF data ON Batalhas
FOR EACH ROW
EXECUTE PROCEDURE VerificaDataBatalha();

-- e) Garanta, em todas as circunstâncias que podem causar uma violação, que exista no máximo 5 navios em uma mesma classe.

CREATE OR REPLACE FUNCTION VerificaMaxNaviosClasse()
RETURNS TRIGGER AS $$
BEGIN
   IF EXISTS (SELECT classe FROM Navios GROUP BY classe HAVING COUNT(nome) > 5 )
      THEN RAISE EXCEPTION 'Com essa alteracao, o numero de navios numa mesma classe ultrapassa 5! A alteracao nao foi realizada.';
   END IF;
   RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER GaranteMaxNaviosClasse 
AFTER INSERT OR UPDATE OF classe ON Navios
FOR EACH STATEMENT
EXECUTE PROCEDURE VerificaMaxNaviosClasse();

-- f) Na inserção de uma tupla em Resultados, verifique se o navio e a batalha estão nas relações Navios e Batalhas, respectivamente. Se não estiverem, insira uma tupla em uma ou nas duas relações, usando NULL para os atributos cujo valor é desconhecido.

CREATE OR REPLACE FUNCTION VerificaInsereNavioBatalha()
RETURNS TRIGGER AS $$
BEGIN
   IF (NEW.navio NOT IN (SELECT nome FROM Navios)) THEN
      INSERT INTO Navios values (NEW.navio, NULL, NULL);
   END IF;
   IF (NEW.batalha NOT IN (SELECT nome FROM Batalhas)) THEN
      INSERT INTO Batalhas values (NEW.batalha, NULL);
   END IF;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER GaranteNavioBatalha 
BEFORE INSERT ON Resultados
FOR EACH ROW
EXECUTE PROCEDURE VerificaInsereNavioBatalha();


-- g) Garanta, em todas as circunstâncias que podem causar uma violação, que o ano de lançamento médio dos navios por país seja menor que 1935.

CREATE OR REPLACE FUNCTION VerificaLancamentoMedio()
RETURNS TRIGGER AS $$
BEGIN
   IF EXISTS (SELECT pais, AVG(LANCAMENTO) FROM Navios NATURAL JOIN Classes GROUP BY pais HAVING AVG(lancamento) >= 1935 )
      THEN RAISE EXCEPTION 'Com essa alteracao, o lancamento medio dos navios por pais ultrapassa 1935! A alteracao nao foi realizada.';
   END IF;
   RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Como modificacoes tanto em Classes quanto em Navios podem violar a restricao, eh preciso criar dois triggers separados, um para cada tabela.
CREATE TRIGGER GaranteLancamentoMedioMenor1935_1 
AFTER UPDATE of pais ON Classes
FOR EACH STATEMENT
EXECUTE PROCEDURE VerificaLancamentoMedio();

CREATE TRIGGER GaranteLancamentoMedioMenor1935_2 
AFTER INSERT OR UPDATE of lancamento ON Navios
FOR EACH STATEMENT
EXECUTE PROCEDURE VerificaLancamentoMedio();


------------------------------------------------------------

/** Exercício 2 ***************************************/
/* Questão a ****/
-- a)Essa visão é atualizável? Por quê?
-- A visão não é atualizável. A visão ImpressorasLaserBaratas envolve mais de uma relação, e há atributos não projetados na visão que não podem ser avaliados. Assim, as modificações na visão são potencialmente ambíguas para serem traduzidas ao SGBD.

/* Questão b ****/
-- b) Escreva um trigger do tipo INSTEAD OF para tratar inserções nessa visão.
CREATE OR REPLACE FUNCTION InsereImpressoraLaserBarata()
RETURNS TRIGGER AS $$
BEGIN
   IF (NEW.preco >= 500) THEN
	RAISE EXCEPTION 'O preco esta caro demais para uma impressora barata! O comando de insercao foi cancelado.';
   END IF;
   INSERT INTO produto(fabricante,modelo,tipo) VALUES (NEW.fabricante,NEW.modelo,'impressora');
   INSERT INTO impressora(modelo,colorida,tipo,preco) VALUES (NEW.modelo,NULL,'laser',NEW.preco);
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TInsereImpressoraLaserBarata 
INSTEAD OF INSERT ON ImpressorasLaserBaratas
FOR EACH ROW
EXECUTE PROCEDURE InsereImpressoraLaserBarata();

/* Questão c ****/
-- c) Escreva um trigger do tipo INSTEAD OF para tratar uma alteração do preço.
CREATE OR REPLACE FUNCTION AtualizaImpressoraLaserBarata()
RETURNS TRIGGER AS $$
BEGIN
   IF (NEW.modelo <> OLD.modelo OR NEW.fabricante <> OLD.fabricante) THEN
	RAISE EXCEPTION 'Modelo e fabricante nao podem ser alterados! O comando de alteracao foi cancelado.';
   END IF;
   IF (NEW.preco >= 500) THEN
	RAISE EXCEPTION 'O preco esta caro demais para uma impressora barata! O comando de alteracao foi cancelado.';
   END IF;
   
   UPDATE impressora SET preco=NEW.preco WHERE modelo=NEW.modelo;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TAtualizaImpressoraLaserBarata  
INSTEAD OF UPDATE ON ImpressorasLaserBaratas
FOR EACH ROW
EXECUTE PROCEDURE AtualizaImpressoraLaserBarata();

/* Questão d ****/
-- d) Escreva um trigger do tipo INSTEAD OF para tratar a remoção de uma tupla dessa visão.
CREATE OR REPLACE FUNCTION ExcluiImpressoraLaserBarata()
RETURNS TRIGGER AS $$
BEGIN
   DELETE FROM produto WHERE modelo=OLD.modelo;
   DELETE FROM impressora WHERE modelo=OLD.modelo;
   RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TExcluiImpressoraLaserBarata 
INSTEAD OF DELETE ON ImpressorasLaserBaratas
FOR EACH ROW
EXECUTE PROCEDURE ExcluiImpressoraLaserBarata();


