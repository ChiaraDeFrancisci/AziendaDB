USE Azienda;

--Ordini consegnati
SELECT C.Nome, O.DataOrdine, O.Totale, SO.DataConsegna FROM StatoOrdini AS SO
JOIN Ordini AS O ON O.IdOrdine = SO.IdOrdine
JOIN Clienti AS C ON C.IdCliente = O.IdCliente
WHERE SO.Esito = 1 OR SO.DataConsegna is NOT NULL -- avevi omesso la seconda condizione, è utile per essere sicuri di avere risultati corretti anche in caso di incorrettezza di dati nel campo Esito
ORDER BY  O.DataOrdine DESC;

--Ordini non consegnati
SELECT C.Nome, O.DataOrdine, O.Totale, SO.DataConsegna FROM StatoOrdini AS SO
JOIN Ordini AS O ON O.IdOrdine = SO.IdOrdine
JOIN Clienti AS C ON C.IdCliente = O.IdCliente
WHERE SO.Esito = 2 OR SO.DataConsegna is NULL -- avevi omesso la seconda condizione, è utile per essere sicuri di avere risultati corretti anche in caso di incorrettezza di dati nel campo Esito
ORDER BY  O.DataOrdine DESC;



--Retrieve all clients who have never placed an order.
SELECT C.Nome,C.Email FROM Clienti AS C
LEFT JOIN Ordini AS O ON O.IdCliente=C.IdCliente
WHERE O.IdCliente IS NULL;

--List the total number of products ordered by each client along with the client details.
SELECT C.Nome, C.Email, COUNT(DO.Quantita) AS TotProdottiAcquistati FROM Clienti AS C
JOIN Ordini AS O ON O.IdCliente=C.IdCliente
JOIN DettaglioOrdini AS DO ON DO.IdOrdine=O.IdOrdine
GROUP BY C.Nome, C.Email;

--Find the average, minimum, and maximum order total for each client who has placed more than one order.
SELECT C.Nome, COUNT (O.IdOrdine) AS NumeroOrdini , MIN(O.Totale) AS TotaleMIN, MAX(O.Totale) AS TotaleMAX, AVG(O.Totale) AS TotaleAVG FROM Ordini AS O
jOIN Clienti AS C ON C.IdCliente= O.IdCliente
GROUP BY C.Nome
HAVING COUNT (O.IdOrdine)>1

--List all clients and the total amount they have spent, including clients who have not placed any orders (show total as 0 for such clients).
SELECT  C.Nome, 
		C.Email, 
		COALESCE(SUM(O.Totale),0) AS TotaleSpeso 
FROM Clienti AS C
LEFT JOIN Ordini AS O ON O.IdCliente=C.IdCliente
GROUP BY C.Nome, C.Email

--Retrieve orders that contain at least one product with a quantity greater than a specified amount.
SELECT C.Nome, O.DataOrdine, O.Totale, P.Descrizione, DO.Quantita FROM DettaglioOrdini AS DO
JOIN Ordini AS O ON O.IdOrdine=DO.IdOrdine
JOIN Clienti AS C ON C.IdCliente= O.IdCliente
JOIN Prodotti AS P ON P.IdProdotto=DO.IdProdotto
WHERE DO.Quantita>5

--Retrieve the products that have never been ordered.
SELECT P.Descrizione,P.Prezzo FROM Prodotti AS P
WHERE P.IdProdotto NOT IN (
	SELECT P.IdProdotto FROM Prodotti AS P
	JOIN DettaglioOrdini AS DO ON DO.IdProdotto=P.IdProdotto);



--List the orders that were placed within the last 30 days and have a total amount greater than the average order total of all time.
SELECT C.Nome, O.DataOrdine, O.Totale FROM Ordini AS O
JOIN Clienti AS C ON C.IdCliente=O.IdCliente
GROUP BY C.Nome,O.Totale,O.DataOrdine
HAVING O.Totale>(SELECT AVG(O.Totale) FROM Ordini AS O) AND O.DataOrdine>DATEADD(mm,-1,GETDATE())

--Select AVG(O.Totale) AS MediaTotali FROM Ordini AS O

