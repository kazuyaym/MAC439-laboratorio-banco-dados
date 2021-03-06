CREATE SCHEMA aula17;
SET SEARCH_PATH to 'aula17';

-- cria a tabela produto
CREATE TABLE produto
(
  fabricante varchar(30),
  modelo int,
  tipo char(20)
) ;


-- cria a tabela impressora
CREATE TABLE impressora
(
  modelo int,
  colorida bool,
  tipo varchar(15),
  preco numeric(6,2)
);


-- popula a tabela produto
insert into produto (fabricante, modelo, tipo) values ('Compra Certa', 3002, 'impressora');
insert into produto (fabricante, modelo, tipo) values ('Compra Certa', 3003, 'impressora');
insert into produto (fabricante, modelo, tipo) values ('Compra Certa', 3006, 'impressora');
insert into produto (fabricante, modelo, tipo) values ('First Class HW', 3001, 'impressora');
insert into produto (fabricante, modelo, tipo) values ('First Class HW', 3004, 'impressora');
insert into produto (fabricante, modelo, tipo) values ('Gambis HW Solutions', 3005, 'impressora');
insert into produto (fabricante, modelo, tipo) values ('HW House', 3007, 'impressora');

-- popula a tabela impressora
insert into impressora (modelo, colorida, tipo, preco) values (3001, true,  'ink-jet',  231);
insert into impressora (modelo, colorida, tipo, preco) values (3002, true,  'ink-jet',  267);
insert into impressora (modelo, colorida, tipo, preco) values (3003, false,   'laser',  390);
insert into impressora (modelo, colorida, tipo, preco) values (3004, true,  'ink-jet',  439);
insert into impressora (modelo, colorida, tipo, preco) values (3005, true,   'bubble',  200);
insert into impressora (modelo, colorida, tipo, preco) values (3006, true,    'laser', 1999);
insert into impressora (modelo, colorida, tipo, preco) values (3007, false,   'laser',  350);

-----------------------------------------------------------------------------------------------------------------

-- cria a tabela classes
create table classes(
	classe varchar(20),
	tipo char(2), 
	pais varchar(20), 
	numarmas int, 
	calibre int,
	deslocamento int
);

-- cria a tabela batalhas
create table batalhas(
	nome varchar(20),
	data date
);

-- cria a tabela resultados
create table resultados(
	navio varchar(20),
	batalha varchar(20),
	desfecho varchar(10)
);

-- cria a tabela navios
create table navios(
	nome varchar(20),
	classe varchar(20),
	lancamento int
);


ALTER TABLE classes ADD PRIMARY KEY (classe);
ALTER TABLE classes ADD CHECK (tipo = 'ne' OR tipo = 'nc');
ALTER TABLE classes ADD CHECK (numarmas >= 0 AND calibre >= 0 AND deslocamento >= 0);

ALTER TABLE navios ADD PRIMARY KEY (nome);

ALTER TABLE batalhas ADD PRIMARY KEY (nome);

ALTER TABLE resultados ADD PRIMARY KEY (navio,batalha);
ALTER TABLE resultados ADD CHECK (desfecho = 'afundado' OR desfecho = 'danificado' OR desfecho = 'ok');

-- popula a tabela classes
insert into classes (classe, tipo, pais, numarmas, calibre, deslocamento) values 
	('Bismark', 'ne', 'Germany', 8, 15, 42000);
insert into classes (classe, tipo, pais, numarmas, calibre, deslocamento) values
	('Iowa', 'ne', 'USA', 9, 16, 46000);
insert into classes (classe, tipo, pais, numarmas, calibre, deslocamento) values
	('Kongo', 'nc', 'Japan', 8, 14, 32000);
insert into classes (classe, tipo, pais, numarmas, calibre, deslocamento) values
	('North Carolina', 'ne', 'USA', 9, 16, 37000);
insert into classes (classe, tipo, pais, numarmas, calibre, deslocamento) values
	('Renown', 'nc', 'Gt. Britain', 6, 15, 32000);
insert into classes (classe, tipo, pais, numarmas, calibre, deslocamento) values
	('Revenge', 'ne', 'Gt. Britain', 8, 15, 32000);
insert into classes (classe, tipo, pais, numarmas, calibre, deslocamento) values
	('Tennessee', 'ne', 'USA', 12, 14, 32000);
insert into classes (classe, tipo, pais, numarmas, calibre, deslocamento) values
	('Yamato', 'ne', 'Japan', 9, 18, 65000);

