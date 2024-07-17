-- Create stored procedure to check adjacency
USE IowaCounties;
GO

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