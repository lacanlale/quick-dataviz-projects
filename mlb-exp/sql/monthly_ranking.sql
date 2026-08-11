--Caputres monthly ranking per team based on total wins

WITH
PerMonthTotal AS (
	SELECT
		season,
		MONTH(CONVERT([date], DATE)) AS [Month],
		wteam,
		COUNT(*) wins
	FROM gameinfo 
	WHERE gametype = 'regular'
	GROUP BY
		season,
		MONTH(CONVERT([date], DATE)),
		wteam
),
RunningTotal AS (
	SELECT
		season,
		[Month],
		wteam,
		wins AS WinsInMonth,
		SUM(wins) OVER(
			PARTITION BY season, wteam
			ORDER BY [Month] ASC
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
		) AS RunningTotal
	FROM PerMonthTotal
)

SELECT
	*,
	DENSE_RANK() OVER(
		PARTITION BY season, [Month]
		ORDER BY 
			[Month] ASC,
			RunningTotal DESC
	) AS Ranking
FROM RunningTotal;
