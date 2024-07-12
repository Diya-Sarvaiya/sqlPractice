--1. SQL Create DB: Learn how to create a new database.
CREATE DATABASE testDB;

--2. SQL Drop DB: Understand how to delete an existing database.
SELECT name FROM sys.databases;

--3. SQL Backup DB: Explore methods to backup your database.
backup database testDB
to disk='D:\database\testDB.bak';

--4. SQL Create Table: Learn how to create new tables in a database.
CREATE TABLE Persons (
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255)
);

CREATE TABLE TestTable AS
SELECT FirstName, City
FROM Persons;

--5. QL Drop Table: Understand how to delete tables from a database.
DROP TABLE test_table_1;

--6. SQL Alter Table: Learn how to modify existing tables.

-- alter datatype
ALTER TABLE Persons
ALTER COLUMN Email varchar(250);

-- add Email to persons
ALTER TABLE Persons
ADD Email varchar(255);

-- rename columns name
sp_rename 'Persons.Address',  'Add', 'COLUMN';

--7. SQL Constraints: Explore the various constraints that can be applied to tables.

--8. not null
ALTER TABLE Persons
ALTER COLUMN City varchar(50) NOT NULL;

--9. 10. unique key , primary key
CREATE TABLE Student (
	StdID int NOT NULL PRIMARY KEY,
    RollNo int NOT NULL UNIQUE,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int
);

--11. foreign key
ALTER TABLE Persons
ADD StdID int;

ALTER TABLE Persons
ADD FOREIGN KEY (StdID) REFERENCES Student(StdID);

-- drop foreign key
ALTER TABLE Persons
DROP CONSTRAINT FK__Persons__StdID__286302EC;

--12. SQL Not Null: Understand the NOT NULL constraint to ensure that a column cannot have a NULL value.
ALTER TABLE Persons
ADD CHECK (PersonID>=50);

--13. SQL Default: Understand how to use the DEFAULT keyword to set a default value for a column.
ALTER TABLE Persons
ADD CONSTRAINT df_City
DEFAULT 'Sandnes' FOR City;

--14. SQL Index: Learn how to create and use indexes to improve the performance of database queries.
CREATE INDEX idx_lastname
ON Persons (LastName);

CREATE INDEX idx_pname
ON Persons (LastName, FirstName);

DROP INDEX Persons.idx_pname;

--15. SQL Auto Increment: Explore theAUTO_INCREMENT attribute to automatically generate a unique number when a new record is inserted.
CREATE TABLE Student (
	StdID int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    RollNo int NOT NULL UNIQUE,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int
);

--16. Two dates can easily be compared if there is no time component involved!
-- To keep your queries simple and easy to maintain, do not use time-components in your dates, unless you have to!
-- column 2008-11-11 13:23:44
-- SELECT * FROM Orders WHERE OrderDate='2008-11-11'
-- no record will be shown 

--17. SQL Views: Learn how to create and use views to simplify complex queries.
--a view is a virtual table based on the result-set of an SQL statement.

CREATE VIEW [rajkot city person] AS
SELECT FirstName, City
FROM Persons
WHERE city='rajkot';

SELECT * FROM [rajkot city person];

ALTER VIEW[rajkot city person] AS
SELECT FirstName, City
FROM Persons
WHERE city='jamnagar';