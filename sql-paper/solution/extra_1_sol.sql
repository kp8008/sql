-- 1. Players Table
CREATE TABLE Players (
player_id INT PRIMARY KEY Identity(1,1),
player_name VARCHAR(100) NOT NULL,
country VARCHAR(50) NOT NULL,
date_of_birth DATE,
role VARCHAR(20) NOT NULL 
    CHECK (role IN ('Batsman', 'Bowler', 'All-rounder', 'Wicket-keeper')),
baƫng_style VARCHAR(50),
bowling_style VARCHAR(50),
debut_year INT
);
truncate table Players

-- 2. Formats Table
CREATE TABLE Formats (
format_id INT PRIMARY KEY Identity(1,1),
format_name VARCHAR(20) NOT NULL UNIQUE,
overs_per_innings INT,
descripƟon VARCHAR(200)
);

-- 3. Baƫng_StaƟsƟcs Table
CREATE TABLE Batting_Statistics (
batting_statistics_id INT PRIMARY KEY Identity(1,1),
player_id INT NOT NULL,
format_id INT NOT NULL,
innings INT DEFAULT 0,
runs_scored INT DEFAULT 0,
centuries INT DEFAULT 0,
batting_average DECIMAL(6,2),
strike_rate DECIMAL(6,2),
FOREIGN KEY (player_id) REFERENCES Players(player_id),
FOREIGN KEY (format_id) REFERENCES Formats(format_id)
);

-- 4. Bowling_StaƟsƟcs Table
CREATE TABLE Bowling_Statistics (
bowling_statistics_id INT PRIMARY KEY Identity(1,1),
player_id INT NOT NULL,
format_id INT NOT NULL,
matches_played INT DEFAULT 0,
wickets_taken INT DEFAULT 0,
best_bowling VARCHAR(10),
five_wicket_hauls INT DEFAULT 0,
economy_rate DECIMAL(5,2),
FOREIGN KEY (player_id) REFERENCES Players(player_id),
FOREIGN KEY (format_id) REFERENCES Formats(format_id)
);


 -- Insert 7 Players 
INSERT INTO Players (player_name, country, date_of_birth, role,  baƫng_style, bowling_style, debut_year) VALUES 
('Virat Kohli', 'India', '1988-11-05', 'Batsman', 'Right-hand bat', 'Right-arm medium', 2008), 
('Jasprit Bumrah', 'India', '1993-12-06', 'Bowler', 'Right-hand bat', 'Right-arm fast', 2016), 
('Steve Smith', 'Australia', '1989-06-02', 'Batsman', 'Right-hand bat', 'Leg break', 2010), 
('Pat Cummins', 'Australia', '1993-05-08', 'All-rounder', 'Right-hand bat', 'Right-arm fast', 2011), 
('Joe Root', 'England', '1990-12-30', 'Batsman', 'Right-hand bat', 'Right-arm off break', 2012), 
('Shaheen Afridi', 'Pakistan', '2000-04-06', 'Bowler', 'Le-hand bat', 'Le-arm fast', 2018), 
('Babar Azam', 'Pakistan', '1994-10-15', 'Batsman', 'Right-hand bat', 'Right-arm off break', 2015); -- I

-- Insert 7 Formats (Only 3 main formats, but adding 4 more varia ons) 
INSERT INTO Formats (format_name, overs_per_innings, descripƟon) VALUES 
('Test', NULL, 'Mul-day format with unlimited overs'), 
('ODI', 50, 'One Day Interna onal - 50 overs per side'), 
('T20', 20, 'Twenty20 - 20 overs per side'), 
('T10', 10, 'Ten10 - 10 overs per side'), 
('The Hundred', NULL, '100 balls per side format'), 
('List A', 50, 'Limited overs domes c cricket'), 
('First Class', NULL, 'Mul-day domes c cricket format');

-- Insert 7 Ba ng Sta s cs Records 
INSERT INTO Batting_Statistics (player_id, format_id, innings, runs_scored, centuries, batting_average, strike_rate) VALUES 
(1, 1, 196, 8848, 29, 47.55, 58.07),  -- Virat Kohli Test 
(1, 2, 283, 13906, 50, 59.18, 93.42), -- Virat Kohli ODI 
(3, 1, 196, 9685, 32, 56.97, 54.26),  -- Steve Smith Test 
(5, 1, 272, 12377, 34, 50.10, 51.82), -- Joe Root Test 
(7, 2, 125, 5729, 19, 56.72, 89.23),  -- Babar Azam ODI 
(4, 2, 89, 1747, 1, 29.78, 88.56),    -- Pat Cummins ODI 
(1, 3, 117, 4188, 1, 52.73, 138.43);  -- Virat Kohli T20 

