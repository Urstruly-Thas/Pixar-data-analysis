-- Rank all Pixar films by ROI (Return on Investment) and identify outliers.
# ROI = (Net Profit / Cost of Investment) * 100
SELECT film, 
budget, box_office_worldwide, 
((box_office_worldwide - budget)/budget) * 100 AS roi,
RANK() OVER (ORDER BY ((box_office_worldwide - budget)/budget) * 100 DESC) AS rand_roi
FROM box_office;

-- Create a rolling average of box office revenue over a 5-year window.
SELECT p.film, box_office_worldwide,
YEAR(p.release_date) AS year,
ROUND(Avg(box_office_worldwide) OVER (ORDER BY YEAR(release_date)  ROWS BETWEEN 4 preceding AND current row),2)AS rolling_avg
FROM box_office b
JOIN pixar_filmss p
ON b.film = p.film;

-- Identify 'hidden gems': Films that had lower budgets but high public ratings.
SELECT b.film, budget , imdb_score AS public_rating
FROM box_office b
JOIN public_response r
ON b.film = r.film
WHERE imdb_score > 8 AND budget < 143777778       #using the AVG
ORDER BY budget DESC;

-- Determine if films with more than one genre perform better on average. #all our films have a genre count of 3!!!
SELECT genre_count AS no_of_genres, ROUND(AVG(box_office),2) AS avg_budget 
FROM
 (SELECT g.film , COUNT( g.value ) AS genre_count   , b.box_office_worldwide AS box_office
FROM genres g
JOIN box_office b
ON g.film = b.film
WHERE g.category = "genre"
Group BY g.film, box_office) genre_data 
GROUP BY no_of_genres;

-- Cluster films into categories based on box office revenue quartiles.
WITH ranked AS (SELECT 
    film,
    box_office_worldwide,
    NTILE(4) OVER (ORDER BY box_office_worldwide) AS revenue_quartile
FROM box_office)

SELECT 
    film,
    box_office_worldwide,
    CASE 
        WHEN revenue_quartile = 1 THEN 'Low Revenue (Q1)'
        WHEN revenue_quartile= 2 THEN 'Mid-Low Revenue (Q2)'
        WHEN revenue_quartile = 3 THEN 'Mid-High Revenue (Q3)'
        WHEN revenue_quartile = 4 THEN 'High Revenue (Q4)'
    END AS revenue_category
    FROM ranked;

-- Which genres show the most consistency in performance (low standard deviation in revenue)?
SELECT g.value AS genre, 
       ROUND(STDDEV(b.box_office_worldwide), 2) AS revenue_std
FROM genres g
JOIN box_office b ON g.film = b.film
WHERE g.category = 'Genre'
GROUP BY genre
ORDER BY revenue_std ASC;


-- Do certain directors tend to work with specific genres repeatedly?
SELECT p.name AS director, g.value AS genre, Count(*) AS film_count
FROM pixar_people p
JOIN genres g
USING(film)
WHERE p.role_type = "Director" AND g.category = "genre"
GROUP BY director, genre
ORDER BY film_count DESC;


-- Which year had the best average public rating, and how does that align with revenue?
SELECT YEAR(f.release_date) AS year,
       ROUND(AVG(imdb_score), 2) AS avg_rating,
       ROUND(AVG(box_office_worldwide), 2) AS avg_revenue
FROM pixar_filmss f
JOIN public_response p ON f.film = p.film
JOIN box_office b ON f.film = b.film
GROUP BY year
ORDER BY avg_rating DESC
LIMIT 1;


-- What percentage of award-winning films also performed well in public ratings and revenue?
WITH award_films AS (
SELECT DISTINCT film , status
FROM academy 
WHERE status = "won")

SELECT af.film, r.imdb_score , (b.box_office_worldwide - b.budget) AS revenue , af.status
FROM public_response r
JOIN box_office b ON r.film = b.film
JOIN award_films af ON b.film = af.film
WHERE imdb_score > 8 
ORDER BY revenue, imdb_score;

#OR

SELECT 
    COUNT(*) AS total_award_winners,
    SUM(CASE 
           WHEN imdb_score >= 8.0 AND box_office_worldwide > 300000000 THEN 1 
           ELSE 0 
           END) AS critically_and_commercially_successful,
    ROUND(100.0 * SUM(CASE 
                          WHEN imdb_score >= 8.0 AND box_office_worldwide > 300000000 THEN 1 
                          ELSE 0 
                          END) / COUNT(*), 2) AS success_percentage
FROM academy a
JOIN public_response p ON a.film = p.film
JOIN box_office b ON a.film = b.film
WHERE a.status = 'Won';


-- Build a profile of the ideal Pixar film — genre, budget, month of release, runtime, director - based on past top-performing films.
-- Most common genre, best release month, avg budget, avg runtime, top directors

SELECT 
(SELECT value 
 FROM genres 
 GROUP BY value
 ORDER BY count(*) DESC
 LIMIT 1) AS most_common_genre,
(SELECT MONTH(release_date) 
FROM pixar_filmss
 JOIN box_office 
 USING(film) 
 GROUP BY MONTH(release_date) 
 ORDER BY AVG(box_office_worldwide) DESC LIMIT 1) AS best_release_month,
(SELECT ROUND(AVG(budget), 2) 
FROM box_office) AS avg_budget,
(SELECT ROUND(AVG(run_time), 2) 
FROM pixar_filmss) AS avg_runtime,
(SELECT name 
FROM pixar_people 
WHERE role_type = 'Director' 
GROUP BY name 
ORDER BY COUNT(*) DESC LIMIT 1) AS top_director;