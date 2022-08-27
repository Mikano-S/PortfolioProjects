/*
NBA Games Data Exploration. 

In this project, I will be analyzing what are the most important factors for winning NBA games. The factors of interest are 
field goal percentage (FG%), free throw percentage (FT%), three-point percentage (3P%), total rebounds (TRB), and assists (AST). 
These statistics will be analyzed to see what is the greatest predictor of winning games. The results of this project 
can provide evidence as to what NBA teams should focus on in order to maximize their team's success and win as many games as possible.
 
Skills Used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, 
 */
 
 -- Selecting the data I am going to to be working with. --
 
SELECT * FROM games;
SELECT * FROM teams;
SELECT * FROM teams2;

-- Relationship b/n field goal percentage and winning. --
-- Shows likelihood of winning the game if you shot better from the field than your opponent. --

SELECT (SUM(HOME_TEAM_WINS)/COUNT(HOME_TEAM_WINS))*100 AS "Home_Team_Win%" 
FROM games
WHERE FG_PCT_home > FG_PCT_away

-- Relationship b/n free throw percentage and winning. --
-- Shows likelihood of winning the game if you shot better from the free throw line than your opponent. --

SELECT (SUM(HOME_TEAM_WINS)/COUNT(HOME_TEAM_WINS))*100 AS "Home_Team_Win%" 
FROM games
WHERE FT_PCT_home > FT_PCT_away

-- Relationship b/n three-point percentage and winning. --
-- Shows likelihood of winning the game if you shot better from the three-point line than your opponent. --

SELECT (SUM(HOME_TEAM_WINS)/COUNT(HOME_TEAM_WINS))*100 AS "Home_Team_Win%" 
FROM games
WHERE FG3_PCT_home > FG3_PCT_away

-- Relationship b/n rebounding and winning. --
-- Shows likelihood of winning the game if you outrebounded your opponent. --

SELECT (SUM(HOME_TEAM_WINS)/COUNT(HOME_TEAM_WINS))*100 AS "Home_Team_Win%" 
FROM games
WHERE REB_home > REB_away

-- Relationship b/n assists and winning. --
-- Shows likelihood of winning the game if you had more assists than your opponent. --

SELECT (SUM(HOME_TEAM_WINS)/COUNT(HOME_TEAM_WINS))*100 AS "Home_Team_Win%" 
FROM games
WHERE AST_home > AST_away



-- Now I will compare the impact of these stats over the past 19 seasons (2003-2021).

-- From 2003-2021, the team that shot better from the field won ~85% of the time. --

SELECT SEASON, (SUM(HOME_TEAM_WINS)/COUNT(HOME_TEAM_WINS))*100 AS "Home_Team_Win%" 
FROM games
WHERE FG_PCT_home > FG_PCT_away
GROUP BY SEASON
ORDER BY SEASON DESC

-- From 2003-2021, the team that shot better from the free throw line won ~64% of the time. --

SELECT SEASON, (SUM(HOME_TEAM_WINS)/COUNT(HOME_TEAM_WINS))*100 AS "Home_Team_Win%" 
FROM games
WHERE FT_PCT_home > FT_PCT_away
GROUP BY SEASON
ORDER BY SEASON DESC

-- From 2003-2021, the team that shot better from the three-point line  won ~77% of the time. --

SELECT SEASON, (SUM(HOME_TEAM_WINS)/COUNT(HOME_TEAM_WINS))*100 AS "Home_Team_Win%" 
FROM games
WHERE FG3_PCT_home > FG3_PCT_away
GROUP BY SEASON
ORDER BY SEASON DESC

-- From 2003-2021, the team that outrebounded their opponent won ~73% of the time. --

SELECT SEASON, (SUM(HOME_TEAM_WINS)/COUNT(HOME_TEAM_WINS))*100 AS "Home_Team_Win%" 
FROM games
WHERE REB_home > REB_away
GROUP BY SEASON
ORDER BY SEASON DESC

-- From 2003-2021, the team that had more assists won ~76% of the time. --

SELECT SEASON, (SUM(HOME_TEAM_WINS)/COUNT(HOME_TEAM_WINS))*100 AS "Home_Team_Win%" 
FROM games
WHERE AST_home > AST_away
GROUP BY SEASON
ORDER BY SEASON DESC


-- Since FG% is the strongest predictor of winning games, I wanted to track each team's total home victories and whether or not they had a -- 
-- higher field goal percentage than their opponent for an entire season. I chose the 2020-2021 season, since that was the most recent --
-- season with data available for every regular season game (excluding pre-season and post-season games). --


