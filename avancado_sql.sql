/* 📝 Exercício 11: Filmes Acima da Média (Subqueries)
Objetivo: Listar todos os filmes cujo rental_rate (valor de aluguel) seja maior que a média de todos os filmes do catálogo. */

SELECT
	title AS titulo,
    rental_rate AS valor_aluguel
FROM film
WHERE rental_rate > (SELECT avg(rental_rate) FROM film)
ORDER BY rental_rate ASC;


/* 📝 Exercício 12: Criando uma Vitrine de Vendas (VIEW)
Objetivo: Criar uma VIEW chamada resumo_vendas_por_loja que mostre o ID da loja, a cidade e o total de vendas (faturamento) de cada uma. */

CREATE VIEW resumo_vendas_por_loja AS
SELECT 
	s.store_id,
    c.city,
    SUM(p.amount) as total_pagamentos
FROM store AS s
JOIN address AS a
	ON s.address_id = a.address_id
JOIN city as c
	ON a.city_id = c.city_id
JOIN staff AS sf
	ON s.store_id = sf.store_id
JOIN payment AS p
	ON sf.staff_id = p.staff_id
GROUP BY
	s.store_id,
    c.city;
    
SELECT *
FROM resumo_vendas_por_loja;


/* 📝 Exercício 13: O "Terror do Marketing" (NOT IN)
Objetivo: Identificar os clientes que já alugaram filmes, mas NUNCA alugaram um filme da categoria 'Action'. */

SELECT
	customer_id,
	first_name,
	last_name
FROM customer
WHERE customer_id NOT IN (
	SELECT DISTINCT
		r.customer_id
	FROM rental AS r
	JOIN inventory AS i
		ON r.inventory_id = i.inventory_id
	JOIN film_category AS fc
		ON i.film_id = fc.film_id
	JOIN category AS cat
		ON fc.category_id = cat.category_id
	WHERE cat.name = "Action");
    


/* 📝 Exercício 14: Classificando Clientes (O "Sênior Mode")
Objetivo: Criar um relatório que mostre o nome do cliente, o total de aluguéis que ele já fez e uma coluna de Status:

Se o total de aluguéis for maior que 30, o status é 'Premium'.
Se for 30 ou menos, o status é 'Regular'. */

WITH qtde_alugueis AS (
	SELECT
		customer_id,
        count(rental_id) as cont_alugueis
	FROM rental
    GROUP BY customer_id
)
SELECT
	c.first_name,
    al.cont_alugueis,
    CASE
		WHEN al.cont_alugueis > 30 THEN 'Premium'
        ELSE 'Regular'
	END AS classificacao
FROM customer AS c
JOIN qtde_alugueis as al
	ON c.customer_id = al.customer_id
ORDER BY cont_alugueis ASC;


/* 📝 Exercício 15: O Top 1 por Categoria
Objetivo: Mostrar o nome da categoria, o título do filme e a quantidade de vezes que ele foi alugado, mas apenas para o filme número 1 de cada categoria. */

WITH qtde_alugueis AS (
	SELECT
		c.name as "Nome da Categoria",
        f.title as "Título do Filme",
        count(r.rental_id) as "Contagem de Aluguéis",
        DENSE_RANK() OVER (
			PARTITION BY c.name
            ORDER BY count(r.rental_id) DESC
            )
            AS Ranking
	FROM category as c
    JOIN film_category as fc
		ON c.category_id = fc.category_id
	JOIN film as f
		ON fc.film_id = f.film_id
	JOIN inventory as i
		ON fc.film_id = i.film_id
	JOIN rental as r
		ON i.inventory_id = r.inventory_id
	GROUP BY
		c.name,
        f.title
)

SELECT *
FROM qtde_alugueis
WHERE Ranking = 1;

