CREATE SCHEMA aula16;

SET search_path TO aula16;

CREATE TABLE voo(
	nvoo	INTEGER		PRIMARY KEY, 
	origem  VARCHAR(30)	NOT NULL, 
	destino VARCHAR(30)	NOT NULL,
	partida	TIME		NOT NULL,
	chegada TIME		NOT NULL);


INSERT INTO voo VALUES (105, 'Chicago', 'Pittsburgh', '8:00', '9:15');
INSERT INTO voo VALUES (104, 'Chicago', 'Detroit', '8:50', '9:30');
INSERT INTO voo VALUES (107, 'Detroit', 'New York', '11:00', '12:30');
INSERT INTO voo VALUES (109, 'Pittsburgh', 'New York', '10:00', '12:00');
INSERT INTO voo VALUES (205, 'Chicago', 'Las Vegas', '14:00', '17:00');
INSERT INTO voo VALUES (101, 'Los Angeles', 'Chicago', '5:30', '7:30');
INSERT INTO voo VALUES (201, 'Las Vegas', 'Tucson', '17:40', '19:00');
INSERT INTO voo VALUES (210, 'Tucson', 'Albuquerque', '19:30', '20:30');
INSERT INTO voo VALUES (310, 'Dallas', 'Albuquerque', '9:30', '11:00');
INSERT INTO voo VALUES (325, 'Los Angeles', 'Dallas', '6:15', '8:15');
INSERT INTO voo VALUES (425, 'Albuquerque', 'Los Angeles', '21:30', '23:00');