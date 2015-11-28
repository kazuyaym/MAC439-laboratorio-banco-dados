create schema aula15;
set search_path to aula15;

-- cria a tabela produto
CREATE TABLE produto
(
  fabricante char(1),
  modelo int,
  tipo char(20)
) ;

-- cria a tabela pc
CREATE TABLE pc
(
  modelo int,
  velocidade int,
  ram int,
  hd float,
  cd char(2),
  preco numeric(6,2)
);

-- cria a tabela laptop
CREATE TABLE laptop
(
  modelo int,
  velocidade int,
  ram int,
  hd float,
  tela float,
  preco numeric(6,2)
);

-- cria a tabela impressora
CREATE TABLE impressora
(
  modelo int,
  colorida bool,
  tipo varchar(15),
  preco numeric(6,2)
);


ALTER TABLE produto ADD PRIMARY KEY (modelo);
ALTER TABLE produto ALTER tipo SET NOT NULL;
ALTER TABLE produto ALTER tipo SET DEFAULT 'pc';
ALTER TABLE produto ALTER fabricante SET NOT NULL;
ALTER TABLE produto ADD CHECK (tipo = 'pc' OR tipo = 'laptop' OR tipo = 'impressora');

ALTER TABLE pc ADD FOREIGN KEY (modelo) REFERENCES produto(modelo) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE pc ADD PRIMARY KEY (modelo);
ALTER TABLE pc ALTER velocidade SET NOT NULL;
ALTER TABLE pc ALTER ram SET NOT NULL;
ALTER TABLE pc ALTER hd SET NOT NULL;
ALTER TABLE pc ADD CHECK (preco > 0.0);

ALTER TABLE laptop ADD FOREIGN KEY (modelo) REFERENCES produto(modelo) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE laptop ADD PRIMARY KEY (modelo);
ALTER TABLE laptop ALTER velocidade SET NOT NULL;
ALTER TABLE laptop ALTER ram SET NOT NULL;
ALTER TABLE laptop ALTER hd SET NOT NULL;
ALTER TABLE laptop ALTER tela SET NOT NULL;
ALTER TABLE laptop ADD CHECK (preco > 0.0);

ALTER TABLE impressora ADD FOREIGN KEY (modelo) REFERENCES produto(modelo) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE impressora ADD PRIMARY KEY (modelo);
ALTER TABLE impressora ALTER colorida SET DEFAULT TRUE;
ALTER TABLE impressora ALTER tipo SET NOT NULL;
ALTER TABLE impressora ADD CHECK (preco > 0.0);

----------------------------------------------------

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
ALTER TABLE classes ALTER tipo SET NOT NULL;
ALTER TABLE classes ADD CHECK (numarmas >= 0 AND calibre >= 0 AND deslocamento >= 0);

ALTER TABLE navios ADD PRIMARY KEY (nome);
ALTER TABLE navios ALTER lancamento SET NOT NULL;
ALTER TABLE navios ALTER classe SET NOT NULL;

ALTER TABLE batalhas ADD PRIMARY KEY (nome);
ALTER TABLE batalhas ALTER data SET NOT NULL;

ALTER TABLE resultados ADD PRIMARY KEY (navio,batalha);
ALTER TABLE resultados ADD CHECK (desfecho = 'afundado' OR desfecho = 'danificado' OR desfecho = 'ok');

----------------------------------------------------

-- popula a tabela produto
insert into produto (fabricante, modelo, tipo) values ('A', 1001, 'pc');
insert into produto (fabricante, modelo, tipo) values ('A', 1002, 'pc');
insert into produto (fabricante, modelo, tipo) values ('A', 1003, 'pc');
insert into produto (fabricante, modelo, tipo) values ('A', 2004, 'laptop');
insert into produto (fabricante, modelo, tipo) values ('A', 2005, 'laptop');
insert into produto (fabricante, modelo, tipo) values ('A', 2006, 'laptop');
insert into produto (fabricante, modelo, tipo) values ('B', 1004, 'pc');
insert into produto (fabricante, modelo, tipo) values ('B', 1005, 'pc');
insert into produto (fabricante, modelo, tipo) values ('B', 1006, 'pc');
insert into produto (fabricante, modelo, tipo) values ('B', 2001, 'laptop');
insert into produto (fabricante, modelo, tipo) values ('B', 2002, 'laptop');
insert into produto (fabricante, modelo, tipo) values ('B', 2003, 'laptop');
insert into produto (fabricante, modelo, tipo) values ('C', 1007, 'pc');
insert into produto (fabricante, modelo, tipo) values ('C', 1008, 'pc');
insert into produto (fabricante, modelo, tipo) values ('C', 2008, 'laptop');
insert into produto (fabricante, modelo, tipo) values ('C', 2009, 'laptop');
insert into produto (fabricante, modelo, tipo) values ('C', 3002, 'impressora');
insert into produto (fabricante, modelo, tipo) values ('C', 3003, 'impressora');
insert into produto (fabricante, modelo, tipo) values ('C', 3006, 'impressora');
insert into produto (fabricante, modelo, tipo) values ('D', 1009, 'pc');
insert into produto (fabricante, modelo, tipo) values ('D', 1010, 'pc');
insert into produto (fabricante, modelo, tipo) values ('D', 1011, 'pc');
insert into produto (fabricante, modelo, tipo) values ('D', 2007, 'laptop');
insert into produto (fabricante, modelo, tipo) values ('E', 1012, 'pc');
insert into produto (fabricante, modelo, tipo) values ('E', 1013, 'pc');
insert into produto (fabricante, modelo, tipo) values ('F', 2010, 'laptop');
insert into produto (fabricante, modelo, tipo) values ('F', 3001, 'impressora');
insert into produto (fabricante, modelo, tipo) values ('F', 3004, 'impressora');
insert into produto (fabricante, modelo, tipo) values ('G', 3005, 'impressora');
insert into produto (fabricante, modelo, tipo) values ('H', 3007, 'impressora');

