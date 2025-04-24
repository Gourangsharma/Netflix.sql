--6. Find content added in the last 5 years

select
*
from netflix
Where TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select *
from(
select *, unnest(string_to_array(director,',')) director_name
from netflix
)
where director_name = 'Rajiv Chilaka';

select *
from netflix
where director like '%Rajiv Chilaka%';


-- 8. List all TV shows with more than 5 seasons

select *
from netflix
where type='TV Show'
   and
      split_part(duration,' ',1)::int>5;


-- 9. Count the number of content items in each genre

select trim(unnest(string_to_array(listed_in,','))) as Genre,count(show_id) as Number_of_content
from netflix
group by 1
order by 2 desc;


-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !

select extract (year from to_date(date_added,'Month DD, YYYY')) on_netflix,
       count(*) total_content,
	   round(count(*)::numeric/(select count(*) from netflix where country='India')::numeric *100,2) as avg_content
from netflix
where country ='India'
group by 1
order by 3 desc
limit 5;
	   