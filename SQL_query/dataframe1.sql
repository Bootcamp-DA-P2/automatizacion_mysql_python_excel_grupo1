use sakila;

# Mostrar las 5 primeras filas de la tabla customer
SELECT *
FROM customer
LIMIT 5;

# Mostar columnas nombre y apellido(Solo 5 primeras filas)
SELECT first_name, last_name
FROM customer
LIMIT 5;

# Añadir filtro de clientes activos
SELECT first_name, last_name, active
FROM customer
WHERE active = 1;

# Añadir filtro por apellido especifico
SELECT first_name, last_name
FROM customer
WHERE last_name = 'SMITH';

# Ordenar registros por orden Ascendente
SELECT first_name, last_name
FROM customer
ORDER BY last_name ASC
LIMIT 10;

# Ordenar pagos por orden descendente
SELECT customer_id, amount
FROM payment
ORDER BY amount DESC
LIMIT 10;

# Contar numero total de clientes

SELECT COUNT(*) AS total_clientes
FROM customer;

# Contar clientes por ciudad
SELECT city_id, COUNT(*)AS total_clientes
FROM address
GROUP BY city_id;

# Consulta Join para unir columnas de clientes y ciudades con filtro de clientes activos
SELECT first_name,last_name
FROM customer
JOIN address ON customer.address_id = address.address_id
WHERE active = 1 AND (city_id = 1 OR city_id = 2);

# Consulta Join para unir dos tablas completas
SELECT * FROM customer
WHERE last_name IS NULL OR first_name IS NULL

UNION

SELECT * FROM address
WHERE address_id IS NULL;

# Filtrar por un letra coincidente, (Nombre que comiencen con M)
SELECT first_name, last_name
FROM customer
WHERE first_name LIKE 'M%';

# Filtrar por dato coincidente
SELECT first_name, last_name, email
FROM customer
WHERE email LIKE '%sakilacustomer%' OR '%gmail%';

# Filtrar por 5 pagos mas recientes
SELECT payment_id, customer_id, amount, payment_date
FROM payment
ORDER BY payment_date DESC
LIMIT 5;

# Unir con JOIN por clientes activos
SELECT c.first_name, c.last_name, ci.city
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
WHERE c.active = 1
ORDER BY ci.city ASC
LIMIT 10;

# Unir tabla de customer con datos importantes de address a través de address _id
SELECT
c.customer_id,
c.first_name,
c.last_name,
c.email,
c.active,
a.address,
a.district,
a.postal_code
FROM customer c
JOIN address a ON c.address_id = a.address_id;

#Añadimos los alquileres realizados por cada cliente

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.active,
    a.address,
    a.district,
    a.postal_code,
    ci.city,
    co.country,
    r.rental_date,
    r.return_date
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN rental r ON c.customer_id = r.customer_id;

# Unir ciudad y pais para construir la informacion geográfica del cliente

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.active,
    a.address,
    a.district,
    a.postal_code,
    ci.city,
    co.country
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

# Incorporamos pago para tener la informacion de pagos de los clientes
    CREATE VIEW vista_customer_activity AS
    SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.active,
    a.address,
    a.district,
    a.postal_code,
    ci.city,
    co.country,
    r.rental_date,
    r.return_date,
     p.amount,
    p.payment_date
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON p.rental_id = r.rental_id;

# Limpieza básica con SQL(minusculas, cambio de tipo de dato, y chequeo de nulls)
SELECT
customer_id,
LOWER(first_name) AS first_name,
LOWER(last_name) AS last_name,
LOWER(email) AS email,
active,
LOWER(address) AS address,
LOWER(district) AS district,
postal_code,
LOWER(city) AS city,
LOWER(country) AS country,
rental_date,
return_date,
amount,
payment_date,
DATEDIFF(return_date, rental_date) AS rental_duration
FROM vista_customer_activity
WHERE
rental_date is not null
AND return_date IS NOT NULL
AND amount > 0
AND rental_date < return_date;
