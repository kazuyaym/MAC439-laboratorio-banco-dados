/*******************************************

MAC0439 - Laboratório de Banco de Dados
Exercício 5

Marcos Kazuya Yamazaki
7577622

*******************************************/

---- 1)

-- a) Encontre o número do modelo e o preço de 
--    todos os produtos que estão no BD.
(select modelo, preco from pc) union all
(select modelo, preco from laptop) union all
(select modelo, preco from impressora);

-- b) Encontre os fabricantes que vendem tanto PCs 
--    por menos de R$1000, quanto Laptops a menos de R$1500.
select distinct fabricante from produto where modelo in (
	(select modelo from pc where preco < 1000) union
	(select modelo from laptop where preco < 1500));

-- c) Encontre os fabricantes que vendem PCs, mas não
--    impressoras. (Forneça dois comandos diferentes 
--    para essa consulta.)
select distinct p1.fabricante
from produto as p1
where p1.modelo in (select modelo 
	                from pc)
  and p1.fabricante not in (select p2.fabricante 
  	                        from produto as p2
  	                        where exists (select *
  	                        	          from impressora as i
  	                        	          where p2.modelo = i.modelo));
 
(select distinct fabricante from produto where modelo in
	(select modelo from pc))
except
(select distinct fabricante from produto where modelo in
	(select modelo from impressora));


-- d) Encontre o(s) modelos(s) dos computadores
--    (PC ou laptop) com o menor preço.
select computador.modelo, computador.preco
from ((select modelo, preco from pc) union all (select modelo, preco from laptop)) as computador
where preco <= all((select preco from pc) union 
	               (select preco from laptop));

-- e) Encontre os fabricantes que fazem pelo menos 2
--    modelos de computadores diferentes (PCs ou laptops)
--    com velocidades de pelo menos 133.
select distinct p1.fabricante 
from produto as p1, produto as p2,
	((select modelo, velocidade from pc) union all (select modelo, velocidade from laptop)) as c1,
	((select modelo, velocidade from pc) union all (select modelo, velocidade from laptop)) as c2
where c1.modelo = p1.modelo and c2.modelo = p2.modelo and
      p1.fabricante = p2.fabricante and c1.modelo <> c2.modelo
      and c1.velocidade >= 133 and c2.velocidade >= 133;
		
---- 2)

-- a) Usando dois comandos INSERT, armazene no banco
--    de dados o fato de que a impressora colorida 
--    ink-jet modelo 1100 é feita pelo fabricante D 
--    e custa R$249,00.
insert into produto (fabricante, modelo, tipo) values ('D', 1100, 'impressora');
insert into impressora (modelo, colorida, tipo, preco) values (1100, true,  'ink-jet',  249);

-- b) Insira o fato de que, para todo Laptop, existe
--    um PC do mesmo fabricante, com os mesmos
--    valores de velocidade, RAM e HD, um número 
--    de modelo maior em 1100 unidades e R$250,00 a
--    menos de preço.
insert into produto(fabricante, modelo, tipo) 
   (select fabricante, modelo + 1100 as modelo, 'pc' as tipo1
	from produto
	where modelo in (
	  	select modelo
	  	from laptop)) ;

insert into pc(modelo, velocidade, ram, hd, preco) 
   (select modelo + 1100, velocidade, ram, hd, preco - 250
   	from laptop);

-- c) Remova todos os PCs com menos de 10 gigabytes de HD.
delete from pc 
where hd < 10;

-- d) Modifique as relações PC e Laptops de modo que
--    o tamanho dos HDs passe a ser indicado em
--    megabytes, e não mais em gigabytes.
update pc
set hd = hd * 1000;

update laptop
set hd = hd * 1000;

-- e) O fabricante C comprou o fabricante D. 
--    Modifique todos os produtos feitos por D, de modo a
--    indicar que agora eles são produzidos por C.
update produto
set fabricante = 'C'
where fabricante = 'D';

-- f) Remova todos as impressoras feitas por um 
--    fabricante que não faz laptops.
delete from impressora as i
where not exists (
	select modelo from laptop as l where exists (
		select p1.fabricante 
		from produto as p1, produto as p2 
		where p1.modelo = i.modelo and p2.modelo = l.modelo and p1.fabricante = p2.fabricante
		)
)

-- g) Para cada laptop, duplique a velocidade e 
--    adicione 1000 MB à quantidade de HD.
update laptop
set velocidade = velocidade * 2;

update laptop
set hd = hd + 1000;

-- h) Para cada PC feito pelo fabricante C, desconte 
--    R$100 do preço e acrescente 128MB à RAM.
update pc
set preco = preco - 100
where modelo in (select modelo from produto where fabricante = 'C');

update pc
set ram = ram - 128
where modelo in (select modelo from produto where fabricante = 'C');