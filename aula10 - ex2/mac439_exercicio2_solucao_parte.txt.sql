Banco(codigo, nome)
---> codigo é a chave primaria

Agencia(codBanco, numAgencia, rua, cidade, estado)
---> codBanco é uma chave estrangeira para Banco(codigo)
---> (codBanco, numAgencia) é a chave primaria

Conta(numero, saldo, codBanco, numAgencia)
---> (codBanco, numAgencia) é uma chave estrangeira para Agencia(codBanco, numAgencia)
---> numero é a chave primaria

Cliente(cpf, nome, dtNascimento)
---> cpf é a chave primaria

Telefone(cpfCliente, ddd, numero)
---> cpfCliente é uma chave estrangeira para Cliente(cpf)
---> (cpfCliente, ddd, numero) é a chave primaria

ClientePlatina(cpfCliente, limiteEmprestimo)
---> cpfCliente é uma chave estrangeira para Cliente(cpf)
---> cpfCliente é a chave primaria

PertenceA(numConta, cpfCliente)
---> numConta é uma chave estrangeira para Conta(numero)
---> cpfCliente é uma chave estrangeira para Cliente(cpf)
---> (numConta, cpfCliente) é a chave primaria

EmprestaPara(codBanco, numAgencia, cpfCliente, dtEmprestimo, valor)
---> (codBanco, numAgencia) é uma chave estrangeira para Agencia(codBanco, numAgencia)
---> cpfClientePlatina é uma chave estrangeira para ClientePlatina(cpfCliente)
---> (codBanco, numAgencia, cpfCliente, dtEmprestimo) é a chave primaria

Cartao(numero, dtEmissao, dtValidade, codSeguranca, tipo, numConta, cpfCliente)
---> (numConta, cpfCliente) é uma chave estrangeira para PertenceA(numConta, cpfCliente)
---> numero é a chave primaria


-- Cria um esquema no BD para agrupar as tabelas criadas no Exercicio 2
CREATE SCHEMA exercicio2;
  
-- Define o novo esquema como o esquema a ser usado na conexao atual
SET SEARCH_PATH TO exercicio2;

-- Cria um tipo de dado para CPFs
CREATE DOMAIN TIPO_CPF as CHAR(12);


-- Cria as tabelas do Exercicio 2

CREATE TABLE Banco (
	codigo INT PRIMARY KEY, 
	nome   VARCHAR(30) UNIQUE NOT NULL
);


CREATE TABLE Agencia (
	codBanco 	INT REFERENCES Banco (codigo) ON DELETE CASCADE ON UPDATE CASCADE, 
	numAgencia 	INT, 
	rua		VARCHAR(50) NOT NULL, 
	cidade		VARCHAR(30) NOT NULL, 
	estado		CHAR(2) NOT NULL,
	PRIMARY KEY (codBanco, numAgencia)
);
	

CREATE TABLE Cliente (
	cpf	TIPO_CPF PRIMARY KEY, 
	nome	VARCHAR(30) NOT NULL, 
	dtNascimento	DATE
);

CREATE TABLE ClientePlatina (
	cpfCliente	TIPO_CPF PRIMARY KEY REFERENCES Cliente (cpf) ON DELETE CASCADE ON UPDATE CASCADE, 
	limiteEmprestimo NUMERIC(8,2) NOT NULL
);


CREATE TABLE Conta (
	numero	INT PRIMARY KEY, 
	saldo	NUMERIC(11,2) NOT NULL, 
	codBanco	INT NOT NULL, 
	numAgencia	INT NOT NULL,
	FOREIGN KEY (codBanco, numAgencia) REFERENCES Agencia (codBanco, numAgencia) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE ContaCliente (
	numConta	INT REFERENCES Conta(numero) ON DELETE CASCADE ON UPDATE CASCADE, 
	cpfCliente	TIPO_CPF REFERENCES Cliente(cpf) ON DELETE RESTRICT ON UPDATE CASCADE,
	PRIMARY KEY (numConta, cpfCliente)
);



CREATE TABLE Emprestimo (
	codBanco	INT, 
	numAgencia	INT, 
	cpfCliente	TIPO_CPF REFERENCES ClientePlatina(cpfCliente) ON DELETE RESTRICT ON UPDATE CASCADE, 
	dtEmprestimo	DATE, 
	valor		NUMERIC(8,2) NOT NULL CHECK (valor >= 100 AND valor <= 100000), 
	FOREIGN KEY (codBanco, numAgencia) REFERENCES Agencia (codBanco, numAgencia) ON DELETE RESTRICT ON UPDATE CASCADE,
	PRIMARY KEY (codBanco, numAgencia, cpfCliente, dtEmprestimo)
);

CREATE TABLE Cartao (
	numero		INT PRIMARY KEY, 
	dtEmissao	DATE NOT NULL, 
	dtValidade	DATE NOT NULL, 
	codSeguranca	INT NOT NULL, 
	tipo		char(14) NOT NULL DEFAULT 'débito' CHECK (tipo = 'crédito' OR tipo = 'débito' OR tipo = 'débito/crédito'), 
	numConta	INT NOT NULL,
	cpfCliente	TIPO_CPF NOT NULL,
	FOREIGN KEY (numConta, cpfCliente) REFERENCES ContaCliente(numConta, cpfCliente) ON DELETE CASCADE ON UPDATE CASCADE,
	CHECK (dtValidade >= dtEmissao + INTERVAL '2-0')
);


CREATE TABLE Telefone (
	cpfCliente	TIPO_CPF REFERENCES Cliente(cpf) ON DELETE CASCADE ON UPDATE CASCADE, 
	ddd		CHAR(2) DEFAULT '11', 
	numero		CHAR(9),
	PRIMARY KEY (cpfCliente, ddd, numero)
);

