/* 📝 Exercício 6: Ranking de Clientes (Agregação + JOIN)
Objetivo: Descobrir quais clientes mais gastaram na locadora. Liste o nome, sobrenome e o total acumulado de pagamentos. */

SELECT 
    c.first_name AS nome,
    c.last_name AS sobrenome,
    SUM(p.amount) AS total_vendas
FROM customer AS c
LEFT JOIN payment AS p
	ON c.customer_id = p.customer_id
GROUP BY 
	c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_vendas DESC;


/* 📝 Exercício 7: Categorias Mais Lucrativas (Múltiplos JOINs)
Objetivo: Qual categoria de filme gerou mais receita para a locadora? Mostre o nome da categoria e a soma total de pagamentos. */

SELECT
	c.name AS categoria,
    SUM(p.amount) AS total_vendas
FROM category AS c
JOIN film_category AS fc
	ON c.category_id = fc.category_id
JOIN inventory AS i
	ON fc.film_id = i.film_id
JOIN rental AS r
	ON i.inventory_id = r.inventory_id
JOIN payment AS p
	ON r.rental_id = p.rental_id
GROUP BY
	c.category_id
ORDER BY total_vendas DESC;


/* 📝 Exercício 8: Filmes "Fantasmas" no Estoque
Objetivo: Identificar filmes que existem no cadastro (film), mas nunca foram alugados. */

SELECT 
    f.title,
    i.inventory_id,
    r.rental_id
FROM film AS f
LEFT JOIN inventory AS i 
	ON f.film_id = i.film_id
LEFT JOIN rental AS r 
	ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;


/* 📝 Exercício 9: Análise de Produtividade (Datas)
Objetivo: Agrupar os aluguéis por Mês/Ano e contar quantos ocorreram em cada período. */

SELECT
	DATE_FORMAT(rental_date, '%Y-%m') as Ano_mes,
    COUNT(rental_id) AS total_ocorrencias
FROM rental
GROUP BY
	Ano_mes
ORDER BY Ano_mes ASC;


/* 📝 Exercício 10: O Grand Finale (Clientes VIP com HAVING)
Objetivo: Listar o ID, Nome e a Contagem de Aluguéis de todos os clientes que alugaram mais de 40 filmes no total. */

SELECT
	c.customer_id,
    c.first_name,
    COUNT(r.rental_id) AS total_alugueis
FROM customer AS c
JOIN rental AS r
	ON c.customer_id = r.customer_id
GROUP BY
	c.customer_id,
    c.first_name
HAVING total_alugueis > 40
ORDER BY total_alugueis DESC;