# Pixar Film Analytics - SQL Portfolio Project

![Screenshot 2025-07-08 015712](https://github.com/user-attachments/assets/035de5f3-7cfd-4361-b991-95e63e9b206f)


## Project Background

This project dives into the business, creative, and commercial dimensions of Pixar Animation Studios using SQL-based analytics. With Pixar being a globally recognized film studio( and my personal favourite), this analysis holds relevance for multiple stakeholders:

- Business Analysts & Executives: To understand what drives profitability and critical success.
- Creative Teams (Writers, Directors): To assess audience reception, genre performance, and award trends.
- Investors & Studio Heads: To evaluate return on investment (ROI), market timing, and long-term success patterns.
- Data Enthusiasts: To demonstrate how SQL can uncover deep patterns in entertainment data.


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

##  Executive Summary
This project uses SQL to analyze Pixar Animation Studios' filmography, covering 27 titles from 1995 to 2020. By querying a relational database with six normalized tables-including data on budgets, revenue, public ratings, genre, release dates, and awards,we derive patterns in profitability, critical success, and creative decisions. The analysis applies SQL tools like CTEs, aggregations, and window functions to evaluate return on investment, release timing, genre consistency, and award alignment. For example, Toy Story achieved over 1000% ROI despite a modest budget, while Incredibles 2, released in June, became the highest-grossing Pixar film. Genres like Adventure and Comedy emerged as high-performing and stable, while directors such as John Lasseter consistently contributed to critically and commercially successful films. The project not only visualizes trends but also recommends strategic actions Pixar could take,from maintaining optimal budgets to leveraging underappreciated "hidden gems" like Inside Out and Up. The insights offer practical value for data-driven decision-making in creative industries.

###  Films and Milestones

- **Total Films Analyzed:** 27  
- **First Release:** *Toy Story* (1995)  
- **Latest Film:** *Onward* (2020)  
- **Most Active Year:** 2017 with 3 releases

```sql
SELECT YEAR(release_date) AS year, COUNT(*) AS no_of_films
FROM pixar_filmss
GROUP BY year
ORDER BY no_of_films DESC;
```

### Key Performance Indicators

- **Average Budget:** $137,777,778
- **Top Profitable Films:**
      - Incredibles 2 – $1.1B profit
      - Toy Story 4
      - Finding Dory
- **ROI Leaders:**
      - Toy Story (ROI > 1000%)
      - Finding Nemo
      - Inside Out

```sql
SELECT ROUND(AVG(budget)) AS average_budget FROM box_office;
Highest Revenue: Incredibles 2 – $1.24 billion

SELECT film, (box_office_worldwide - budget) AS profit
FROM box_office
ORDER BY profit DESC
LIMIT 3;

SELECT film, ((box_office_worldwide - budget)/budget) * 100 AS roi
FROM box_office
ORDER BY roi DESC;
```

- **Top IMDb Rated Films:**

- Inside Out – 8.5
- Coco – 8.4
- Up – 8.3
- Toy Story 3 – 8.3
- Finding Nemo – 8.2


## Insights And Recommendations

### 1. Prioritize Film Releases in June and November
June and November have the highest average revenues - over $700M in some years - thanks to school holidays and family-friendly timing. For instance, Incredibles 2 (June) earned over $1.24B.

```sql
SELECT MONTH(f.release_date) AS month_of_release, ROUND(AVG(b.box_office_worldwide)) AS box_office
FROM pixar_filmss f
JOIN box_office b ON f.film = b.film
GROUP BY month_of_release
ORDER BY box_office DESC;
```



### 2. Adventure and Comedy emerged as the most popular and all time genres
Genres like Adventure and Comedy showed the lowest revenue variability (standard deviation < $250M) and highest box office averages (Adventure: $637M+). They offer reliable performance both critically and commercially

```sql
SELECT g.value AS genre, ROUND(STDDEV(b.box_office_worldwide), 2) AS revenue_std
FROM genres g
JOIN box_office b ON g.film = b.film
WHERE g.category = 'Genre'
GROUP BY genre
ORDER BY revenue_std ASC;
```


### 3.Directors Like John Lasseter and Pete Docter proved their prowess
John Lasseter, Pixar’s most frequent director, directed multiple top-grossing and highly-rated films including Toy Story, A Bug's Life, and Cars. His films helped establish Pixar’s box office dominance in its early years.

```sql
SELECT name FROM pixar_people
WHERE role_type = 'Director'
GROUP BY name
ORDER BY COUNT(*) DESC
LIMIT 1;
```

###  4. Maintain Budgets Around $137M
The average budget is ~$137M. Films exceeding this (eg, The Good Dinosaur at ~$200M) often underperformed in ROI. Meanwhile, Inside Out (budget ~$175M) showed good returns but not proportional to investment, emphasizing budget control.

```sql
SELECT ROUND(AVG(budget)) FROM box_office;
```

### 5.Promote films like the Hidden Gems More Aggressively
Inside Out and Up both had IMDb scores above 8.3 with below-average budgets, yet were less hyped than bigger-budget peers. These films demonstrate strong organic appeal that could be capitalized on via marketing and streaming.

```sql
SELECT b.film, budget, imdb_score
FROM box_office b
JOIN public_response r ON b.film = r.film
WHERE imdb_score > 8 AND budget < (SELECT AVG(budget) FROM box_office)
ORDER BY budget DESC;
```

### 6.Use ROI Analysis to Greenlight Sequels and Spin-offs
Toy Story posted ROI over 1,000% , justifying its sequels. High-ROI films like Finding Nemo and Cars have strong franchise potential. This metric is a better greenlighting tool than revenue alone.

```sql
SELECT film, ((box_office_worldwide - budget)/budget) * 100 AS roi
FROM box_office
ORDER BY roi DESC;
```

### 7. Leverage Runtime and Genre Consistency to Optimize Viewer Retention
The average runtime is ~100 minutes , a sweet spot for family-friendly pacing. Deviating significantly (eg., Cars 2 at 113 mins or Soul at 90 mins) risks either fatigue or lack of depth. Sticking to ~100 minutes optimizes engagement for Pixar’s primary demographic

```sql
SELECT ROUND(AVG(run_time), 2) FROM pixar_filmss;
```

### 8.Target Award-Winning Films for Streaming & Merchandising
Only 30–40% of Oscar-winning films also performed well commercially. "Brave", for example, had a lower IMDb (7.1) but still won Best Animated Feature , making it ideal for post-theatrical monetization via merchandising, licensing, or platform-exclusive features.



## Conclusion

This SQL project demonstrates how structured data and targeted queries can uncover meaningful insights in the film industry. By analyzing Pixar's catalog across financial, creative, and critical dimensions, we show how performance is influenced by factors such as release month, genre consistency, directorial leadership, and budget control. The data suggests actionable strategies: release films in high-performing months like June, focus on proven genres, maintain a budget close to $137M, and use ROI—not just revenue—as a decision-making tool. It also highlights opportunities for monetizing award-winning films that may not succeed at the box office but hold long-term value. Overall, this project bridges SQL technique with storytelling intelligence, delivering recommendations grounded in both numbers and narrative.


PS: This is one of my initial SQL projects, and while I’ve aimed for clarity and depth, there may be areas for improvement in structure, or interpretation. I'm continuously learning and open to feedback that can help me refine my approach and grow as an analyst.




















