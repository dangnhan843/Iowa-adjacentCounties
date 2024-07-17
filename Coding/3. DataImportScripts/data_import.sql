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