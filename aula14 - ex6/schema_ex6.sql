create schema aula14;
set search_path to aula14;

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
	('Kirishima', 'Blue Giant', 1915);
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
	('Ramillies', 'Sea King', 1917);
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
	('Kongo', 'North Atlantic', 'afundado');
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
	('Hiei', 'Guadalacanal', 'ok');
insert into resultados (navio, batalha, desfecho) values 
	('West Virginia', 'Surigao Strait', 'ok');
insert into resultados (navio, batalha, desfecho) values 
	('Yamashiro', 'Surigao Strait', 'afundado');
insert into resultados (navio, batalha, desfecho) values 
	('Prince of Wales','North Cape','afundado');
insert into resultados (navio, batalha, desfecho) values 
	('Wisconsin','North Atlantic','ok');



