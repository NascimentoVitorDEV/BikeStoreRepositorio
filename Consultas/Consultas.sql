USE BikeStores;

-- CONHECENDO AS TABELAS 
SELECT TOP 100
	*
FROM Sales.Store

-- essa tabela possui as vendas juntos com os itens vendidos com o chave do produto, a quantidade, o pre�o, desconto e o total da venda
-- nesse caso, essa tabela detalha o pedido da venda, quantos itens podem ter em cada venda
SELECT
	*
FROM Sales.OrderItem 

-- tabela principal, contem cada venda feita
SELECT
	*
FROM [Sales].[Order]


-- ANALISES VIS�O GERAL DO N�G�CIO

-- Faturamento total por ano
SELECT
	YEAR(SO.OrderDate) ANO,
	FORMAT(SUM(SO.OrderTotal),'C','pt-BR') TOTAL_VENDAS
FROM [Sales].[Order] AS SO
GROUP BY YEAR(SO.OrderDate)
ORDER BY ANO ASC


-- Quantidade de Pedidos
SELECT
	COUNT(SO.OrderID) QTD_PEDIDOS
FROM [Sales].[Order] AS SO



-- N�mero total de clientes distintos

SELECT DISTINCT
	
	COUNT(DISTINCT SO.CustomerID) QTD_CLIENTES

FROM [Sales].[Order] AS SO


-- TOP 10 produtos mais vendidos por valor e quantidade

SELECT TOP 10
	SI.ProductID,
	P.Name,
	SUM(SI.Quantity) QTD_PRODUTOS,
	AVG(SI.LineTotal / SI.Quantity) AS PRECO_MEDIO_UNITARIO,
	SUM(SI.LineTotal) TOTAL_PRECO
FROM [Sales].[Order] SO
INNER JOIN Sales.OrderItem AS SI ON SI.OrderID = SO.OrderID
INNER JOIN Production.Product AS P ON P.ProductID = SI.ProductID
GROUP BY SI.ProductID, P.Name
ORDER BY TOTAL_PRECO DESC


-- TOP 10 produtos mais vendidos por valor e quantidade

SELECT TOP 10
    SI.ProductID,
    P.Name,
    SUM(SI.Quantity) QTD_PRODUTOS,
    ROUND(AVG(SI.LineTotal / SI.Quantity), 2) AS PRECO_MEDIO_UNITARIO,
    SUM(SI.LineTotal) TOTAL_PRECO
FROM [Sales].[Order] SO
INNER JOIN Sales.OrderItem AS SI ON SI.OrderID = SO.OrderID
INNER JOIN Production.Product AS P ON P.ProductID = SI.ProductID
GROUP BY SI.ProductID, P.Name
ORDER BY TOTAL_PRECO DESC;

-- AN�LISE DE CLIENTES

--Total de clientes que compraram
	--Contar clientes distintos com pelo menos um pedido.
SELECT 
	COUNT(DISTINCT SO.CustomerID) Clientes
FROM [Sales].[Order]  AS SO;

-- �Em m�dia, quanto cada cliente gasta por pedido?"
	--  Calcular a m�dia de valor total gasto por cliente.

WITH VENDAS_POR_CLIENTE (CLIENTES, MEDIA_VENDAS)
AS
(
	SELECT
		SO.CustomerID AS CLIENTES,
		AVG(SO.OrderTotal) AS MEDIA_VENDAS
	FROM [Sales].[Order]  AS SO
	GROUP BY SO.CustomerID
)
SELECT
	FORMAT(AVG(MEDIA_VENDAS),'C','pt-BR') AS MEDIA_VENDAS_CLIENTES
FROM VENDAS_POR_CLIENTE AS VC


-- ticket m�dio

SELECT 
  FORMAT(
    SUM(OrderTotal) * 1.0 / COUNT(OrderID),
    'C', 'pt-BR'
  ) AS TICKET_MEDIO
FROM Sales.[Order];

-- Frequ�ncia de compras por cliente
-- Contar o n�mero de pedidos realizados por cada cliente.
SELECT
	SO.CustomerID,
	SC.FirstName,
	COUNT(SO.OrderID) AS QTD_VENDAS
	
FROM Sales.[Order] AS SO
INNER JOIN Sales.Customer AS SC ON SC.CustomerID = SO.CustomerID
GROUP BY SO.CustomerID, SC.FirstName
ORDER BY QTD_VENDAS DESC


-- An�lises Produtos e Categorias

