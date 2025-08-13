## BikeStore - Projeto de Análise de dados de lojas de Biciletas

### Visão Geral do Projeto

Este projeto tem como objetivo aplicar técnicas de Business Intelligence utilizando SQL Server e Power BI sobre a base de dados da BIKEStore, uma loja fictícia de bicicletas. Através dessa base, foi possível realizar uma série de consultas SQL e criar métricas relevantes para análise de desempenho de vendas, comportamento dos clientes, categorias e produtos mais vendidos, além de realizar uma análise regional para identificar áreas de alto desempenho.

### Base de Dados: BikeStores
A base BIKEStore é uma simulação de uma loja de bicicletas, com dados que incluem vendas, produtos, clientes e lojas. A análise envolveu o uso de consultas SQL para extrair e transformar os dados, além de criar um dashboard no Power BI para visualização e tomada de decisão estratégica.

**Principais tabelas utilizadas:**

*   `Order`: informações de cada venda.
*   `Product`: Informações sobre cada produto.
*   `Order_item`: associação entre cada ordem de compra e seus respectivos itens.
*   `Employee`: Dados sobre os empregados.
*   `Store`: Dados sobre cada loja.
*   `Calendario`: Tabela de Datas.

### Etapas do Projeto

#### 1. Análises com SQL

As primeiras etapas envolveram a exploração da base via SQL Server. Foram desenvolvidas várias consultas para entender o comportamento dos dados, gerar métricas de negócio e facilitar a construção do modelo no Power BI. Entre as principais análises:
*   Faturamento total por ano.
*   Quantidade total de clientes.
*   Top 10 produtos mais vendidos.
*   Desempenho por Lojas e por funcionário.
*   Valor médio pago por cliente.
*   Análise de produtos que não venderam
*   Ticket médio por cliente

#### 2. Modelagem de Dados no Power BI

Com os dados importados, foi feito o tratamento e modelagem no Power BI, respeitando os relacionamentos e utilizando algumas transformações:

**Medidas criadas com DAX:**

*   Receita Total
*   Quantidade de Pedidos
*   Ticket Médio
*   Top Produtos mais vendidos
*   Categorias com Maior Receita
*   Receita por Loja
*   Receita por Funcionário
*   Média de gasto por Cliente

##### Medida: Maior Receita Mensal
  ![MaiorReceitaMensal](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ImagensDashboard/MedidaMaiorReceitaMensal.png)

##### Medida: Top 10 Produtos
  ![Top10produtos](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ImagensDashboard/Top10Produtos.png)

##### Medida: Categoria Top 1
  ![Categoriatop1](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ImagensDashboard/MedidaCategoriatop1.png)

##### Medida: Receita MoM
  ![ReceitaMoMl](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ImagensDashboard/ReceitaMOM.png)

##### Medida: Variação % MoM
  ![Variação MoM](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ImagensDashboard/ReceitaMOM.png)

#### 3. Construção do Dashboard

O dashboard foi construído com foco em interatividade, clareza e apoio à decisão. Algumas das funcionalidades implementadas:

*   Evolução da Receita no Tempo: análise mensal e anual.
*   Top Categorias e Produtos: filtros cruzados com métricas.
*   Performance de Lojas e Funcionários: comparativo de receita.
*   Drill Through das Vendas: análise detalhada de uma venda.
*   Filtros Flutuantes: seleção por ano, mês, loja, categoria etc.
*   Tooltips customizados: insights adicionais ao passar o cursor.

  ##### Aba sobre o Resumo Financeiro
  ![Resumo Financeiro](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ImagensDashboard/PrimeiraPg.png)

##### Aba sobre o painel Financeiro com Menu de Filtros
  ![Painel de Filtros](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ImagensDashboard/PrimeiraPgFiltro.png)

##### Aba Funcionários
  ![Funcionários](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ImagensDashboard/SegundaPg.png)

