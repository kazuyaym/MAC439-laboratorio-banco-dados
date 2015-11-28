/******************************************************
Laboratório de Bancos de Dados - MAC0439
Lista de Exercícios 5 - 2015 - Proposta de Resolução
*******************************************************/

/** Exercício 1 ***************************************/
-- a) Encontre o número do modelo e o preço de todos os produtos que estão no BD. 

(select modelo, preco from pc)
union
(select modelo, preco from laptop)
union
(select modelo, preco from impressora)

-- b) Encontre os fabricantes que vendem tanto PCs por menos de R$1000, quanto Laptops a menos de R$1500.  

(select fabricante from produto p, pc c where p.modelo = c.modelo and preco < 1000)
intersect
(select fabricante from produto p, laptop l where p.modelo = l.modelo and preco < 1500)

-- c) Encontre os fabricantes que vendem PCs, mas não impressoras. (Forneça dois comandos diferentes para essa consulta.) 

(select fabricante from produto where tipo = 'pc')
except
(select fabricante from produto where tipo = 'impressora')

-- ou

select fabricante from produto where tipo = 'pc' and fabricante not in 
             (select fabricante from produto where tipo = 'impressora')


-- d) Encontre o(s) modelos(s) dos computadores (PC ou laptop) com o menor preço.

select modelo from ((select modelo, preco from pc) union (select modelo, preco from laptop)) as computadores
where preco <= all ((select preco from pc) union (select preco from laptop))

-- e) Encontre os fabricantes que fazem pelo menos 2 modelos de computadores diferentes (PCs ou laptops) com velocidades de pelo menos 133.

select distinct Comps1.fabricante
from
((select fabricante, p.modelo from produto p, pc c where p.modelo = c.modelo and velocidade >= 133)
union
(select fabricante, p.modelo from produto p, laptop l where p.modelo = l.modelo and velocidade >= 133)) as Comps1,
((select fabricante, p.modelo from produto p, pc c where p.modelo = c.modelo and velocidade >= 133)
union
(select fabricante, p.modelo from produto p, laptop l where p.modelo = l.modelo and velocidade >= 133)) as Comps2
where Comps1.fabricante = Comps2.fabricante and Comps1.modelo <> Comps2.modelo;


/** Exercício 2 ***************************************/
-- a) Usando dois comandos INSERT, armazene no banco de dados o fato de que a impressora colorida ink-jet modelo 1100 é feita pelo fabricante D e custa R$249,00.

insert into produto(fabricante, modelo, tipo) values ('D', 1100, 'impressora');
insert into impressora (colorida, tipo, modelo, preco) values (true, 'ink-jet', 1100, 249);

-- b) Insira o fato de que, para todo Laptop, existe um PC do mesmo fabricante com os mesmos valores de velocidade, RAM e HD, um número de modelo maior em 1100 unidades e R$250,00 a menos de preço.

insert into produto (fabricante, modelo, tipo) 
(select fabricante, modelo + 1100, 'pc' from produto where tipo = 'laptop');
 
insert into pc (velocidade, ram, hd, modelo, preco) 
(select velocidade, ram, hd, modelo + 1100, preco - 250 from laptop);

-- c) Remova todas os PCs com menos de 10 gigabytes de HD.

delete from produto 
where modelo in (select modelo from pc where hd < 10);

-- d) Modifique as relações PC e Laptops de modo que o tamanho dos HDs passe a ser indicado em megabytes, e não mais em gigabytes.

update pc set hd =  hd * 1000;
update laptop set hd =  hd * 1000;

-- e) O fabricante C comprou o fabricante D. Modifique todos os produtos feitos por D, de modo a indicar que agora eles são produzidos por C.

update produto set fabricante = 'C' where fabricante = 'D';

-- f) Remova todos as impressoras feitas por um fabricante que não faz laptops.

delete from produto where tipo = 'impressora' and fabricante not in
(select fabricante from produto where tipo = 'laptop');

-- g) Para cada laptop, duplique a velocidade e adicione 1000 MB à quantidade de HD.

update laptop set velocidade = 2 * velocidade, hd = hd+10;

-- h) Para cada PC feito pelo fabricante C, desconte R$100 do preço e acrescente 128MB à RAM.

update pc set preco = preco - 100, ram = ram + 128
where modelo in (select modelo from produto where fabricante = 'C' and tipo = 'pc'); 