-- Insert 7 Bowling Sta s cs Records 
INSERT INTO  Bowling_Statistics (player_id, format_id, matches_played, wickets_taken, best_bowling, five_wicket_hauls, 
economy_rate) VALUES 
(2, 1, 36, 159, '6/27', 11, 2.42),  -- Jasprit Bumrah Test 
(2, 2, 89, 149, '6/19', 5, 5.08),   -- Jasprit Bumrah ODI 
(2, 3, 70, 89, '3/7', 0, 7.36),     -- Jasprit Bumrah T20 
(4, 1, 60, 269, '6/23', 14, 2.56),  -- Pat Cummins Test 
(4, 2, 95, 171, '5/70', 2, 5.17),   -- Pat Cummins ODI 
(6, 1, 31, 122, '6/51', 6, 2.71),   -- Shaheen Afridi Test 
(6, 2, 57, 97, '6/35', 3, 5.73);    -- Shaheen Afridi ODI 

--1. Get bowling sta s cs of Pat Cummins in all formats 
SELECT p.player_name, f.format_name, b.*
FROM Bowling_Statistics b
JOIN Players p ON b.player_id = p.player_id
JOIN Formats f ON b.format_id = f.format_id
WHERE p.player_name = 'Pat Cummins';

--2. Count how many players belong to each country
SELECT Country,COUNT(*)
FROM Players 
group by Country

--3. Show top 5 highest strike rates in T20 format 
SELECT TOP 5 p.player_name, b.strike_rate
FROM Batting_Statistics b
JOIN Players p ON b.player_id = p.player_id
WHERE b.format_id = 3   
ORDER BY b.strike_rate DESC

--4. Show bowlers with economy < 3 in Test format
SELECT p.player_name, b.economy_rate
FROM Bowling_Statistics b
JOIN Players p ON b.player_id = p.player_id
WHERE b.format_id = 1       
  AND b.economy_rate < 3;

--5. List players who play as All-rounders and have both >1000 runs and >50 wickets 
SELECT p.player_name,
       SUM(b.runs_scored) AS total_runs,
       SUM(w.wickets_taken) AS total_wickets
FROM Players p
JOIN Batting_Statistics b ON p.player_id = b.player_id
JOIN Bowling_Statistics w ON p.player_id = w.player_id
WHERE p.role = 'All-rounder'
GROUP BY p.player_name
HAVING SUM(b.runs_scored) > 1000
   AND SUM(w.wickets_taken) > 50;


--6. Show average ba ng strike rate for each format 
SELECT f.format_name, AVG(b.strike_rate) AS avg_strike_rate
FROM Batting_Statistics b
JOIN Formats f ON b.format_id = f.format_id
GROUP BY f.format_name;

--7. List top 3 bowlers with most 5-wicket hauls
SELECT TOP 3 p.player_name, SUM(b.five_wicket_hauls) AS total_5w
FROM Bowling_Statistics b
JOIN Players p ON b.player_id = p.player_id
GROUP BY p.player_name
ORDER BY total_5w DESC

--8. Find the youngest player in the database.
SELECT TOP 1 player_name, date_of_birth
FROM Players
ORDER BY date_of_birth DESC;


--9. Show players who have never scored a century in any format.
SELECT p.player_name
FROM Players p
WHERE p.player_id NOT IN (
    SELECT player_id FROM Batting_Statistics WHERE centuries > 0
);

--10. Display the player name who has the lowest bowling economy in ODI.
SELECT p.player_name, b.economy_rate
FROM Bowling_Statistics b
JOIN Players p ON b.player_id = p.player_id
WHERE b.format_id = 2      
ORDER BY b.economy_rate ASC;

--11. Find players from India with their total runs across all formats 
SELECT p.player_name, SUM(b.runs_scored) AS total_runs
FROM Players p
JOIN Batting_Statistics b ON p.player_id = b.player_id
WHERE p.country = 'India'
GROUP BY p.player_name;

--12. Find the player who has scored the highest runs in ODI format (using subquery).
SELECT p.player_name
FROM Players p
JOIN Batting_Statistics b ON p.player_id = b.player_id
WHERE b.format_id = 2  
  AND b.runs_scored = (
      SELECT MAX(runs_scored) FROM Batting_Statistics WHERE format_id = 2
  );


--13. List all players whose ba ng average is above the overall average of all players.
SELECT p.player_name
FROM Players p
JOIN Batting_Statistics b ON p.player_id = b.player_id
WHERE b.batting_average >
(
    SELECT AVG(batting_average) FROM Batting_Statistics
);

--14. Find formats where more than 1 player has scored 5000+ runs.
SELECT f.format_name
FROM Batting_Statistics b
JOIN Formats f ON b.format_id = f.format_id
WHERE b.runs_scored >= 5000
GROUP BY f.format_name
HAVING COUNT(b.player_id) > 1;

--15. Show players who have NEVER scored a century in ANY format (only subqueries). 
SELECT player_name
FROM Players
WHERE player_id NOT IN (
    SELECT player_id
    FROM Batting_Statistics
    WHERE centuries > 0
);