SELECT
	GAME_DATE_EST AS "DateOfGame",
	GAME_ID AS "GameID",
    games.HOME_TEAM_ID AS "HomeTeamID",
    teams.ABBREVIATION AS "Home Team",
    games.FG_PCT_home AS "FGPctHome",
    games.VISITOR_TEAM_ID AS "AwayTeamID",
    teams2.ABBREVIATIONS AS "Away Team",
    games.FG_PCT_away*100 AS "FGPctAway",
	SEASON AS "Season",
    HOME_TEAM_WINS AS "DoesHomeTeamWin",
	SUM(HOME_TEAM_WINS) OVER (PARTITION BY HOME_TEAM_ID ORDER BY GAME_DATE_EST, HOME_TEAM_ID) AS "RollingTotalWinsHome"
FROM games
LEFT JOIN teams ON games.HOME_TEAM_ID = teams.TEAM_ID
LEFT JOIN teams2 ON games.VISITOR_TEAM_ID = teams2.TEAM_ID
WHERE SEASON = 2020 AND (GAME_DATE_EST NOT BETWEEN "2020-12-03" AND "2020-12-21") AND (GAME_DATE_EST NOT BETWEEN "2021-05-17" AND "2021-07-20")
GROUP BY GAME_ID
;



-- Here, I am using a CTE to compare the difference in field-goal percentage between a home team and their opponent (which I'll refer to as 
-- field-goal percentage differential) and a team's home-win streak/record (created via the partition by in the previous query).

WITH HomeWinsDuringSeason 
(
	GAME_DATE_EST,
	GAME_ID,
	HOME_TEAM_ID,
	ABBREVIATION,
    FG_PCT_home,
    VISITOR_TEAM_ID,
    ABBREVIATIONS,
    FG_PCT_away,
	SEASON,
    HOME_TEAM_WINS,
	RollingTeamWinsHome
)
AS
(
SELECT
	games.GAME_DATE_EST,
    games.GAME_ID,
    games.HOME_TEAM_ID,
    teams.ABBREVIATION,
    games.FG_PCT_home,
    games.VISITOR_TEAM_ID,
    teams2.ABBREVIATIONS,
    games.FG_PCT_away,
	games.SEASON,
    games.HOME_TEAM_WINS,
	SUM(HOME_TEAM_WINS) OVER (PARTITION BY HOME_TEAM_ID ORDER BY GAME_DATE_EST, HOME_TEAM_ID)
FROM games
LEFT JOIN teams ON games.HOME_TEAM_ID = teams.TEAM_ID
LEFT JOIN teams2 ON games.VISITOR_TEAM_ID = teams2.TEAM_ID
WHERE SEASON = 2020 AND (GAME_DATE_EST NOT BETWEEN "2020-12-03" AND "2020-12-21") AND (GAME_DATE_EST NOT BETWEEN "2021-05-17" AND "2021-07-20")
)
SELECT *, (TRUNCATE(FG_PCT_home - FG_PCT_away, 3)) AS "FGPcntDifferential"
FROM HomeWinsDuringSeason
GROUP BY GAME_ID
;



-- Here, I am using a temp table to compare the field-goal percentage differential to a team's home record. -- 

DROP TABLE if exists HomeRecords
;
CREATE TEMPORARY TABLE HomeRecords
(
GAME_DATE_EST datetime,
GAME_ID numeric,
HOME_TEAM_ID numeric,
ABBREVIATION nvarchar(255),
FG_PCT_home float,
VISITOR_TEAM_ID numeric,
ABBREVIATIONS nvarchar(255),
FG_PCT_away float,
SEASON numeric,
HOME_TEAM_WINS numeric,
RollingTotalWinsHome numeric
)
;

INSERT INTO HomeRecords
SELECT
	GAME_DATE_EST,
    GAME_ID,
    HOME_TEAM_ID,
    ABBREVIATION,
    FG_PCT_home,
    VISITOR_TEAM_ID,
    ABBREVIATIONS,
    FG_PCT_away,
    SEASON,
    HOME_TEAM_WINS,
    SUM(HOME_TEAM_WINS) OVER (PARTITION BY HOME_TEAM_ID ORDER BY GAME_DATE_EST, HOME_TEAM_ID) AS RollingTotalWinsHome
FROM games
LEFT JOIN teams ON games.HOME_TEAM_ID = teams.TEAM_ID
LEFT JOIN teams2 ON games.VISITOR_TEAM_ID = teams2.TEAM_ID
WHERE SEASON = 2020 AND (GAME_DATE_EST NOT BETWEEN "2020-12-03" AND "2020-12-21") AND (GAME_DATE_EST NOT BETWEEN "2021-05-17" AND "2021-07-20")
GROUP BY GAME_ID
;
SELECT *, ((TRUNCATE(FG_PCT_home - FG_PCT_away, 3))) AS "FGPcntDifferential"
FROM HomeRecords



-- Creating various views to store data for future visualizations. --

;
CREATE VIEW FGPcntWins AS
SELECT SEASON, (SUM(HOME_TEAM_WINS)/COUNT(HOME_TEAM_WINS))*100 AS "Home_Team_Win%" 
FROM games
WHERE FG_PCT_home > FG_PCT_away
GROUP BY SEASON
ORDER BY SEASON DESC
;

