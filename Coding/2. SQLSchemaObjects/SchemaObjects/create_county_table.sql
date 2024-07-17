-- Create table to store county information
USE IowaCounties;
CREATE TABLE county (
    id INT PRIMARY KEY,
    county_name VARCHAR(255) NOT NULL
);