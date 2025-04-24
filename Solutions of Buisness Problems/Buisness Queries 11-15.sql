-- 11. List all movies that are documentaries

select *
from netflix
where type='Movie'
   and
     listed_in like '%Documentaries%';


-- 12. Find all content without a director

select *
from netflix
where director is null;


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select *
from netflix
where casts ilike '%Salman Khan%'
    and
	  release_year > extract(year from current_date) - 10;


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select trim(unnest(string_to_array(casts,','))) as actor,count(*) as Number_of_movies
from netflix
where country like '%India%'
group by 1
order by 2 desc
limit 10;


/*
Question 15:
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/

select label,type,count(*) as Content_count
from
(select *,
case
when description like '%kill%' or description like '%violence%' then 'Bad'
else 'Good'
end as label
from netflix) as s
group by 1,2
order by 2;

     



