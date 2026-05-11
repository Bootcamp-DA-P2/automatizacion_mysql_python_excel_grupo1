#Limpiamos las fechas. Las columnas rental_date y payment_date vienen con hora minuto y segundo. Necesitamos agruparlas por mes o día

# 1.Tendencia de Alquileres por Mes: para ver si el negocio está creciendo o si hay estacionalidad
SELECT 
    DATE_FORMAT(rental_date, '%Y-%m') AS mes, 
    COUNT(rental_id) AS total_alquileres
FROM rental
GROUP BY mes
ORDER BY mes;

# 2.Tendencia de Ingresos (Pagos) por Mes: para comparar el volumen de alquileres con el dinero real que entra
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS mes, 
    SUM(amount) AS ingresos_totales,
    COUNT(payment_id) AS numero_de_pagos
FROM payment
GROUP BY mes
ORDER BY mes;

# 3.Análisis por Día de la Semana: ¿La gente alquila más los fines de semana? Este análisis es clave para la toma de decisiones operativas (como poner más personal en tienda).
SELECT 
    DAYNAME(rental_date) AS dia_semana, 
    COUNT(*) AS total_alquileres
FROM rental
GROUP BY dia_semana
ORDER BY FIELD(dia_semana, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

# 4.Relación entre Alquiler y Pago: Para ver cuánto se tarda en pagar o cuánto genera cada día de actividad
SELECT 
    DATE(r.rental_date) AS fecha,
    COUNT(r.rental_id) AS volumen_alquileres,
    SUM(p.amount) AS recaudacion_diaria
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY fecha
ORDER BY fecha;

# 5. Relacion entre clientes activos y volumen de alquileres por mes y año
SELECT 
    DATE_FORMAT(r.rental_date, '%Y-%m-01') AS rental_date, 
    YEAR(r.rental_date) AS year, 
    MONTH(r.rental_date) AS month, 
    COUNT(r.rental_id) AS total_rentals, 
    SUM(p.amount) AS total_revenue, 
    COUNT(DISTINCT r.customer_id) AS active_customers 
FROM rental r 
LEFT JOIN payment p ON r.rental_id = p.rental_id 
GROUP BY 1, 2, 3 -- Esto agrupa por la 1ª, 2ª y 3ª columna del SELECT
ORDER BY year, month;