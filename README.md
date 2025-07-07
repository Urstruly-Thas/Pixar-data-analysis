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
```







































