SELECT 
    DATE_FORMAT(r.rental_date, '%Y-%m') AS periodo,
    COUNT(r.rental_id) AS total_alquileres,
    COUNT(DISTINCT r.customer_id) AS clientes_activos,
    SUM(p.amount) AS ingresos_totales,
    -- Calculamos el ticket promedio por alquiler
    ROUND(SUM(p.amount) / COUNT(r.rental_id), 2) AS ticket_promedio,
    -- Calculamos la media de alquileres por cliente activo
    ROUND(COUNT(r.rental_id) / COUNT(DISTINCT r.customer_id), 2) AS alquileres_por_cliente
FROM rental r
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY periodo
ORDER BY periodo;