/*
The W3Schools Try-SQL editor uses WebSQL, where a database is created on the client-side
browser. Browsers implement WebSQL with an SQLite DB engine. Therefore, the below syntax 
is written for the SQLite DB engine.

HOWEVER, WEBSQL HAS BEEN DEPRECATED AND IS NOT LONGER SUPPORTED ON CHROMIUM BROWSERS. THEREFORE, 
THE W3SCHOOLS TRY SQL EDITOR AT https://www.w3schools.com/sql/trysql.asp?filename=trysql_select_columns
ONLY SUPPORTS READONLY OPERATIONS. Therefore, the table creation and insertion commands required 3.1 cannot be run 
at the provided link

References - 
https://www.w3.org/TR/webdatabase/
https://developer.chrome.com/blog/deprecating-web-sql
https://www.reddit.com/r/SQL/comments/hdn8aa/what_database_system_does_the_online_w3schools/
https://w3schools.invisionzone.com/topic/63619-the-sql-tryit-editor-no-longer-works-for-write-operations-on-chrome-or-edge/


Instead, the Online SQL compiler at https://www.programiz.com/sql/online-compiler/ can be used, which provides a SQLite DB 
backend without being reliant on WebSQL. So, the below script can be run at that location. 


Assumptions and Conventions: 
- Only primary keys are given non-null constraints since constraints have not been specified in the question
- Non composite primary keys are specified as column level constraints
- id columns are provided explicitly in inserts, not using auto-increment
- Foreign key constraints specify RESTRICT on delete
- Datetime inputs are inserted directly without additional parsing
*/
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS group1;
DROP TABLE IF EXISTS groupMembership;

CREATE TABLE user (
    id int PRIMARY KEY,   -- implicit non-null for integer PKs on sqlite
    firstname varchar(255),  -- SQLite ignores specified sizes, but is included here.
    lastname varchar(255),
    email varchar(255),
    cultureID int,
    deleted bit,
    country varchar(255),
    isRevokeAccess bit,
    created datetime
);

BEGIN TRANSACTION;

INSERT INTO user 
VALUES (1, 'Victor', 'Shevchenko', 'vs@gmail.com', 1033, 1, 'US', 0, '2011-04-05'),
       (2, 'Oleksandr', 'Petrenko', 'op@gmail.com', 1034, 0, 'UA', 0, '2014-05-01'),
       (3, 'Victor', 'Tarasenko', 'vt@gmail.com', 1033, 1, 'US', 1, '2015-07-03'),
       (4, 'Sergiy', 'Ivaneko', 'sergiy@gmail.com', 1046, 0, 'UA', 1, '2010-02-02'),
       (5, 'Vitalii', 'Danilchenko', 'shumko@gmail.com', 1031, 0, 'UA', 1, '2014-05-01'),
       (6, 'Joe', 'Dou', 'joe@gmail.com', 1032, 0, 'US', 1, '2009-01-01'),
       (7, 'Marko', 'Polo', 'marko@gmail.com', 1033, 1, 'UA', 1, '2015-07-03');

-- Committing insert to the db
COMMIT; 

CREATE TABLE group1 (
    id int PRIMARY KEY, 
    name varchar(255),
    created datetime
);

BEGIN TRANSACTION;

INSERT INTO group1
VALUES (10, 'Support', '2010-02-02'),
       (12, 'Dev team', '2010-02-03'),
       (13, 'Apps team', '2011-05-06'),
       (14, 'TEST - dev team', '2013-05-06'),
       (15, 'Guest', '2014-02-02'),
       (16, 'TEST-QA-team', '2014-02-02'),
       (17, 'TEST-team', '2011-01-07');

COMMIT;

/*
Not null and unqiue constraints added to userID and groupID which logically form
a composite primary key
*/
CREATE TABLE groupMembership (
    id int PRIMARY KEY,
    userID int NOT NULL,
    groupID int NOT NULL,
    created datetime,
    UNIQUE(userID, groupID),
    FOREIGN KEY (userID) 
        REFERENCES user (id)
            ON DELETE RESTRICT,
    FOREIGN KEY (groupID)
        REFERENCES group1 (id)
            ON DELETE RESTRICT
);

BEGIN TRANSACTION;

INSERT INTO groupMembership
VALUES (110, 2, 10, '2010-02-02'),
       (112, 3, 15, '2010-02-03'),
       (114, 1, 10, '2014-02-02'), 
       (115, 1, 17, '2011-05-02'),
       (117, 4, 12, '2014-07-13'),
       (120, 5, 15, '2014-06-15');

COMMIT;


-- 3.2
-- Empty test groups
-- Please note that the group with ID 14, 'TEST - dev team' has a whitespace after TEST whereas the question 
-- requirement states that test groups start with 'TEST-'. Therefore, group 14 is not considered a test table.
SELECT name FROM group1
WHERE name LIKE 'TEST-%' AND id NOT IN (
    SELECT groupID FROM groupMembership
);

-- 3.3
-- Users with firstname as Victor who are not members of any test groups
SELECT firstname, lastname FROM user
WHERE firstname = 'Victor' AND id NOT IN (
  SELECT gm.userID FROM groupMembership as gm 
  JOIN group1 g ON g.id = gm.groupID
  WHERE g.name LIKE 'TEST-%'
);


-- 3.4
-- Users and groups for which the user was created before the group
SELECT g.id as groupId , g.name, u.id as userId, u.firstname, u.lastname, u.created as uCreated, g.created as groupCreated FROM group1 as g
JOIN groupMembership gm ON g.id = gm.groupID
JOIN user u ON u.id = gm.userID
WHERE u.created < g.created
