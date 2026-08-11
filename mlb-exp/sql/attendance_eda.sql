SELECT 
	season,
	team,
	CumulTotal,
	AvgTotal,
	MinTotal,
	MaxTotal,
	RANK() OVER(
		PARTITION BY 
			Season,
			Team
		ORDER BY AvgTotal
	) HighestAvgAttendance
FROM (
	SELECT 
		season,
		hometeam AS team,
		SUM(attendance) CumulTotal,
		AVG(attendance) AvgTotal,
		MIN(attendance) MinTotal,
		MAX(attendance) MaxTotal,
		'Home' AS Loc
	FROM gameinfo
	WHERE gametype = 'regular'
	GROUP BY 
		season,
		hometeam
	UNION ALL
	SELECT 
		season,
		visteam AS team,
		SUM(attendance) CumulTotal,
		AVG(attendance) AvgTotal,
		MIN(attendance) MinTotal,
		MAX(attendance) MaxTotal,
		'Visiting' AS Loc
	FROM gameinfo
	WHERE gametype = 'regular'
	GROUP BY 
		season,
		visteam
) sub;