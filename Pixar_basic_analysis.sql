-- What are the names and release years of all Pixar films?
SELECT film , YEAR(release_date) AS year
FROM pixar_filmss
ORDER BY release_date;

-- How many films has Pixar released each year?
SELECT YEAR(release_date) AS year, COUNT(*) AS no_of_films
FROM pixar_filmss
GROUP BY year
ORDER BY no_of_films DESC;

-- Which film has the longest runtime?
SELECT * 
FROM pixar_filmss
ORDER BY run_time DESC
LIMIT 1;

-- What is the average budget of all Pixar films?
SELECT ROUND(AVG(budget)) AS average_budget
FROM box_office;


-- Which genres are most common in Pixar films?
WITH gt AS (SELECT *
FROM genres
WHERE category='genre')

SELECT value AS filmgenre , COUNT(*) AS frequency
FROM gt
GROUP BY filmgenre
ORDER BY frequency DESC
LIMIT 3;

-- Which films won Academy Awards?
SELECT film
FROM academy
WHERE status LIKE '%won%';

-- List all directors and the number of films they have directed.
SELECT name AS directors, count(*) AS films
FROM pixar_people
WHERE role_type = 'Director'
GROUP BY directors;

-- Which Pixar film had the highest box office revenue (worldwide)?
SELECT film, box_office_worldwide AS box_office
FROM box_office
ORDER BY box_office_worldwide DESC
LIMIT 1;


-- List the top 5 highest-rated films according to public response.
SELECT film, imdb_score
FROM public_response
ORDER BY imdb_score DESC
LIMIT 5;