-- popula a tabela pc
insert into pc (modelo, velocidade, ram, hd, cd, preco) values (1001,  700,  64, 10, '8x',  799);
insert into pc (modelo, velocidade, ram, hd, cd, preco) values (1002, 1500, 128, 60, '2x', 2499);
insert into pc (modelo, velocidade, ram, hd, cd, preco) values (1003,  866, 128, 20, '8x', 1999);
insert into pc (modelo, velocidade, ram, hd, cd, preco) values (1004,  866,  64, 10, '2x',  999);
insert into pc (modelo, velocidade, ram, hd, cd, preco) values (1005, 1000, 128, 20, '2x', 1499);
insert into pc (modelo, velocidade, ram, hd, cd, preco) values (1006, 1300, 256, 40, '6x', 2119);
insert into pc (modelo, velocidade, ram, hd, cd, preco) values (1007, 1400, 128, 80, '2x', 2299);
insert into pc (modelo, velocidade, ram, hd, cd, preco) values (1008,  700,  64, 30, '4x',  999);
insert into pc (modelo, velocidade, ram, hd, cd, preco) values (1009, 1200, 128, 80, '6x', 1699);
insert into pc (modelo, velocidade, ram, hd, cd, preco) values (1010,  750,  64, 30, '4x',  699);
insert into pc (modelo, velocidade, ram, hd, cd, preco) values (1011, 1100, 128, 60, '6x', 1299);
insert into pc (modelo, velocidade, ram, hd, cd, preco) values (1012,  350,  64,  7, '8x',  799);
insert into pc (modelo, velocidade, ram, hd, cd, preco) values (1013,  753, 256, 60, '2x', 2499);

-- popula a tabela laptop
insert into laptop (modelo, velocidade, ram, hd, tela, preco) values (2001, 700,  64,  5, 12.1, 1448);
insert into laptop (modelo, velocidade, ram, hd, tela, preco) values (2002, 800,  96, 10, 15.1, 2584);
insert into laptop (modelo, velocidade, ram, hd, tela, preco) values (2003, 850,  64, 10, 15.1, 2738);
insert into laptop (modelo, velocidade, ram, hd, tela, preco) values (2004, 550,  32,  5, 12.1,  999);
insert into laptop (modelo, velocidade, ram, hd, tela, preco) values (2005, 600,  64,  6, 12.1, 2399);
insert into laptop (modelo, velocidade, ram, hd, tela, preco) values (2006, 800,  96, 20, 15.7, 2999);
insert into laptop (modelo, velocidade, ram, hd, tela, preco) values (2007, 850, 128, 20, 15.0, 3099);
insert into laptop (modelo, velocidade, ram, hd, tela, preco) values (2008, 650,  64, 10, 12.1, 1249);
insert into laptop (modelo, velocidade, ram, hd, tela, preco) values (2009, 750, 256, 20, 15.1, 2599);
insert into laptop (modelo, velocidade, ram, hd, tela, preco) values (2010, 366,  64, 10, 12.1, 1499);

-- popula a tabela impressora
insert into impressora (modelo, colorida, tipo, preco) values (3001, true,  'ink-jet',  231);
insert into impressora (modelo, colorida, tipo, preco) values (3002, true,  'ink-jet',  267);
insert into impressora (modelo, colorida, tipo, preco) values (3003, false,   'laser',  390);
insert into impressora (modelo, colorida, tipo, preco) values (3004, true,  'ink-jet',  439);
insert into impressora (modelo, colorida, tipo, preco) values (3005, true,   'bubble',  200);
insert into impressora (modelo, colorida, tipo, preco) values (3006, true,    'laser', 1999);
insert into impressora (modelo, colorida, tipo, preco) values (3007, false,   'laser',  350);


---------------------------------------------------------
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


