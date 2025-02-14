CREATE TEMPORARY FUNCTION clean_integer(x INT)
RETURNS INT AS (
   IFNULL(x, -99999)
);

SELECT 
  value,
  clean_integer(value)
FROM UNNEST([NULL]) AS value
