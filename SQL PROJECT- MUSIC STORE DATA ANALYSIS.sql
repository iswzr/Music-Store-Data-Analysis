-- Selects the top 3 employees based on their levels

SELECT employee_id, first_name, last_name, title, levels
FROM employee
ORDER BY levels DESC
LIMIT 3;


-- Retrieves the top 10 countries by the number of invoices in descending order
SELECT billing_country, COUNT(*) AS total_invoices
FROM invoice
GROUP BY billing_country
ORDER BY total_invoices DESC
LIMIT 10;


-- Selects the top 5 invoices with the highest total amount
SELECT invoice_id, total
FROM invoice
ORDER BY total DESC
LIMIT 5;


-- Retrieves the top 10 cities by the total invoice amount, rounded to 2 decimal places
SELECT billing_city AS city, 
       ROUND(CAST(SUM(total) AS NUMERIC), 2) AS total_invoices
FROM invoice
GROUP BY billing_city
ORDER BY total_invoices DESC
LIMIT 10;


-- top 10 cust by ttal spending
SELECT c.customer_id, 
       c.first_name || ' ' || c.last_name AS customer_name, 
       ROUND(CAST(SUM(il.unit_price * il.quantity) AS NUMERIC), 2) AS total_spending
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spending DESC
LIMIT 10;


-- Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A
SELECT DISTINCT 
       c.email AS email, 
       c.first_name AS first_name, 
       c.last_name AS last_name, 
       g.name AS genre
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name LIKE 'Rock'
ORDER BY c.email ASC;

-- Let's invite the artists who have written the most rock music in our dataset. Write a 
-- query that returns the Artist name and total track count of the top 10 rock bands 
SELECT ar.name AS artist, 
       COUNT(*) AS total_tracks
FROM track t
JOIN album a ON t.album_id = a.album_id
JOIN artist ar ON a.artist_id = ar.artist_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.name
ORDER BY total_tracks DESC
LIMIT 10;

-- Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first 
SELECT name, milliseconds
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;


-- Find the amount spent by each customer on artists
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    ar.name AS artist_name,
    ROUND(CAST(SUM(il.unit_price * il.quantity) AS NUMERIC),2) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album a ON t.album_id = a.album_id
JOIN artist ar ON a.artist_id = ar.artist_id
GROUP BY c.customer_id, customer_name, ar.artist_id, ar.name
ORDER BY customer_name, total_spent DESC;


 -- Find the most popular music genre for each country based on the highest amount of purchases
SELECT 
    c.country,
    g.name AS genre_name,
    SUM(il.unit_price * il.quantity) AS total_amount
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY c.country, g.genre_id, g.name
HAVING SUM(il.unit_price * il.quantity) = (
    SELECT MAX(total_genre_amount)
    FROM (
        SELECT 
            SUM(il2.unit_price * il2.quantity) AS total_genre_amount
        FROM customer c2
        JOIN invoice i2 ON c2.customer_id = i2.customer_id
        JOIN invoice_line il2 ON i2.invoice_id = il2.invoice_id
        JOIN track t2 ON il2.track_id = t2.track_id
        JOIN genre g2 ON t2.genre_id = g2.genre_id
        WHERE c2.country = c.country
        GROUP BY g2.genre_id, g2.name
    ) AS genre_totals
)
ORDER BY c.country, genre_name;


-- Find the customer who has spent the most on music for each country
SELECT 
    c.country,
    c.first_name || ' ' || c.last_name AS top_customer,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
GROUP BY c.country, c.customer_id, top_customer
HAVING SUM(il.unit_price * il.quantity) = (
    SELECT MAX(country_total_spent)
    FROM (
        SELECT 
            c2.country,
            c2.customer_id,
            SUM(il2.unit_price * il2.quantity) AS country_total_spent
        FROM customer c2
        JOIN invoice i2 ON c2.customer_id = i2.customer_id
        JOIN invoice_line il2 ON i2.invoice_id = il2.invoice_id
        GROUP BY c2.country, c2.customer_id
    ) AS country_totals
    WHERE country_totals.country = c.country
)
ORDER BY c.country, total_spent DESC;





































