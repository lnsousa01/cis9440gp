-- models/business_dim.sql

{{ config(materialized='table') }}

WITH business_table AS(SELECT DISTINCT(camis) as camis, dba AS business_name, 
round(cast(latitude AS numeric),6) as latitude, 
round(cast(longitude AS numeric),6) as longitude, 
cuisine_description as cuisine_description FROM `cis9440gp.RawDataset.RestaurantInspection`),
location_table AS(SELECT round(cast(latitude AS numeric),6) as latitude, 
round(cast(longitude AS numeric),6) as longitude,
    CASE
        WHEN location_type IN ('Cafeteria - College/University', 'Cafeteria - Private School', 'Cafeteria - Public School') THEN 'Educational Cafeteria'
        WHEN location_type IN ('Food Cart Vendor', 'Mobile Food Vendor', 'Street Vendor', 'Street Fair Vendor') THEN 'Mobile Food Service'
        WHEN location_type IN ('Restaurant', 'Restaurant/Bar/Deli/Bakery') THEN 'Restaurant Types'
        WHEN location_type IN ('Catering Service', 'Catering Hall') THEN 'Catering Operations'
        ELSE 'Other Types'
    END AS food_establishment_type
FROM `cis9440gp.RawDataset.FoodEstablishment`),
final AS(SELECT * FROM business_table CROSS JOIN location_table WHERE business_table.latitude=location_table.latitude)
SELECT business_name, cuisine_description, food_establishment_type, ROW_NUMBER() OVER() AS business_dim_id  FROM final 