##### Aba Lojas
  ![Lojas](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ImagensDashboard/TeceiraPg.png)

##### Aba Produtos e Categorias
  ![Produtos e Categorias](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ImagensDashboard/QuartaPagina.png)

#### Links Para o Deshboard
<p>
📊 <a href="https://app.powerbi.com/view?r=eyJrIjoiNGM4OWRkYmYtNDgyZS00ZGRkLWI1NDMtODU5OGI2M2JjOTg1IiwidCI6IjY1OWNlMmI4LTA3MTQtNDE5OC04YzM4LWRjOWI2MGFhYmI1NyJ9" target="_blank">Visualizar Dashboard no Power BI</a>
</p>

### Análises

##### Faturamento Anual

```sql
-- FATURAMENTO TOTAL POR ANO
SELECT
	YEAR(SO.OrderDate) ANO,
	FORMAT(SUM(SO.OrderTotal),'C','pt-BR') TOTAL_VENDAS
FROM [Sales].[Order] AS SO
GROUP BY YEAR(SO.OrderDate)
ORDER BY ANO ASC;
```

![Faturamento total anual](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ConsultasSql/FaturamentoAnual.png)

##### Quantidade de Pedidos

```sql
-- Quantidade de Pedidos
SELECT
	COUNT(SO.OrderID) QTD_PEDIDOS
FROM [Sales].[Order] AS SO;
```

![Quantidade de Pedidos](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ConsultasSql/Pedidos.png)

##### Clientes Distintos

```sql
-- Número total de clientes distintos

SELECT DISTINCT
	
	COUNT(DISTINCT SO.CustomerID) QTD_CLIENTES

FROM [Sales].[Order] AS SO
;

```
![Clientes Distintos](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ConsultasSql/Clientes.png)

##### Top 10 produtos mais vendidos

```sql
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
ORDER BY TOTAL_PRECO DESC;
```

![Top10](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ConsultasSql/TopProdutos.png)

##### Media de Pagamento por Cliente

```sql
-- “Em média, quanto cada cliente gasta por pedido?"
	--  Calcular a média de valor total gasto por cliente.

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
FROM VENDAS_POR_CLIENTE AS VC;

```

![Media pagamento cliente](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ConsultasSql/VendasPorClientes.png)

##### Ticket Médio

```sql
-- ticket médio

SELECT 
  FORMAT(
    SUM(OrderTotal) * 1.0 / COUNT(OrderID),
    'C', 'pt-BR'
  ) AS TICKET_MEDIO
FROM Sales.[Order];


```

![Ticket medio](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ConsultasSql/TicketM%C3%A9dio.png)

##### Vendas Por Categoria

```sql
-- Vendas Por categorias 
SELECT
	C.CategoryID,
	C.Name,
	SUM(SI.LineTotal) TOTAL_VENDAS
FROM Sales.OrderItem AS SI
INNER JOIN Production.Product AS P ON P.ProductID = SI.ProductID
INNER JOIN Production.Category AS C ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryID,C.Name
ORDER BY TOTAL_VENDAS DESC;
```
![Vendas por Categoria](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ConsultasSql/VendasPorCategoria.png)

##### Vendas Por Marca

```sql
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
;
```
![Vendas por Marca](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ConsultasSql/VendasPorMarca.png)

##### Produtos Sem Faturamento

```sql
-- Produtos que não Venderam
SELECT
    P.ProductID,
    P.Name,
    P.ListPrice
FROM Production.Product P
LEFT JOIN Sales.OrderItem SI ON SI.ProductID = P.ProductID
WHERE SI.ProductID IS NULL;
```
![Produtos que nao Venderam](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ConsultasSql/ProdutosNaoVendidos.png)

##### Vendas Por Loja

