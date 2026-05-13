SELECT
	co.country AS Pais,
    ci.city AS Ciudad,
    SUM(p.amount) AS Total_Ingresos,
    COUNT(p.payment_id) AS Numero_Transacciones
FROM payment p
JOIN customer cu ON p.customer_id = cu.customer_id
JOIN address a ON cu.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY co.country, ci.city
ORDER BY Total_Ingresos DESC;