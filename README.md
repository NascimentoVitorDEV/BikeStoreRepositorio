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

##### Desempenho por Loja e por Funcionário

```sql
-- DESEMPENHO POR LOJA
SELECT
S.store_id,
Sum(P.amount) TOTALALUGUEIS
FROM store AS S
INNER JOIN staff AS SF ON SF.store_id = S.store_id
INNER JOIN payment AS P ON P.staff_id = SF.staff_id
GROUP BY S.store_id
ORDER BY S.store_id;

-- DESEMPENHO POR FUNCIONARIO
SELECT
SF.staff_id,
SF.first_name,
SUM(P.amount) TOTALALUGUEIS
FROM staff AS SF
INNER JOIN payment AS P ON P.staff_id = SF.staff_id
GROUP BY SF.staff_id, SF.first_name;
```

![Desempenho por Loja e por Funcionário](https://github.com/NascimentoVitorDEV/ProjetoSakila/blob/main/Imagens/DesempenhoPorFuncion%C3%A1rio.png)
![Desempenho por Funcionário](https://github.com/NascimentoVitorDEV/ProjetoSakila/blob/main/Imagens/DesempenhoPorLoja.png)

##### Top 10 Filmes Mais Alugados e Clientes que Mais Alugam

```sql
-- TOP 10 FILMES MAIS ALUGADOS
SELECT
F.film_id,
F.title,
COUNT(R.rental_id) QUANTIDADE_ALUGUEL
FROM film AS F
INNER JOIN inventory AS I ON I.film_id = F.film_id
INNER JOIN rental AS R ON R.inventory_id = I.inventory_id
GROUP BY F.film_id, F.title
ORDER BY QUANTIDADE_ALUGUEL DESC
LIMIT 10;

-- Clientes que mais alugam FILMES
SELECT
C.customer_id,
C.first_name,
COUNT(R.rental_id) QUANTIDADEALUGUEIS
FROM rental AS R
INNER JOIN customer AS C ON C.customer_id = R.customer_id
GROUP BY C.customer_id, C.first_name
ORDER BY QUANTIDADEALUGUEIS DESC
LIMIT 10;
```

![Top 10 Filmes Mais Alugados e Clientes que Mais Alugam](https://github.com/NascimentoVitorDEV/ProjetoSakila/blob/main/Imagens/Top10Filmes%20MaisAlugados.png)
![Top 10 Filmes Mais Alugados e Clientes que Mais Alugam](https://github.com/NascimentoVitorDEV/ProjetoSakila/blob/main/Imagens/ClientesMaisAtivos.png)

##### Clientes que Mais Pagaram Aluguel

```sql
-- clientes que mais pagaram aluguel
SELECT
C.customer_id,
C.first_name,
SUM(P.amount) TOTALALUGUEIS
FROM payment AS P
INNER JOIN customer AS C ON C.customer_id = P.customer_id
ORDER BY TOTALALUGUEIS DESC
LIMIT 10;

```

![Clientes que Mais Pagaram Aluguel e Região com Maior Número de Aluguéis](https://github.com/NascimentoVitorDEV/ProjetoSakila/blob/main/Imagens/ClientesMaisPagaram.png)

##### Lojas que Geram Mais Receita e Onde Estão Localizadas

```sql
-- Lojas que geram mais receita e onde estão localizadas
SELECT
S.store_id,
CI.city,
CO.country,
SUM(P.amount) AS TOTAL_RECEITA,
COUNT(R.rental_id) AS QTD_ALUGUEIS,
AVG(P.amount) AS TICKET_MEDIO
FROM payment AS P
JOIN rental AS R ON R.rental_id = P.rental_id
JOIN inventory AS I ON I.inventory_id = R.inventory_id
JOIN store AS S ON S.store_id = I.store_id
JOIN address AS A ON S.address_id = A.address_id
JOIN city AS CI ON A.city_id = CI.city_id
JOIN country AS CO ON CI.country_id = CO.country_id
GROUP BY S.store_id, CI.city, CO.country
ORDER BY TOTAL_RECEITA DESC;
```

![Lojas que Geram Mais Receita e Onde Estão Localizadas](https://github.com/NascimentoVitorDEV/ProjetoSakila/blob/main/Imagens/Regia%C3%A3o.png)

##### Categorias com Maior Rendimento

```sql
SELECT

    FC.category_id,
    C.name,
    SUM(P.amount) TOTAL_ALUGUEIS
    
FROM film  AS F
INNER JOIN film_category AS FC ON FC.film_id = F.film_id
INNER JOIN category AS C ON C.category_id = FC.category_id
INNER JOIN inventory AS I ON I.film_id = F.film_id
INNER JOIN rental AS R ON R.inventory_id = I.inventory_id
INNER JOIN payment AS P ON P.rental_id = R.rental_id
GROUP BY  FC.category_id, C.name
ORDER BY  FC.category_id ASC;

```

![Categorias que mais alugam](https://github.com/NascimentoVitorDEV/ProjetoSakila/blob/main/Imagens/CategoriasComMaiorRendimento.png)

##### AnáliseTemporal

```sql
SELECT
	YEAR(P.payment_date) ANO,
    MONTH(P.payment_date) MES,
	SUM(P.amount) AS PAGAMENTOS
FROM payment AS P
GROUP BY YEAR(P.payment_date), MONTH(P.payment_date)
ORDER BY ANO, MES;


```

![AnáliseAoLongodoTempo](https://github.com/NascimentoVitorDEV/ProjetoSakila/blob/main/Imagens/AnaliseTempo.png)


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



