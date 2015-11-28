MAC0439 - Laboratório de Banco de Dados
Marcos Kazuya Yamazaki
NUSP: 7577622

CREATE TABLE CLIENTE_TELEFONE (
	Ccpf             CHAR(11) NOT NULL,
	DDD              INT NOT NULL DEFAULT 11,
	Numero           VARCHAR(9),

	PRIMARY KEY(Ccpf),
	FOREIGN KEY(Ccpf) REFERENCES CLIENTE(Cpf),
);


CREATE TABLE EmprestaPara (
	NumAgencia       INT NOT NULL,
	ClienteCPF       CHAR(11) NOT NULL,
	Valor            DECIMAL(10,2) NOT NULL CHECK (Valor > 100 AND Valor < 100000)
	DtEmprestimo     TIMESTAMP NOT NULL,

	PRIMARY KEY(NumAgencia, ClienteCPF, DtEmprestimo),
	FOREIGN KEY(NumAgencia) REFERENCES AGENCIA(NumAgencia),
	FOREIGN KEY(Clientecpf) REFERENCES CLIENTE(Cpf),
);

CREATE TABLE CARTÃO (
	Numero       CHAR(16) NOT NULL, 
	Emissao      DATE NOT NULL,
	Validade     DATE NOT NULL CHECK(Validade >= Emissao + INTERVAL '2'),	
	Seg          CHAR(3) NOT NULL,   
	Tipo         VARCHAR(16) CHECK(tipo = 'débito' OR tipo = 'crédito' OR tipo = 'débito/crédito') DEFAULT 'débito',

	PRIMARY KEY(Numero),
);

