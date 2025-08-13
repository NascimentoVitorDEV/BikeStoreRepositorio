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

Também foram criadas colunas calculadas para facilitar o uso de datas e filtros.

#### 3. Construção do Dashboard

O dashboard foi construído com foco em interatividade, clareza e apoio à decisão. Algumas das funcionalidades implementadas:

*   Evolução da Receita no Tempo: análise mensal e anual.
*   Top Categorias e Produtos: filtros cruzados com métricas.
*   Performance de Lojas e Funcionários: comparativo de receita.
*   Drill Through das Vendas: análise detalhada de uma venda.
*   Filtros Flutuantes: seleção por ano, mês, loja, categoria etc.
*   Tooltips customizados: insights adicionais ao passar o cursor.
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

Com base nas análises detalhadas da base de dados Sakila, os seguintes resultados e insights foram identificados, fundamentados nos dados extraídos e visualizados:

###  Receita ao Longo do Tempo: Sazonalidade e Crescimento

A análise temporal da receita (`AnaliseTempo.png`) revela uma clara sazonalidade e um crescimento significativo no faturamento da locadora. Observa-se um aumento notável da receita de **maio a julho de 2005**, com os pagamentos saltando de **R$ 4.823,44 em maio** para **R$ 28.368,91 em julho**. Embora haja uma leve queda em agosto (R$ 24.070,14), o ano de 2006 inicia com um valor menor em fevereiro (R$ 514,18), indicando que o período de alta performance se concentra nos meses de verão. Essa tendência sugere a importância de estratégias de marketing e estoque focadas nesses meses de pico para maximizar os lucros.

### Categorias Mais Lucrativas: O Foco da Demanda

As categorias de filmes com maior rendimento (`CategoriasComMaiorRendimento.png`) são cruciais para o negócio. As três categorias que geraram a maior receita são:

*   **Sports:** R$ 5.314,21
*   **Sci-Fi:** R$ 4.756,98
*   **Animation:** R$ 4.656,30

Esses dados reforçam que filmes de ação, ficção científica e animação são os pilares da receita da locadora, indicando onde o investimento em novos títulos e promoções deve ser prioritário.

### Top 10 Filmes Mais Alugados: Os Blockbusters da Locadora

Os dez filmes mais alugados (`Top10FilmesMaisAlugados.png`) demonstram a concentração da demanda em títulos específicos. Os líderes em quantidade de aluguéis são:

*   **BUCKET BROTHERHOOD:** 34 aluguéis
*   **ROCKETEER MOTHER:** 33 aluguéis
*   **FORWARD TEMPLE:** 32 aluguéis

Manter um estoque robusto desses filmes é essencial para atender à demanda e evitar perdas de vendas. Estratégias para promover filmes menos populares ou de outras categorias podem ajudar a diversificar a receita.

### Categorias com Maior Rendimento

A análise das categorias de filmes revelou quais gêneros são os mais lucrativos para a locadora. Conforme os dados, as categorias que geraram maior receita são:

*   **Sports:** R$ 5.314,21
*   **Sci-Fi:** R$ 4.756,98
*   **Animation:** R$ 4.656,30

Esses resultados indicam que filmes de **Esporte**, **Ficção Científica** e **Animação** são os que mais contribuem para o faturamento. Este insight é fundamental para direcionar a aquisição de novos títulos e o foco das campanhas de marketing, garantindo que a oferta esteja alinhada com a demanda e o potencial de receita.

### Performance das Lojas: Comparativo de Desempenho

A análise de desempenho por loja (`DesempenhoPorLoja.png` e `Regiaão.png`) revela que a **Loja 2 (Woodridge, Austrália)** gerou uma receita ligeiramente superior de **R$ 33.726,77** com 8.121 aluguéis e um ticket médio de R$ 4,15. Já a **Loja 1 (Lethbridge, Canadá)** obteve **R$ 33.679,79** em receita com 7.923 aluguéis e um ticket médio de R$ 4,25. Embora os valores totais sejam próximos, a Loja 1 apresenta um ticket médio ligeiramente maior, indicando que, em média, seus clientes gastam um pouco mais por aluguel. Essa pequena diferença pode ser explorada para entender as práticas que levam a um ticket médio mais alto.

### Funcionários com Maior Receita Gerada: Reconhecimento e Benchmarking

O desempenho dos funcionários (`DesempenhoPorFuncionário.png`) mostra que **Jon** gerou **R$ 33.924,06** em aluguéis, enquanto **Mike** gerou **R$ 33.482,50**. Essa proximidade nos valores indica uma performance equilibrada entre os dois principais funcionários. A análise individual pode ser aprofundada para identificar as melhores práticas de cada um e aplicá-las em treinamentos para otimizar o atendimento e as vendas.

### Comportamento dos Clientes: Identificando e Fidelizando

Duas análises complementares sobre o comportamento do cliente foram realizadas:

*   **Clientes Mais Ativos por Quantidade de Aluguéis** (`ClientesMaisAtivos.png`): **ELEANOR** (46 aluguéis), **KARL** (45 aluguéis) e **CLARA** (42 aluguéis) são os clientes que mais alugam filmes. Esses clientes representam a base de usuários mais engajada.
*   **Clientes que Mais Pagaram Aluguel** (`ClientesMaisPagaram.png`): **KARL** (R$ 221,55), **ELEANOR** (R$ 216,54) e **CLARA** (R$ 195,58) são os que mais contribuíram para a receita. É interessante notar que os clientes mais ativos por quantidade de aluguéis também são os que mais pagam, reforçando a importância de programas de fidelidade e reconhecimento para esses clientes VIP.

### Ticket Médio por Cliente: Valor da Transação Individual

O valor médio pago por cliente (`ValorMedioPorClient.png`) oferece uma visão sobre o gasto individual. Embora a imagem mostre o total de aluguéis e o valor médio, o foco aqui é o valor médio por cliente. Por exemplo, **ANA** tem um valor médio de **R$ 5,14**, enquanto **KARL** tem **R$ 4,92**. Essa métrica é fundamental para segmentar clientes e criar ofertas personalizadas que incentivem um maior gasto por aluguel.



