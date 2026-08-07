--allplayers.csv - contains basic information about all players divided by team-season
select * from allplayers limit 1000;

--batting.csv - batting statistics by player by game
select * from batting limit 1000;

--fielding.csv - fielding statistics by player by position by game
select * from fielding limit 1000;

--gameinfo.csv - contains game-level information such as teams, attendance, umpires, etc.
select * from gameinfo  limit 1000;

--pitching.csv - pitching statistics by player by game
select * from pitching limit 1000;

--plays.csv - parsed play-by-play data for all games for which Retrosheet has play-by-play data (including deduced event files)
select * from plays limit 1000;

--teamstats.csv - contains team-level statistics - line scores, lineups, and team statistics (batting, pitching, fielding)
select * from teamstats limit 1000;