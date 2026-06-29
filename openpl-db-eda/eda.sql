-- SELECT 
-- 	federation,
-- 	COUNT(*)
-- FROM usa_athletes ath
-- LEFT JOIN federations fed ON fed.federation_id = ath.federation_id
-- GROUP BY 1
-- ORDER BY 2 DESC;

SELECT
	DATE_PART('YEAR', meet_date) AS "Year",
	COUNT(*) AS "Number of Meets",
	TRUNC(AVG(COUNT(*))
         OVER(ORDER BY DATE_PART('YEAR', meet_date) ASC ROWS BETWEEN 5 PRECEDING AND CURRENT ROW), 2)
         AS "Moving Average"
FROM meets
GROUP BY 1
ORDER BY 1;