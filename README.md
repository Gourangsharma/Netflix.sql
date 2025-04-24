# Netflix Movies and TV Shows Data Analysis using SQL
![Netflix_logo](https://github.com/Gourangsharma/Netflix.sql/blob/main/BrandAssets_Logos_02-NSymbol.jpg)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives
- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Databse setup and Analysis
```sql
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(50),
    description  VARCHAR(550)
);

select * from netflix;

select count(*) from netflix;

select distinct type from netflix;

select count(show_id) from netflix;
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows
```sql
SELECT 
    type, COUNT(show_id) AS Number_of_shows
FROM
    netflix
GROUP BY type;
```

### 2. Find the Most Common Rating for Movies and TV Shows
```sql
SELECT type,rating,common_rating
FROM

(SELECT type,rating,count(rating) AS common_rating,

RANK() over (partition by type order by count(rating) desc) AS rn

FROM netflix

GROUP BY  type,rating) AS s

WHERE rn =1;
```

### 3. List All Movies Released in a Specific Year (e.g., 2020)
```sql
SELECT 
    title AS Movies
FROM
    netflix
WHERE
    type = 'Movie' AND release_year = 2020;
```

### 4. Find the Top 5 Countries with the Most Content on Netflix
```sql
SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) Country,
    COUNT(show_id) AS Number_of_content
FROM
    netflix
WHERE
    country IS NOT NULL
GROUP BY 1
ORDER BY Number_of_content DESC
LIMIT 5;
```

### 5. Identify the Longest Movie
```sql
SELECT 
    title, duration
FROM
    netflix
WHERE
    type = 'Movie' AND duration IS NOT NULL
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;
```

### 6. Find Content Added in the Last 5 Years
```sql
SELECT
*
FROM netflix

WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
SELECT 
    *
FROM
    (SELECT 
        *, UNNEST(STRING_TO_ARRAY(director, ',')) director_name
    FROM
        netflix)
WHERE
    director_name = 'Rajiv Chilaka';

SELECT 
    *
FROM
    netflix
WHERE
    director LIKE '%Rajiv Chilaka%';
```

### 8. List All TV Shows with More Than 5 Seasons
```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```

### 9. Count the Number of Content Items in Each Genre
```sql
SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS Genre,
    COUNT(show_id) AS Number_of_content
FROM
    netflix
GROUP BY 1
ORDER BY 2 DESC;
```

### 10.Find each year and the average numbers of content release in India on netflix.
return top 5 year with highest avg content release!
```sql
SELECT 
EXTRACT (year FROM to_date(date_added,'Month DD, YYYY')) on_netflix,
       COUNT(*) total_content,
	   ROUND(COUNT(*)::numeric/(SELECT count(*) FROM netflix WHERE country='India')::NUMERIC *100,2) AS avg_content
FROM netflix
WHERE country ='India'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5;
```

### 11. List All Movies that are Documentaries
```sql
SELECT 
    *
FROM
    netflix
WHERE
    type = 'Movie'
        AND listed_in LIKE '%Documentaries%';
```

### 12. Find All Content Without a Director
```sql
SELECT 
    *
FROM
    netflix
WHERE
    director IS NULL;
```

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
```sql
SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS actor,
    COUNT(*) AS Number_of_movies
FROM
    netflix
WHERE
    country LIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
```sql
SELECT 
    label, type, COUNT(*) AS Content_count
FROM
    (SELECT 
        *,
            CASE
                WHEN
                    description LIKE '%kill%'
                        OR description LIKE '%violence%'
                THEN
                    'Bad'
                ELSE 'Good'
            END AS label
    FROM
        netflix) AS s
GROUP BY 1 , 2
ORDER BY 2;
```

## Findings and Conclusion
- Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
- Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
- Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
- This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

## Author - Gourang Sharma
This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles.

### Thank You
