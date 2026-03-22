/*EXERCÍCIO 1: Lista de Contatos Ativos
Objetivo: Selecionar nome e email de clientes ativos*/
USE sakila;
SELECT
	first_name,
    last_name,
    email
FROM customer
WHERE active = 1
ORDER BY first_name;

/*📝 Exercício 2: Onde moram os nossos clientes? (JOIN Duplo)
Objetivo: Criar uma lista com o primeiro nome do cliente, o endereço e o nome da cidade.*/
SELECT 
	c.first_name,
    ci.city
FROM customer AS c
JOIN address AS a
	ON c.address_id = a.address_id
JOIN city AS ci
	ON a.city_id  = ci.city_id;


/*📝 Exercício 3: Filtrando Filmes por Categoria (WHERE + JOIN)
Objetivo: Listar todos os títulos de filmes que pertencem à categoria 'Action'.*/
SELECT
	f.title,
    cat.name
FROM film AS f
JOIN film_category AS fc
	ON f.film_id = fc.film_id
JOIN category AS cat
	ON fc.category_id = cat.category_id
WHERE cat.name = "Action";


/* 📝 Exercício 4: Contagem de Inventário (COUNT + GROUP BY)
Objetivo: Descobrir quantas cópias (unidades no inventário) existem para cada filme. */
SELECT
	f.film_id,
    f.title,
    count(i.inventory_id) as total_copias
FROM film as f
LEFT JOIN inventory AS i
	ON f.film_id = i.film_id
GROUP BY
	f.film_id,
    f.title;
    
    
/* 📝 Exercício 5: Os Maiores Pagamentos (LIMIT + ORDER BY)
Objetivo: Listar os 10 maiores pagamentos realizados, mostrando o ID do cliente e o valor. */
SELECT
	customer_id,
    amount
FROM payment
ORDER BY amount DESC
LIMIT 10;