-- popula a tabela batalhas
insert into batalhas(nome, data) values ('North Atlantic', '1941-5-24');
insert into batalhas(nome, data) values ('Guadalacanal', '1942-11-15');
insert into batalhas(nome, data) values ('North Cape', '1943-12-26');
insert into batalhas(nome, data) values ('Surigao Strait', '1944-10-25');

-- popula a tabela navios
insert into navios (nome, classe, lancamento) values
	('California', 'Tennessee', 1921);
insert into navios (nome, classe, lancamento) values
	('Haruna', 'Kongo', 1915);
insert into navios (nome, classe, lancamento) values
	('Hiei', 'Kongo', 1914);
insert into navios (nome, classe, lancamento) values
	('Iowa', 'Iowa', 1943);
insert into navios (nome, classe, lancamento) values
	('Kirishima', 'Kongo', 1915);
insert into navios (nome, classe, lancamento) values
	('Kongo', 'Kongo', 1913);
insert into navios (nome, classe, lancamento) values
	('Missouri', 'Iowa', 1944);
insert into navios (nome, classe, lancamento) values
	('Musashi', 'Yamato', 1942);
insert into navios (nome, classe, lancamento) values
	('New Jersey', 'Iowa', 1941);
insert into navios (nome, classe, lancamento) values
	('North Carolina', 'North Carolina', 1921);
insert into navios (nome, classe, lancamento) values
	('Ramillies', 'Revenge', 1917);
insert into navios (nome, classe, lancamento) values
	('Renown', 'Renown', 1916);
insert into navios (nome, classe, lancamento) values
	('Repulse', 'Renown', 1916);
insert into navios (nome, classe, lancamento) values
	('Resolution', 'Revenge', 1916);
insert into navios (nome, classe, lancamento) values
	('Revenge', 'Revenge', 1916);
insert into navios (nome, classe, lancamento) values
	('Royal Oak', 'Revenge', 1916);
insert into navios (nome, classe, lancamento) values
	('Royal Sovereign', 'Revenge', 1916);
insert into navios (nome, classe, lancamento) values
	('Tennessee', 'Tennessee', 1920);
insert into navios (nome, classe, lancamento) values
	('Washington', 'North Carolina', 1941);
insert into navios (nome, classe, lancamento) values
	('Wisconsin', 'Iowa', 1944);
insert into navios (nome, classe, lancamento) values
	('Yamato', 'Yamato', 1941);

-- popula a tabela resultados
insert into resultados (navio, batalha, desfecho) values 
	('Bismark', 'North Atlantic', 'afundado');
insert into resultados (navio, batalha, desfecho) values 
	('California', 'Surigao Strait', 'ok');
insert into resultados (navio, batalha, desfecho) values 
	('Duke of York', 'North Cape', 'ok');
insert into resultados (navio, batalha, desfecho) values 
	('Fuso', 'Surigao Strait', 'afundado');
insert into resultados (navio, batalha, desfecho) values 
	('Hood', 'North Atlantic', 'afundado');
insert into resultados (navio, batalha, desfecho) values 
	('King George V', 'North Atlantic', 'ok');
insert into resultados (navio, batalha, desfecho) values 
	('Kirishima', 'Guadalacanal', 'afundado');
insert into resultados (navio, batalha, desfecho) values 
	('Prince of Wales', 'North Atlantic', 'danificado');
insert into resultados (navio, batalha, desfecho) values 
	('Rodney', 'North Atlantic', 'ok');
insert into resultados (navio, batalha, desfecho) values 
	('Scharnhorst', 'North Cape', 'afundado');
insert into resultados (navio, batalha, desfecho) values 
	('South Dakota', 'Guadalcanal', 'danificado');
insert into resultados (navio, batalha, desfecho) values 
	('Tennessee', 'Surigao Strait', 'ok');
insert into resultados (navio, batalha, desfecho) values 
	('Washington', 'Guadalacanal', 'ok');
insert into resultados (navio, batalha, desfecho) values 
	('West Virginia', 'Surigao Strait', 'ok');
insert into resultados (navio, batalha, desfecho) values 
	('Yamashiro', 'Surigao Strait', 'afundado');
insert into resultados (navio, batalha, desfecho) values 
	('Prince of Wales','North Cape','afundado');
insert into resultados (navio, batalha, desfecho) values 
	('South Dakota','North Atlantic','ok');

