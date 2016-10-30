-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- If tournament database exists, drop it
DROP DATABASE IF EXISTS tournament;

-- Create the tournament databases
CREATE DATABASE tournament;

\c tournament

CREATE TABLE t_players (
    player_id serial PRIMARY KEY,
    name text 
);

CREATE TABLE t_matches (
    winner_id int references t_players(player_id),
    loser_id int references t_players(player_id),
    PRIMARY KEY (winner_id, loser_id)
);

CREATE OR REPLACE VIEW standings AS
SELECT player_id, name, wins, matches FROM 
(SELECT p.player_id, p.name, CAST(COALESCE(count(m.*), 0) AS INT) AS matches 
    FROM t_players p LEFT JOIN t_matches m
    ON p.player_id = m.winner_id OR p.player_id = m.loser_id 
    GROUP BY p.player_id) AS sub_query_one
JOIN
(SELECT p.player_id, CAST(coalesce(count(m.winner_id),0) AS INT) AS wins from t_players p LEFT JOIN t_matches m on
(p.player_id = m.winner_id) group by p.player_id) 
AS sub_query_two 
USING (player_id)

