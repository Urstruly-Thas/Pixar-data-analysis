# Pixar Film Analytics - SQL Portfolio Project

## Project Background

This project dives into the business, creative, and commercial dimensions of Pixar Animation Studios using SQL-based analytics. With Pixar being a globally recognized film studio( and my personal favourite), this analysis holds relevance for multiple stakeholders:

Business Analysts & Executives: To understand what drives profitability and critical success.

Creative Teams (Writers, Directors): To assess audience reception, genre performance, and award trends.

Investors & Studio Heads: To evaluate return on investment (ROI), market timing, and long-term success patterns.

Data Enthusiasts: To demonstrate how SQL can uncover deep patterns in entertainment data.


## Data set

![Screenshot 2025-07-07 183816](https://github.com/user-attachments/assets/15fbd7af-9d2e-4356-9217-90d981f7bf69)

The dataset consists of multiple tables:

pixar_filmss: Metadata on each film including release date and runtime (film title, release date, runtime)

box_office: Budget and worldwide revenue.(Box_office)

public_response: IMDB and Rotten Tomatoes scores.

academy: Award wins and nominations.

genres: Genre tags per film.

pixar_people: Directors, screenwriters, and contributors.(ilm title, person’s name, role type (director, screenwriter, etc.)









































##methodology

I divide the questions into basic, intermediate and advanced:

[Uploading Pixar_basic_analysis.sql…]()
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

[Uploading Pixar_intermediate_analysis.sql…]()
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

[Uploading pixar_advanced_analysis.sql…]()-- Rank all Pixar films by ROI (Return on Investment) and identify outliers.
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
