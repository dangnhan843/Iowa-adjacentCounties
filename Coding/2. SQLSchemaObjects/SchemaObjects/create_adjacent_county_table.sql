-- Create table to store county adjacency relationships
USE IowaCounties;
CREATE TABLE adjacent_county (
    county_id INT NOT NULL,
    adjacent_county_id INT NOT NULL,
    PRIMARY KEY (county_id, adjacent_county_id),
    FOREIGN KEY (county_id) REFERENCES county(id),
    FOREIGN KEY (adjacent_county_id) REFERENCES county(id)
);
