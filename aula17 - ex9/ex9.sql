/*******************************************

MAC0439 - Laboratório de Banco de Dados
Exercício 9

Marcos Kazuya Yamazaki
7577622

*******************************************/

---- Triggers e modificação de visões com triggers
---- (Use o script “exercicio9_esquema_dados.sql” para criar o BD para testar suas respostas.)
---- Exercício 1: Escreva triggers para realizar as operações e restrições a seguir. Para uma
---- restrição, cancele ou desfaça a modificação que não satisfizer a restrição indicada.
---- BD: Navios importantes da 2ª Guerra Mundial

classes(classe, tipo, pais, numArmas, calibre, deslocamento)
navios(nome, classe, lancamento)
batalhas(nome, data)
resultados(navio, batalha, desfecho)

-- a) Na inserção de uma nova tupla em Resultados com desfecho diferente de 'ok', permita que a
--    inserção seja feita, mas mude o desfecho para 'ok'.

create or replace function desfechook() 
returns trigger as $$ 
    begin
        new.desfecho = 'ok';
        return new;
    end;
$$ language plpgsql;

create trigger desfecho_ok
before insert on resultados
for each row when (new.desfecho <> 'ok')
execute procedure desfechook();

-- TESTES:
-- insert into resultados (navio, batalha, desfecho) values ('teste', 'North Atlantic', 'afundado');
-- tables resultados;
-- delete from resultados where navio like 'teste';
-- drop trigger desfecho_ok on resultados;
----------------------------------------------------------------------------------------------------

-- b) Na inserção ou alteração de um navio, se a classe do navio for informada, garanta que a operação
--    só será realizada se a classe existir na relação Classes.

create or replace function classeexiste() 
returns trigger as $$ 
    begin
        
        if new.classe in (select classe from classes) 
        then insert into navios(nome, classe, lancamento) values(new.nome, new.classe, new.lancamento);
        end if;

        return null;
    end;
$$ language plpgsql;

create trigger classe_existe
before insert or update on navios
for each row when (new.classe is not null)
execute procedure classeexiste();

-- TESTES:
-- insert into navios (nome, classe, lancamento) values ('teste', 'teste', 1941);
-- delete from navios where nome like 'teste';
-- drop trigger classe_existe on navios;
---------------------------------------------------------------------------------

-- c) Na inserção de um novo navio, quando a classe do navio não for informada, use o próprio nome
--    do navio como nome para a classe. Nesse caso, se não existir uma classe com esse nome na relação
--    Classes, insira-a antes (usando 'nc' como tipo, 'EUA' para país e NULL para os demais atributos).

create or replace function classenaoinformada() 
returns trigger as $$ 
    begin
        
        if new.nome not in (select classe from classes) 
        then insert into classes (classe, tipo, pais, numarmas, calibre, deslocamento) 
             values (new.nome, 'nc', 'EUA', null, null, null); 
        end if;
        
        new.classe = new.nome;

        return new;
    end;
$$ language plpgsql;

create trigger classe_nao_informada
before insert on navios
for each row when (new.classe is null)
execute procedure classenaoinformada();

-- TESTES:
-- insert into navios (nome, classe, lancamento) values ('teste', null, 1941);
-- delete from navios where nome like 'teste';
-- delete from classes where classe like 'teste' cascade;
-- drop trigger classe_nao_informada on navios;
------------------------------------------------------------------------------
        	
-- d) Quando a data de uma batalha for modificada, garanta que nenhum navio que lutou na batalha
--    tenha um ano de lançamento posterior ao ano da batalha. (Dica: a função extract(year from d) do
--    PostgreSQL devolve o ano de uma data d.)

create or replace function databatalha() 
returns trigger as $$ 
    begin
        if extract(year from new.data) >= all (select lancamento from navios     where nome in(
                                               select navio      from resultados where batalha like new.nome)) then
            return new;
        end if;
        return null;
    end;
$$ language plpgsql;

create trigger data_batalha
before update of data on batalhas  
for each row 
execute procedure databatalha();

-- TESTES:
-- update batalhas set data = '1922-10-25' where nome like 'Surigao Strait';
-- drop trigger data_batalha on batalhas;
------------------------------------------------------------------------------

-- e) Garanta, em todas as circunstâncias que podem causar uma violação, que exista no máximo 5
--    navios em uma mesma classe.