--Receita total por produto
 --Somar as vendas por produto com base nos itens de pedidos.


SELECT
	SI.ProductID,
	P.Name,
	SUM(SI.LineTotal) TOTAL_VENDAS
FROM Sales.OrderItem AS SI
INNER JOIN Production.Product AS P ON P.ProductID = SI.ProductID
GROUP BY SI.ProductID, P.Name
ORDER BY TOTAL_VENDAS DESC

--Vendas por categoria e marca
 --Relacionar produtos com suas categorias e marcas e somar as vendas por esses grupos.

-- Vendas Por categorias 
SELECT
	C.CategoryID,
	C.Name,
	SUM(SI.LineTotal) TOTAL_VENDAS
FROM Sales.OrderItem AS SI
INNER JOIN Production.Product AS P ON P.ProductID = SI.ProductID
INNER JOIN Production.Category AS C ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryID,C.Name
ORDER BY TOTAL_VENDAS DESC

-- vendas por Marca
SELECT
	B.BrandID,
	B.Name,
	SUM(SI.LineTotal) TOTAL_VENDAS
FROM Sales.OrderItem AS SI
INNER JOIN Production.Product AS P ON P.ProductID = SI.ProductID
INNER JOIN Production.Brand AS B ON B.BrandID = P.BrandID
GROUP BY B.BrandID, B.Name
ORDER BY TOTAL_VENDAS DESC


-- Produtos que n�o Venderam
SELECT
    P.ProductID,
    P.Name,
    P.ListPrice
FROM Production.Product P
LEFT JOIN Sales.OrderItem SI ON SI.ProductID = P.ProductID
WHERE SI.ProductID IS NULL;


--Pre�o m�dio e quantidade vendida por produto
 --Calcular pre�o m�dio e total vendido por produto.

 SELECT
    SI.ProductID,
    P.Name,
    SUM(SI.Quantity) AS QUANTIDADE,
    SUM(SI.LineTotal) AS TOTAL_VENDA,
    ROUND(SUM(SI.LineTotal) / SUM(SI.Quantity), 2) AS PRECO_MEDIO_UNITARIO
FROM Sales.OrderItem AS SI
INNER JOIN Production.Product AS P ON P.ProductID = SI.ProductID
GROUP BY SI.ProductID, P.Name
ORDER BY TOTAL_VENDA DESC;

-- Analises por LOjas e Funcion�rios

--Receita por loja
SELECT
	SO.StoreID,
	SS.Name,
	ROUND(SUM(SO.OrderTotal) * 1.0 / COUNT(SO.OrderID), 2) AS TICKET_MEDIO,
	SUM(SO.OrderTotal) TOTAL_VENDAS,
	COUNT(SO.OrderID) QTD_PEDIDOS
FROM [Sales].[Order] AS SO
INNER JOIN Sales.Store AS SS ON SS.StoreID = SO.StoreID
GROUP BY SO.StoreID, SS.Name
ORDER BY TOTAL_VENDAS DESC


-- Receita por funcion�rio

SELECT
	SO.EmployeeID,
	CONCAT(SE.FirstName,' ', SE.LastName) AS FullName,
	ROUND(SUM(SO.OrderTotal) * 1.0 / COUNT(SO.OrderID), 2) AS TICKET_MEDIO,
	COUNT(OrderID) QTD_PEDIDOS,
	SUM(SO.OrderTotal) TOTAL_VENDAS
FROM [Sales].[Order] AS SO
INNER JOIN Sales.Employee AS SE ON SE.EmployeeID = SO.EmployeeID
GROUP BY SO.EmployeeID, CONCAT(SE.FirstName,' ', SE.LastName)


-- Funcion�rios sem registros de vendas
SELECT
    SE.EmployeeID,
    CONCAT(SE.FirstName, ' ', SE.LastName) AS FullName
FROM Sales.Employee AS SE
LEFT JOIN Sales.[Order] AS SO ON SE.EmployeeID = SO.EmployeeID
WHERE SO.EmployeeID IS NULL;


-- Evolu��o mensal das vendas por loja
 --Agrupar as vendas por loja e por m�s.
 SELECT
	YEAR(SO.OrderDate) ANO,
	S.Name,
	SUM(SO.OrderTotal) TOTAL_VENDAS
 FROM [Sales].[Order] AS SO
 INNER JOIN Sales.Store AS S ON S.StoreID = SO.StoreID
 GROUP BY YEAR(SO.OrderDate) ,S.Name