```sql
SELECT
	SO.StoreID,
	SS.Name,
	ROUND(SUM(SO.OrderTotal) * 1.0 / COUNT(SO.OrderID), 2) AS TICKET_MEDIO,
	SUM(SO.OrderTotal) TOTAL_VENDAS,
	COUNT(SO.OrderID) QTD_PEDIDOS
FROM [Sales].[Order] AS SO
INNER JOIN Sales.Store AS SS ON SS.StoreID = SO.StoreID
GROUP BY SO.StoreID, SS.Name
ORDER BY TOTAL_VENDAS DESC;
```
![Vendas por Loja](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ConsultasSql/ReceitaPorLoja.png)

##### Vendas Por Funcionário

```sql
SELECT
	SO.EmployeeID,
	CONCAT(SE.FirstName,' ', SE.LastName) AS FullName,
	ROUND(SUM(SO.OrderTotal) * 1.0 / COUNT(SO.OrderID), 2) AS TICKET_MEDIO,
	COUNT(OrderID) QTD_PEDIDOS,
	SUM(SO.OrderTotal) TOTAL_VENDAS
FROM [Sales].[Order] AS SO
INNER JOIN Sales.Employee AS SE ON SE.EmployeeID = SO.EmployeeID
GROUP BY SO.EmployeeID, CONCAT(SE.FirstName,' ', SE.LastName);
```
![Vendas por Funcionario](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ConsultasSql/VendasPorFuncionario.png)

##### Funcionários sem Faturamento

```sql
-- Funcionários sem registros de vendas
SELECT
    SE.EmployeeID,
    CONCAT(SE.FirstName, ' ', SE.LastName) AS FullName
FROM Sales.Employee AS SE
LEFT JOIN Sales.[Order] AS SO ON SE.EmployeeID = SO.EmployeeID
WHERE SO.EmployeeID IS NULL;
```
![Fucinarios sem faturamento](https://github.com/NascimentoVitorDEV/BikeStoreRepositorio/blob/main/Imagens/ConsultasSql/FuncionariosSemVendas.png)

## Resultados e Insights

A análise da base BIKEStore gerou informações relevantes para o entendimento do negócio, abrangendo vendas, produtos e desempenho por loja:

### Evolução Anual de Vendas
Entre 2009 e 2019, o faturamento total apresentou oscilações significativas.
O pico ocorreu em 2009, com aproximadamente R$ 375 milhões, seguido de uma queda acentuada em anos posteriores, chegando a R$ 1,8 milhão em 2018, antes de uma recuperação para R$ 10,3 milhões em 2019.

### Base de Clientes
A empresa atendeu 1.445 clientes distintos no período analisado.

### Volume de Pedidos
Foram registrados 126.192 pedidos ao longo do histórico de vendas.

### Comportamento de Compra

Gasto médio por cliente: R$ 7.336,30

Ticket médio por pedido: R$ 7.351,30

### Produtos Mais Vendidos

Destaque para Trek Slash 8 27.5 - 2005, responsável por mais de R$ 67 milhões em vendas.

Outros produtos de alto desempenho incluem Trek Conduit+ 2005 e Trek Fuel EX 8 29 - 2005.

### Categorias de Produtos

Mountain Bikes: R$ 340 milhões

Road Bicycles: R$ 202 milhões

Cruisers Bicycles: R$ 116 milhões
As Mountain Bikes lideram com ampla margem.

### Marcas com Maior Receita

Trek: R$ 551 milhões

Electra: R$ 131 milhões

Surly: R$ 117 milhões

### Produtos Sem Vendas
Identificados diversos modelos que não registraram vendas no período, incluindo Electra Savannah 1 (20inch) - Girl’s - 2007 e Trek Checkpoint ALR 5 Women’s - 2008.

### Desempenho por Loja

Baldwin Bikes: R$ 637 milhões (86.048 pedidos, ticket médio R$ 7.339,95)

Santa Cruz Bikes: R$ 190 milhões (25.856 pedidos, ticket médio R$ 7.349,29)

Rowlett Bikes: R$ 100 milhões (13.488 pedidos, ticket médio R$ 7.428,19)


