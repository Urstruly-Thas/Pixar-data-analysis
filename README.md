# Pixar Film Analytics - SQL Portfolio Project

## Project Background

This project dives into the business, creative, and commercial dimensions of Pixar Animation Studios using SQL-based analytics. With Pixar being a globally recognized film studio( and my personal favourite), this analysis holds relevance for multiple stakeholders:

Business Analysts & Executives: To understand what drives profitability and critical success.

Creative Teams (Writers, Directors): To assess audience reception, genre performance, and award trends.

Investors & Studio Heads: To evaluate return on investment (ROI), market timing, and long-term success patterns.

Data Enthusiasts: To demonstrate how SQL can uncover deep patterns in entertainment data.


## Dataset and Table Overview

![Screenshot 2025-07-07 183816](https://github.com/user-attachments/assets/15fbd7af-9d2e-4356-9217-90d981f7bf69)



This project uses a relational database of Pixar films structured across six core tables:

- **`pixar_filmss`** – film title, release date, run time  
- **`box_office`** – film title, budget, worldwide revenue  
- **`public_response`** – film title, IMDb score, Rotten Tomatoes score  
- **`academy`** – film title, Oscar win/nomination status  
- **`genres`** – film title, genre category, genre value  
- **`pixar_people`** – film title, person name, role type (Director, Screenwriter, etc.)

---

## 📊 Executive Summary

This SQL-driven project delivers a multi-level analysis of Pixar’s cinematic universe. Using common SQL tools like joins, CTEs, window functions, and conditional logic, it uncovers key patterns that explain how and why Pixar films perform well — or don’t — across financial, audience, and critical dimensions.

### 🧾 Film Outputs and Milestones

- **Total Films Analyzed:** 27  
- **First Release:** *Toy Story* (1995)  
- **Latest Film:** *Onward* (2020)  
- **Most Active Year:** 2017 with 3 releases

```sql
SELECT YEAR(release_date) AS year, COUNT(*) AS no_of_films
FROM pixar_filmss
GROUP BY year
ORDER BY no_of_films DESC;
💰 Financial Metrics
Average Budget: $137,777,778

sql
Copy
Edit
SELECT ROUND(AVG(budget)) AS average_budget FROM box_office;
Highest Revenue Film: Incredibles 2 – $1.24 Billion

Top 3 Most Profitable Films:

Incredibles 2 (~$1.1B net profit)

Toy Story 4

Finding Dory

sql
Copy
Edit
SELECT film, (box_office_worldwide - budget) AS profit
FROM box_office
ORDER BY profit DESC
LIMIT 3;
ROI Leaders:

Toy Story (ROI > 1000%)

Finding Nemo

Inside Out

sql
Copy
Edit
SELECT film, ((box_office_worldwide - budget)/budget) * 100 AS roi
FROM box_office
ORDER BY roi DESC;
🌐 Public and Critical Reception
Top IMDb Rated Films:

Inside Out – 8.5

Coco – 8.4

Up – 8.3

Toy Story 3 – 8.3

Finding Nemo – 8.2

sql
Copy
Edit
SELECT film, imdb_score
FROM public_response
ORDER BY imdb_score DESC
LIMIT 5;
Hidden Gems:
Inside Out and Up had high ratings despite below-average budgets.

sql
Copy
Edit
SELECT b.film, budget, imdb_score AS public_rating
FROM box_office b
JOIN public_response r ON b.film = r.film
WHERE imdb_score > 8 AND budget < (SELECT AVG(budget) FROM box_office)
ORDER BY budget DESC;
Award-Winning but Low IMDb:
Brave won an Oscar with an IMDb score < 8.0, showing divergence between public and industry verdicts.

🔍 Insights – A Deeper Dive
1️⃣ ROI and Outliers
sql
Copy
Edit
SELECT film, budget, box_office_worldwide,
((box_office_worldwide - budget)/budget) * 100 AS roi
FROM box_office
ORDER BY roi DESC;
Insight: Toy Story and Finding Nemo achieved extremely high ROI, proving large budgets aren't essential for profitability.

2️⃣ Hidden Gems
sql
Copy
Edit
SELECT b.film, budget, imdb_score AS public_rating
FROM box_office b
JOIN public_response r ON b.film = r.film
WHERE imdb_score > 8 AND budget < (SELECT AVG(budget) FROM box_office)
ORDER BY budget DESC;
Insight: Films like Inside Out were made below budget average yet received strong public acclaim.

3️⃣ Genre Consistency
sql
Copy
Edit
SELECT g.value AS genre, STDDEV(b.box_office_worldwide) AS revenue_std
FROM genres g
JOIN box_office b ON g.film = b.film
WHERE g.category = 'Genre'
GROUP BY genre
ORDER BY revenue_std ASC;
Insight: Adventure and Comedy genres had lower variance in revenue — safer for investments.

4️⃣ Seasonality
sql
Copy
Edit
SELECT MONTH(f.release_date) AS month_of_release, ROUND(AVG(b.box_office_worldwide)) AS box_office
FROM pixar_filmss f
JOIN box_office b ON f.film = b.film
GROUP BY month_of_release
ORDER BY box_office DESC;
Insight: June and November were consistently high-performing months — likely due to school breaks and holidays.

5️⃣ Awards vs Audience & Revenue
sql
Copy
Edit
SELECT COUNT(*) AS total_award_winners,
SUM(CASE WHEN imdb_score >= 8.0 AND box_office_worldwide > 300000000 THEN 1 ELSE 0 END) AS critically_and_commercially_successful,
ROUND(100.0 * SUM(CASE WHEN imdb_score >= 8.0 AND box_office_worldwide > 300000000 THEN 1 ELSE 0 END) / COUNT(*), 2) AS success_percentage
FROM academy a
JOIN public_response p ON a.film = p.film
JOIN box_office b ON a.film = b.film
WHERE a.status = 'Won';
Insight: Only ~30–40% of award-winning films were also major hits with audiences and at the box office.

6️⃣ Ideal Pixar Film Blueprint
sql
Copy
Edit
SELECT 
(SELECT value FROM genres GROUP BY value ORDER BY COUNT(*) DESC LIMIT 1) AS most_common_genre,
(SELECT MONTH(release_date) FROM pixar_filmss JOIN box_office USING(film) GROUP BY MONTH(release_date) ORDER BY AVG(box_office_worldwide) DESC LIMIT 1) AS best_release_month,
(SELECT ROUND(AVG(budget), 2) FROM box_office) AS avg_budget,
(SELECT ROUND(AVG(run_time), 2) FROM pixar_filmss) AS avg_runtime,
(SELECT name FROM pixar_people WHERE role_type = 'Director' GROUP BY name ORDER BY COUNT(*) DESC LIMIT 1) AS top_director;
Insight: The "ideal" Pixar film looks like this:

Genre: Adventure

Release Month: June

Budget: ~$137M

Runtime: ~100 minutes

Director: John Lasseter

✅ Recommendations
Based on the above insights, these data-backed recommendations are proposed:

Release Strategically in June/November
→ Capitalize on seasonal trends for maximum box office potential.

Focus on Adventure-Comedy Genres
→ Proven low-risk, high-return genres in both ROI and ratings.

Invest in Proven Creatives
→ Continue working with directors and writers like John Lasseter with a strong track record.

Avoid Over-Budgeting
→ Films above the ~$137M average don’t necessarily perform better — smart budgeting is key.

Maximize Post-Theatre Value for Award Films
→ Even without strong public ratings, Oscar wins can drive streaming, merch, and licensing revenue.








