--SELECT O.DataOrdine, O.Totale FROM Ordini AS O
--GROUP BY O.Totale,O.DataOrdine
--HAVING O.Totale>( Select AVG(O.Totale) AS MediaTotali FROM Ordini AS O)


--SELECT O.DataOrdine, O.Totale FROM Ordini AS O
--GROUP BY O.Totale,O.DataOrdine
--HAVING O.DataOrdine>DATEADD(mm,-1,GETDATE())

--IN HAVING NON FUNZIONA USARE UNA FUNZIONE AGGREGATA CHE NON SIA IN UNA SOTTOQUERY



--Find the client who has spent the most on orders.
SELECT TOP (1) C.Nome,C.Email,SUM(O.Totale) AS TotaleSpeso FROM Clienti AS C
JOIN Ordini AS O ON O.IdCliente=C.IdCliente
GROUP BY C.Nome,C.Email
ORDER BY TotaleSpeso DESC

--Retrieve the product details along with the total quantity ordered across all orders.
SELECT P.Descrizione, P.Prezzo, COALESCE(SUM(DO.Quantita),0) AS QuantitaOrdinata FROM Prodotti AS P
LEFT JOIN DettaglioOrdini AS DO ON DO.IdProdotto=P.IdProdotto
GROUP BY P.Descrizione,P.Prezzo

--List all clients who have ordered more than three different products in a single order.
SELECT C.Nome, O.DataOrdine, COUNT(DO.IdProdotto) AS ProdottiDiversi FROM DettaglioOrdini AS DO
JOIN Ordini AS O ON O.IdOrdine=DO.IdOrdine
JOIN Clienti AS C ON C.IdCliente=O.IdCliente
GROUP BY  DO.IdOrdine, C.Nome, O.DataOrdine
HAVING COUNT(DO.IdProdotto)>=3

--Retrieve the most expensive product ordered in each order.
SELECT DO.IdOrdine, MAX(P.Prezzo) as PrezzoMAX FROM Prodotti AS P
JOIN DettaglioOrdini AS DO ON DO.IdProdotto=P.IdProdotto
GROUP BY DO.IdOrdine

--Seleziona tutti i prodotti per idordine
SELECT DO.IdOrdine,P.Descrizione, P.Prezzo FROM DettaglioOrdini AS DO
JOIN Prodotti AS P ON P.IdProdotto = DO.IdProdotto
GROUP BY DO.IdOrdine, P.Descrizione, P.Prezzo



-------------------------NON FUNZIONA-------------------------------
--Dettagli degli articoli più costosi per ogni ordine
Select DO.IdOrdine, P.Descrizione, (SELECT MAX(P.Prezzo) FROM Prodotti AS P
									JOIN DettaglioOrdini AS DO ON DO.IdProdotto=P.IdProdotto
									GROUP BY DO.IdOrdine) AS PrezzoMAX
FROM Prodotti AS P
JOIN DettaglioOrdini AS DO ON DO.IdProdotto=P.IdProdotto

--------------------------------------------------------------------

-------------------------NON FUNZIONA-------------------------------
--Find the most frequently ordered product by each client.
SELECT C.Nome, P.Descrizione, P.Prezzo,  COUNT(DO.IdProdotto) AS NOrdini FROM Prodotti AS P
JOIN DettaglioOrdini AS DO ON DO.IdProdotto=P.IdProdotto
JOIN Ordini AS O ON O.IdOrdine=O.IdOrdine
JOIN Clienti AS C ON C.IdCliente=O.IdCliente
GROUP BY C.Nome, P.Descrizione, P.Prezzo
--------------------------------------------------------------------




--Retrieve the orders with their total amounts, but only include orders where the total amount is greater than the sum of the totals of all orders placed by the client with the fewest orders.

SELECT O.IdOrdine, O.Totale FROM Ordini AS O
WHERE O.Totale > (
--somma totali del cliente con meno ordini (almeno 1), in caso di spareggio quello con il totale maggiore



--somma totali del cliente ordinati per nordini
SELECT O.IdCliente, Count(O.IdOrdine) AS NOrdini, SUM(O.Totale) AS TotaleSpeso FROM Ordini AS O
GROUP BY O.IdCliente
ORDER BY NOrdini





--Find all clients who have ordered the same product in more than one order, and list the product along with the order details.
--Find the clients who have placed orders in every month of the current year.






