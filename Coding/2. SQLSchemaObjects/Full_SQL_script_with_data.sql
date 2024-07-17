/*
=============================================
SQL Script for Iowa County Adjacency Project
=============================================

Description:
- This SQL script sets up the database schema and procedures for checking county adjacency in Iowa.
- It creates tables for counties and their adjacencies, inserts predefined county data, and defines a stored procedure to check adjacency.

Scenario:
- Residents in Iowa can register their vehicles in any county adjacent to their county of residence.
- The script defines a database structure with counties and their adjacency relationships.
- Specific counties (Boone, Carroll, Dallas, Greene, Guthrie, Webster, Calhoun, Hamilton, Hardin, Jasper, Polk, Story, Benton, BlackHawk, Grundy, Iowa, Marshall, Poweshiek, Tama) are included with adjacency definitions.
- The stored procedure `spCheckAdjacency` allows checking if two counties are adjacent based on predefined adjacency rules.

Assumptions:
- The adjacency relationships between counties are predefined and based on geographic proximity.
- Additional counties and their adjacencies can be added using similar SQL insert statements.

*/

CREATE DATABASE IowaCounties;
GO

USE IowaCounties;
GO

-- Create table to store county information
CREATE TABLE county (
    id INT PRIMARY KEY,
    county_name VARCHAR(255) NOT NULL
);

-- Create table to store county adjacency relationships
CREATE TABLE adjacent_county (
    county_id INT NOT NULL,
    adjacent_county_id INT NOT NULL,
    PRIMARY KEY (county_id, adjacent_county_id),
    FOREIGN KEY (county_id) REFERENCES county(id),
    FOREIGN KEY (adjacent_county_id) REFERENCES county(id)
);

-- SQL script for inserting data into the county and adjacent_county tables
-- This script is part of a solution to determine if two counties in Iowa are adjacent
-- Specifically, the data for Story, Greene, and Tama counties must be accurate

-- Insert data into county table
INSERT INTO county (id, county_name)
VALUES
    (47, 'Boone'),
    (45, 'Carroll'),
    (59, 'Dallas'),
    (46, 'Greene'),
    (58, 'Guthrie'),
    (35, 'Webster'),
    (34, 'Calhoun'),
    (36, 'Hamilton'),
    (37, 'Hardin'),
    (61, 'Jasper'),
    (60, 'Polk'),
    (48, 'Story'),
    (51, 'Benton'),
    (39, 'BlackHawk'),
    (38, 'Grundy'),
    (63, 'Iowa'),
    (49, 'Marshall'),
    (62, 'Poweshiek'),
    (50, 'Tama');

-- Insert data into adjacent_county table
-- This table represents the adjacency relationships between counties
INSERT INTO adjacent_county (county_id, adjacent_county_id)
VALUES
    -- Adjacency for Greene County (46)
    (46, 47),   -- Greene is adjacent to Boone
    (46, 34),  -- Greene is adjacent to Calhoun
    (46, 45),  -- Greene is adjacent to Carroll
    (46, 59),  -- Greene is adjacent to Dallas
    (46, 58),  -- Greene is adjacent to Guthrie
    (46, 35),  -- Greene is adjacent to Webster
    
    -- Adjacency for Story County (48)
    (48, 47),   -- Story is adjacent to Boone
    (48, 36),  -- Story is adjacent to Hamilton
    (48, 37),  -- Story is adjacent to Hardin
    (48, 61),  -- Story is adjacent to Jasper
    (48, 49),  -- Story is adjacent to Marshall
    (48, 60),  -- Story is adjacent to Polk
    
    -- Adjacency for Tama County (50)
    (50, 51),   -- Tama is adjacent to Benton
    (50, 39),   -- Tama is adjacent to BlackHawk
    (50, 38),  -- Tama is adjacent to Grundy
    (50, 63),  -- Tama is adjacent to Iowa
    (50, 61),  -- Tama is adjacent to Jasper
    (50, 49),  -- Tama is adjacent to Marshall
    (50, 62);  -- Tama is adjacent to Poweshiek


-- Create stored procedure to check adjacency
CREATE PROCEDURE spCheckAdjacency
    @county1 INT,
    @county2 INT,
    @result BIT OUTPUT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM adjacent_county
        WHERE (county_id = @county1 AND adjacent_county_id = @county2)
           OR (county_id = @county2 AND adjacent_county_id = @county1)
    )
    BEGIN
        SET @result = 1; -- Counties are adjacent
    END
    ELSE
    BEGIN
        SET @result = 0; -- Counties are not adjacent
    END
END;
GO
