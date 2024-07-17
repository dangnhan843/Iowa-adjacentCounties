-- Create the IowaCounties database
CREATE DATABASE IowaCounties;

-- Use the IowaCounties database
USE IowaCounties;

-- Create the county table
CREATE TABLE county (
    id INT PRIMARY KEY, -- Unique identifier for the county
    county_name VARCHAR(255) NOT NULL, -- Name of the county
    fips_number CHAR(3) NOT NULL UNIQUE, -- Unique FIPS number for the county
    map_number INT NOT NULL UNIQUE -- Unique map number for the county
);

-- Create the adjacent_county table
CREATE TABLE adjacent_county (
    county_id INT NOT NULL, -- ID of the county
    adjacent_county_id INT NOT NULL, -- ID of the adjacent county
    PRIMARY KEY (county_id, adjacent_county_id), -- Composite primary key to ensure unique adjacency pairs
    FOREIGN KEY (county_id) REFERENCES county(id), -- Foreign key reference to county table
    FOREIGN KEY (adjacent_county_id) REFERENCES county(id) -- Foreign key reference to county table
);

-- Bulk insert into the county table
-- Note: Change the file path based on where the CSV file is located. 
-- The CSV file should be included in the folder specified in the path.
BULK INSERT county
FROM 'C:\Users\linky\Downloads\county.csv'
WITH (
    FIELDTERMINATOR = ',', -- Fields are separated by commas
    ROWTERMINATOR = '\n', -- Rows are separated by newline characters
    FIRSTROW = 2, -- Skip the header row
    FORMAT = 'CSV' -- Indicate that the file format is CSV
);

-- Bulk insert into the adjacent_county table
-- Note: Change the file path based on where the CSV file is located. 
-- The CSV file should be included in the folder specified in the path.
BULK INSERT adjacent_county
FROM 'C:\Users\linky\Downloads\adjacent_county.csv'
WITH (
    FIELDTERMINATOR = ',', -- Fields are separated by commas
    ROWTERMINATOR = '\n', -- Rows are separated by newline characters
    FIRSTROW = 2, -- Skip the header row
    FORMAT = 'CSV' -- Indicate that the file format is CSV
);

GO

-- Create a stored procedure to check adjacency between two counties
CREATE PROCEDURE spCheckAdjacency
    @county1 INT, -- First county ID
    @county2 INT, -- Second county ID
    @result BIT OUTPUT -- Output parameter to indicate adjacency (1 if adjacent, 0 if not)
AS
BEGIN
    -- Check if the two counties are adjacent
    IF EXISTS (
        SELECT 1 
        FROM adjacent_county 
        WHERE (county_id = @county1 AND adjacent_county_id = @county2) 
           OR (county_id = @county2 AND adjacent_county_id = @county1)
    )
    BEGIN
        SET @result = 1; -- Set result to 1 if adjacent
    END
    ELSE
    BEGIN
        SET @result = 0; -- Set result to 0 if not adjacent
    END
END;
GO
