# query para establecer relacion ente comportamiento de clientes y patrones de consumo
-- Objetivo
 -- clientes mas activos
 -- clientes que mas gastan
 -- frecuencia de alquileres

-- Tablas
	-- customer
    -- adress
    -- city
    -- country
    -- rental
    -- payment

Use sakila;

SHOW TABLES;

SELECT *
FROM customer;
 
#conectar customer con address a traves de address.id
 
SELECT
 c.customer_id,
 c.first_name,
 c.last_name,
 a.address
 FROM customer c
 JOIN address a
 ON c.address_id = a.address_id;
 
 #establecer relacion address y city
 
 SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ci.city
FROM customer c
JOIN address a
    ON c.address_id = a.address_id
JOIN city ci
    ON a.city_id = ci.city_id;
    
# Añadir country a la relación
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ci.city,
    co.country
FROM customer c
JOIN address a
    ON c.address_id = a.address_id
JOIN city ci
    ON a.city_id = ci.city_id
JOIN country co
    ON ci.country_id = co.country_id;
    
#Agrupamos por cliente
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_rentals
FROM customer c
JOIN rental r
    ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name;
 
 SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_rentals,
    SUM(p.amount) AS total_spent
FROM customer c
JOIN rental r
    ON c.customer_id = r.customer_id
JOIN payment p
    ON r.rental_id = p.rental_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name;

#consulta final que cuenta alquilers, suma pagos, hace promedio de gastos, agrupa por clientes y concatena nombre y apellido.
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    ci.city,
    co.country,

    COUNT(DISTINCT r.rental_id) AS total_rentals,

    ROUND(SUM(p.amount), 2) AS total_spent,

    ROUND(AVG(p.amount), 2) AS avg_payment,

    MAX(r.rental_date) AS last_rental_date

FROM customer c

JOIN address a
    ON c.address_id = a.address_id

JOIN city ci
    ON a.city_id = ci.city_id

JOIN country co
    ON ci.country_id = co.country_id

JOIN rental r
    ON c.customer_id = r.customer_id

JOIN payment p
    ON r.rental_id = p.rental_id

GROUP BY
    c.customer_id,
    full_name,
    ci.city,
    co.country

ORDER BY total_spent DESC;