--CREATE DATABASE Azienda;

--DROP DATABASE Azienda;

--USE Azienda;
--USE Model;

--CREATE TABLE Clienti (
--	IdCliente INT PRIMARY KEY IDENTITY(1,1),
--	Nome VARCHAR(100) NOT NULL,
--	Email VARCHAR(100) NOT NULL
--);

--CREATE TABLE Prodotti (
--	IdProdotto INT PRIMARY KEY IDENTITY(1,1),
--	Descrizione VARCHAR(100) NOT NULL,
--	Prezzo MONEY NOT NULL 
--);

CREATE TABLE Ordini (
	IdOrdine INT PRIMARY KEY IDENTITY(1,1),
	IdCliente INT FOREIGN KEY REFERENCES Clienti(IdCliente),
	DataOrdine DATE NOT NULL,
	Totale MONEY NOT NULL 
);

--DROP TABLE DettaglioOrdini;

CREATE TABLE DettaglioOrdini (
	IdOrdine INT FOREIGN KEY REFERENCES Ordini(IdOrdine) NOT NULL,
	IdProdotto INT FOREIGN KEY REFERENCES Prodotti(IdProdotto) NOT NULL,
	Quantita INT NOT NULL CHECK (Quantita>0)
);
DROP TABLE Ordini
DROP TABLE DettaglioOrdini
DROP TABLE StatoOrdini
CREATE TABLE StatoOrdini (
	IdOrdine INT FOREIGN KEY REFERENCES Ordini(IdOrdine) NOT NULL,
	DataPrimoInvio DATETIME,
	Esito INT CHECK(Esito=1 OR Esito=2) NOT NULL,
	DataConsegna DATETIME
);

--INSERT INTO Clienti (Nome, Email)
--VALUES  ('Alessandro De Filippis', 'ale.defilippis@gmail.com'),
--		('Andrea De Filippis', 'andre.defilippis@gmail.com'),
--		('Matteo Gastaldi', 'matteo.gastaldi@gmail.com'),
--		('Chiara De Francisci', 'chiara.defrancisci@gmail.com'),
--		('Matteo Sbrega', 'matteo.sbrega@gmail.com'),
--		('Fabiola Guerreschi', 'f.guerreschi@libero.it');

--INSERT INTO Clienti (Nome, Email)
--VALUES ('Sabrina Alfonsi', 'sabri@gmail.com');

--INSERT INTO Prodotti (Descrizione, Prezzo)
--VALUES  ('Libro', 12.50),
--		('Elders Ring', 44.78),
--		('CD Musicale', 20.00),
--		('Licenza Microsoft', 19.99),
--		('10 Euro', 10.00),
--		('Televisore Samsung QLED 55 Pollici', 599.00),
--		('Penna', 2.00),
--		('Mela', 1.50),
--		('Letto IKEA Malm', 289.00);

--INSERT INTO Prodotti (Descrizione, Prezzo)
--VALUES ('ZWCAD2025 Professional', 989.00);

--INSERT INTO Ordini (IdCliente,DataOrdine,Totale)
--VALUES  (2,'2024-06-18', 19.99),
--		(5,'2023-12-25', 44.78),
--		(3,'2024-02-14', 44.78),
--		(1,'2022-03-15', 30.00),
--		(4,'2020-04-10', 32.50),
--		(6,'2024-01-01', 599.00),
--		(6,'2024-05-16', 15.00),
--		(2,'2023-08-07', 289.00),
--		(2,'2024-06-18', 25.00),
--		(5,'2024-06-18', 50.00);

INSERT INTO Ordini (IdCliente,DataOrdine,Totale)
VALUES (4, '2023-06-18', 23.50);

--INSERT INTO DettaglioOrdini (IdOrdine, IdProdotto, Quantita)
--VALUES  (1,4,1),
--		(2,2,1),
--		(3,2,1),
--		(4,5,3),
--		(5,1,1),
--		(5,3,1),
--		(6,6,1),
--		(7,8,10),
--		(8,9,1),
--		(9,7,5),
--		(9,8,10),
--		(10,1,4);

INSERT INTO DettaglioOrdini (IdOrdine, IdProdotto, Quantita)
VALUES  (13,3,1),
		(13,7,1),
		(13,8,1);
		

--INSERT INTO StatoOrdini (IdOrdine, DataPrimoInvio, Esito, DataConsegna)
--Values  (1,'2024-06-18T23:42:24', 2, NULL),
--		(2,'2023-12-25T12:36:20', 1, '2023-12-25T12:38:20'),
--		(3,'2024-02-14T00:00:20', 1, '2024-02-14T00:02:20'),
--		(4,'2022-03-15T08:22:16', 2, NULL),
--		(5,'2020-04-10T09:30:02', 1, '2020-04-10T10:30:02'),
--		(6,'2024-01-01T15:08:41', 1, '2024-01-06T17:08:41'),
--		(7,'2024-05-16T18:19:37', 1, '2024-06-16T18:19:37'),
--		(8,'2023-08-07T12:00:47', 1, '2023-09-01T12:00:47'),
--		(9,'2024-06-18T06:07:04', 2, NULL),
--		(10,'2024-06-18T11:05:58', 2, NULL);

INSERT INTO StatoOrdini (IdOrdine, DataPrimoInvio, Esito, DataConsegna)
VALUES  (13,'2023-06-18T23:42:24', 1, '2023-06-20T23:42:24');

--avevi considerato come date valide per ordini non consegnati anche date successive alla data odierna invece è concettualmente sbagliato, deve essere NULL. Se fosse stato previsto avresti dovuto mettere o uno stato aggiuntivo 'In Consegna' o un campo aggiuntivo per la Data programmata per la consegna

