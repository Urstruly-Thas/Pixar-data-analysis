-- What is the average box office revenue by genre?

SELECT g.value AS genre , ROUND(AVG(box_office_worldwide)) AS avg_box_office
FROM box_office bo 
JOIN genres g ON
bo.film = g.film
WHERE category = "Genre"
GROUP BY genre;

-- Which directors have the highest average film rating (min 2 films)?

SELECT p.name AS director, ROUND(avg(r.imdb_score)) AS avg_rating, COUNT(*) AS film_count
FROM pixar_people p
JOIN public_response r ON
p.film = r.film
WHERE role_type = "Director"
GROUP BY director
HAVING film_count >= 2
ORDER BY avg_rating DESC;

-- Identify trends in genre popularity over time.
SELECT g.value AS genre, YEAR(f.release_date) AS year,
    ROUND(AVG(r.imdb_score)) AS avg_imdb_rating
FROM genres g
JOIN pixar_filmss f ON g.film = f.film
JOIN public_response r ON f.film = r.film
WHERE g.category = 'Genre'
GROUP BY genre, year
ORDER BY year, avg_imdb_rating DESC;

-- Which release months yield higher box office success?

SELECT MONTH(f.release_date) AS month_of_release, ROUND(AVG(b.box_office_worldwide)) AS box_office
FROM pixar_filmss f
LEFT JOIN box_office b
ON f.film = b.film
GROUP BY month_of_release
ORDER BY box_office DESC;

-- Which films had low public ratings but won academy awards?
SELECT a.film , r.rotten_tomatoes_score , a.status , r.imdb_score
FROM public_response r 
JOIN academy a
ON r.film = a.film
WHERE r.imdb_score < 8 AND a.status = "won";
 #Pixar films won awards despite lower critic scores, possibly due to emotional impact, cultural relevance, or industry legacy.
 
-- Find the top 3 most profitable films (revenue - budget).
SELECT film, (box_office_worldwide - budget) AS profit
FROM box_office
ORDER BY profit DESC
LIMIT 3;

-- Compare films with awards vs. those without — which perform better in box office?

WITH awarded_films AS (
    SELECT DISTINCT film
    FROM academy
    WHERE status = 'Won'
),

box_office_grouped AS (
    SELECT 
        b.film,
        b.box_office_worldwide,
        CASE 
            WHEN a.film IS NOT NULL THEN 'Awarded'
            ELSE 'Not Awarded'
        END AS award_status
    FROM box_office b
    LEFT JOIN awarded_films a ON b.film = a.film
)

SELECT 
    award_status,
    COUNT(*) AS num_films,
    ROUND(AVG(box_office_worldwide)) AS avg_worldwide_box_office
FROM box_office_grouped
GROUP BY award_status;

#if we want to know individual films, their status and box office
WITH awarded_films AS (
SELECT DISTINCT film , status
FROM academy a
WHERE a.status = "won")

SELECT 
        b.film,
        b.box_office_worldwide,
        CASE 
            WHEN a.film IS NOT NULL THEN 'Awarded'
            ELSE 'Not Awarded'
        END AS award_status
    FROM box_office b
    LEFT JOIN awarded_films a ON b.film = a.film;
  
-- Which writers are associated with the most successful box office films?
SELECT name AS writer , box_office_worldwide AS box_office , p.film
FROM pixar_people p
JOIN box_office b
ON p.film = b.film
WHERE role_type = "Screenwriter"
ORDER BY box_office DESC
LIMIT 5 ;

-- Analyze the evolution of average runtime and budget over the years.
SELECT  YEAR(release_date) AS Year, ROUND(AVG(run_time),2) AS avg_runtime, ROUND(AVG(budget),2) AS  avg_budget
FROM pixar_filmss p
JOIN box_office b
ON p.film = b.film
GROUP BY Year
ORDER BY Year;