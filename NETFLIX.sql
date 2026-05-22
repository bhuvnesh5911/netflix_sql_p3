 DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id VARCHAR(6),
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(208),
    casts  VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(250)
);

SELECT * FROM netflix

SELECT 
  DISTINCT type 
 FROM netflix;

-- 1 list all the movies realeased in a specific year eg(2020) 

SELECT * FROM netflix
WHERE type = 'Movie' AND release_year = 2020

-- 2 find the top 5 country with the most netflix content 
SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- 3 find out longest movies 
SELECT * FROM netflix
WHERE type = 'Movie' 
	  AND
	  duration = (SELECT MAX(duration) FROM netflix) 

-- 4 find the content added in last five years 
 SELECT * FROM netflix
 WHERE
 		TO_DATE(date_added, 'Month DD, YYYYY') >= CURRENT_DATE - INTERVAL '5 years'

-- 5 find the all movies/TV shows directed by 'rajiv chilaka'
SELECT * FROM netflix
WHERE  director ILIKE '%Rajiv Chilaka%' -- LIKE use to find any charactor of the query use - single chracter % for any character 
--ILIKE for case sensitive

-- 6 list all TV shows has more than 5 seasons 
SELECT
  *
FROM netflix
WHERE
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::numeric > 5

-- 7 count the number of content in each genre 
SELECT 
   UNNEST(STRING_TO_ARRAY(listed_in, ',')) as new_genre,
    COUNT(show_id) as total_count
FROM netflix
GROUP BY 1

-- 8 find each year and the average numbers of content realease by indian on netflix return top 5 
-- year with the highest avg content release 

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100  
	 ,2)as avg_year 
FROM netflix 
WHERE country = 'India'
GROUP BY 1

-- 9 list all the movies ara the documentaries 
SELECT * FROM netflix
	WHERE 
		listed_in ILIKE '%documentaries%'

-- 10 find all content without director

SELECT * FROM netflix
WHERE director IS NULL

-- 11 find how many movies actor 'salman khan' appeared last 5 years 

SELECT * FROM netflix
WHERE
	casts ILIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


-- 12 find the top 10 actors who have appeared in the highest number of movies produced in India

SELECT 
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%%india'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 13 categorize the content based on the presence of the keywords 'kill' and 'violence' in
-- the description field . label content contanining these keywords as 'bad' and all other
-- content as 'good' count how many items fall into each category 
WITH new_table
AS
(
SELECT 
*,
CASE 
WHEN
	description ILIKE '%kill%' OR
	description ILIKE '%violence%' THEN 'bad content'
	ELSE 'good content'
END category
FROM netflix
)
SELECT 
 category,
 COUNT(*) as new_content 
 FROM new_table
 GROUP BY 1