create or replace function maximo5() 
returns trigger as $$ 
    begin
        if (select count(*) from navios where classe like new.classe) >= 5 then return null;
        end if;

        return new;
    end;
$$ language plpgsql;

create trigger maximo_5
before insert or update of classe on navios  
for each row 
execute procedure maximo5();

-- TESTES:
-- insert into navios (nome, classe, lancamento) values ('teste1', 'Kongo', 1915);
-- insert into navios (nome, classe, lancamento) values ('teste2', 'Kongo', 1915);
-- delete from navios where nome like 'teste1';
-- delete from navios where nome like 'teste2';
-- drop trigger maximo_5 on navios;
------------------------------------------------------------------------------

-- f) Na inserção de uma tupla em Resultados, verifique se o navio e a batalha estão nas relações
--    Navios e Batalhas, respectivamente. Se não estiverem, insira uma tupla em uma ou nas duas
--    relações, usando NULL para os atributos cujo valor é desconhecido.

create or replace function naviobatalha() 
returns trigger as $$
    begin
        if (new.navio not in (select nome from navios)) then
            insert into navios (nome, classe, lancamento) values(new.navio, null, null);
        end if;
        if (new.batalha not in (select nome from batalhas)) then
            insert into batalhas(nome, data) values (new.batalha, null);
        end if;

        return new;
    end;
$$ language plpgsql;

create trigger navio_batalha
before insert on resultados  
for each row 
execute procedure naviobatalha();

-- TESTES:
-- insert into resultados (navio, batalha, desfecho) values ('teste_navio', 'teste_batalha', 'afundado');
-- drop trigger navio_batalha on resultados;
---------------------------------------------------------------------------------------------------------

-- g) Garanta, em todas as circunstâncias que podem causar uma violação, que o ano de lançamento
--    médio dos navios por país seja menor que 1935.

create or replace function lancamentomedio() 
returns trigger as $$
    begin
        if (select pais, avg(lancamento) from navios natural join classes group by pais) then
            return null;
        end if;

        return new;
    end;
$$ language plpgsql;

create trigger lancamentomedio
before insert or delete or update of lancamento on navios  
for each row 
execute procedure lancamento_medio();

---- Exercício 2: Usando como base as tabelas

produto (fabricante, modelo, tipo)
impressora(modelo, colorida, tipo, preco)

-- suponha que a seguinte visão foi criada:
 CREATE VIEW ImpressorasLaserBaratas AS
 SELECT fabricante, P.modelo, preco
 FROM Produto AS P, IMPRESSORA AS I
 WHERE P.modelo = I.modelo AND P.tipo = 'impressora'
      AND I.tipo = 'laser' AND preco < 500;

---- Observe que essa visão faz uma verificação de consistência: a de que o número de modelo não
---- só aparece na relação Impressora, como também o atributo tipo de Produto indica que o
---- produto é mesmo uma impressora.

-- a) Essa visão é atualizável? Por quê?
Não é atualizável porque há mais de uma relação (tabelas: Produto e Impressora) na cláusula "FROM" da consulta de definição da visão.

-- b) Escreva um trigger do tipo INSTEAD OF para tratar inserções nessa visão.

create or replace function insertImpressora() 
returns trigger as $$
    begin
        insert into produto (fabricante, modelo, tipo) values (new.fabricante, new.modelo, 'impressora');
        insert into impressora (modelo, colorida, tipo, preco) values (new.modelo, null,  'laser',  new.preco);
        return new;
    end;
$$ language plpgsql;

create trigger insert_impressora_barata
instead of insert on ImpressorasLaserBaratas
for each row execute procedure insertImpressora();

-- c) Escreva um trigger do tipo INSTEAD OF para tratar uma alteração do preço (você não deve
--    permitir que sejam alterados os demais atributos da visão).

create or replace function preco() 
returns trigger as $$
    begin

        update impressora set preco = new.preco where modelo = old.modelo;
        return new;
    end;
$$ language plpgsql;

create trigger preco_novo
instead of update on ImpressorasLaserBaratas
for each row execute procedure preco();

-- d) Escreva um trigger do tipo INSTEAD OF para tratar a remoção de uma tupla dessa visão.

create or replace function remocaovisao() 
returns trigger as $$
    begin
        delete from impressora where modelo = old.modelo;
        delete from produto where modelo = old.modelo;
        return new;
    end;
$$ language plpgsql;

create trigger remocao_visao
instead of delete on ImpressorasLaserBaratas
for each row execute procedure remocaovisao();