CREATE VIEW RevisedTotalHomeWins AS
SELECT GAME_DATE_EST, GAME_ID, HOME_TEAM_ID, ABBREVIATION, VISITOR_TEAM_ID, ABBREVIATIONS, SEASON, HOME_TEAM_WINS, SUM(HOME_TEAM_WINS) OVER (PARTITION BY HOME_TEAM_ID ORDER BY GAME_DATE_EST, HOME_TEAM_ID) AS RollingTotalWinsHome
FROM games
LEFT JOIN teams ON games.HOME_TEAM_ID = teams.TEAM_ID
LEFT JOIN teams2 ON games.VISITOR_TEAM_ID = teams2.TEAM_ID
WHERE SEASON = 2020 AND (GAME_DATE_EST NOT BETWEEN "2020-12-03" AND "2020-12-21") AND (GAME_DATE_EST NOT BETWEEN "2021-05-17" AND "2021-07-20")
GROUP BY GAME_ID
;

CREATE VIEW TotalHomeWinsAndFGPcnt AS
SELECT GAME_DATE_EST, GAME_ID, HOME_TEAM_ID, ABBREVIATION, FG_PCT_home, VISITOR_TEAM_ID, ABBREVIATIONS, FG_PCT_away, SEASON, HOME_TEAM_WINS, SUM(HOME_TEAM_WINS) OVER (PARTITION BY HOME_TEAM_ID ORDER BY GAME_DATE_EST, HOME_TEAM_ID) AS RollingTotalWinsHome
FROM games
LEFT JOIN teams ON games.HOME_TEAM_ID = teams.TEAM_ID
LEFT JOIN teams2 ON games.VISITOR_TEAM_ID = teams2.TEAM_ID
WHERE SEASON = 2020 AND (GAME_DATE_EST NOT BETWEEN "2020-12-03" AND "2020-12-21") AND (GAME_DATE_EST NOT BETWEEN "2021-05-17" AND "2021-07-20")
GROUP BY GAME_ID
;

CREATE VIEW AvgPtsScored AS
SELECT SEASON, HOME_TEAM_ID, ABBREVIATION, PTS_home, AVG(PTS_home) AS 'AvgPtsScored' 
FROM games
LEFT JOIN teams ON games.HOME_TEAM_ID = teams.TEAM_ID
LEFT JOIN teams2 ON games.VISITOR_TEAM_ID = teams2.TEAM_ID
GROUP BY SEASON, HOME_TEAM_ID
;

CREATE VIEW AvgPtsAllowed AS
SELECT SEASON, HOME_TEAM_ID, ABBREVIATION, PTS_away, AVG(PTS_away) AS 'AvgPtsAllowed' 
FROM games
LEFT JOIN teams ON games.HOME_TEAM_ID = teams.TEAM_ID
LEFT JOIN teams2 ON games.VISITOR_TEAM_ID = teams2.TEAM_ID
GROUP BY SEASON, HOME_TEAM_ID
;

CREATE VIEW AvgFGPct AS
SELECT SEASON, HOME_TEAM_ID, ABBREVIATION, FG_PCT_home, ROUND(AVG(FG_PCT_home * 100), 3) AS 'AvgFGPct' 
FROM games
LEFT JOIN teams ON games.HOME_TEAM_ID = teams.TEAM_ID
LEFT JOIN teams2 ON games.VISITOR_TEAM_ID = teams2.TEAM_ID
GROUP BY SEASON, HOME_TEAM_ID
;

CREATE VIEW PtDiff AS
SELECT DISTINCT SEASON, GAME_DATE_EST, GAME_ID, HOME_TEAM_ID, ABBREVIATION, PTS_home, PTS_away,
SUM(PTS_home), SUM(PTS_away), (((SUM(PTS_home))-(SUM(PTS_away)))/(COUNT(GAME_ID))) AS 'PtDiff'
FROM games
LEFT JOIN teams ON games.HOME_TEAM_ID = teams.TEAM_ID
LEFT JOIN teams2 ON games.VISITOR_TEAM_ID = teams2.TEAM_ID
GROUP BY SEASON, HOME_TEAM_ID
;

CREATE VIEW AvgPtsScoredWithLocation AS
SELECT SEASON, HOME_TEAM_ID, ABBREVIATION, PTS_home, AVG(PTS_home) AS 'AvgPtsScored' 
FROM games
-- LEFT JOIN teams ON games.HOME_TEAM_ID = teams.TEAM_ID
-- LEFT JOIN teams2 ON games.VISITOR_TEAM_ID = teams2.TEAM_ID
RIGHT OUTER JOIN teams ON games.HOME_TEAM_ID = teams.TEAM_ID
GROUP BY SEASON, HOME_TEAM_ID
;


