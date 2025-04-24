--1. Count the number of Movies vs TV Shows

select type,count(show_id) as Number_of_shows
from netflix
group by type;

--2. Find the most common rating for movies and TV shows

select type,rating,common_rating
from
(select type,rating,count(rating) as common_rating,
rank() over (partition by type order by count(rating) desc) as rn
from netflix
group by type,rating) as s
where rn =1;


--3. List all movies released in a specific year (e.g., 2020)

select title as Movies
from netflix
where 
type='Movie'
and
release_year=2020;


-- 4. Find the top 5 countries with the most content on Netflix

select  trim(unnest(string_to_array(country,','))) Country,count(show_id) as Number_of_content
from netflix
where country is not null
group by 1
order by Number_of_content desc
limit 5;

-- 5. Identify the longest movie

select title,duration
from netflix
where type='Movie'
   and
      duration is not null
order by split_part(duration,' ',1)::int desc;



