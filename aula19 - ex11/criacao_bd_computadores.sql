create schema aula19;
set search_path to aula19;

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

ALTER TABLE pc ADD FOREIGN KEY (modelo) REFERENCES produto(modelo);
ALTER TABLE pc ADD PRIMARY KEY (modelo);
ALTER TABLE pc ALTER velocidade SET NOT NULL;
ALTER TABLE pc ALTER ram SET NOT NULL;
ALTER TABLE pc ALTER hd SET NOT NULL;
ALTER TABLE pc ADD CHECK (preco > 0.0);

ALTER TABLE laptop ADD FOREIGN KEY (modelo) REFERENCES produto(modelo);
ALTER TABLE laptop ADD PRIMARY KEY (modelo);
ALTER TABLE laptop ALTER velocidade SET NOT NULL;
ALTER TABLE laptop ALTER ram SET NOT NULL;
ALTER TABLE laptop ALTER hd SET NOT NULL;
ALTER TABLE laptop ALTER tela SET NOT NULL;
ALTER TABLE laptop ADD CHECK (preco > 0.0);

ALTER TABLE impressora ADD FOREIGN KEY (modelo) REFERENCES produto(modelo);
ALTER TABLE impressora ADD PRIMARY KEY (modelo);
ALTER TABLE impressora ALTER colorida SET DEFAULT FALSE;
ALTER TABLE impressora ALTER tipo SET NOT NULL;
ALTER TABLE impressora ADD CHECK (preco > 0.0);

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
