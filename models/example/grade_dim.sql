-- models/grade_dim.sql

{{ config(materialized='table') }}

WITH grade_table AS(SELECT DISTINCT(grade) AS grade_descriptive
    FROM `cis9440gp.RawDataset.RestaurantInspection`),
    grade_descriptions AS(
        SELECT grade_descriptive,
        CASE 
            WHEN grade_descriptive = 'A' THEN 'A'
            WHEN grade_descriptive = 'B' THEN 'B'
            WHEN grade_descriptive = 'C' THEN 'C'
            WHEN grade_descriptive IN ('Z', 'P') THEN 'Grade Pending'
            WHEN grade_descriptive = 'N' THEN 'Not Yet Graded'
        ELSE 'N/A'
        END AS grade
        FROM grade_table
     )
     SELECT grade_descriptions.grade, ROW_NUMBER() OVER() AS grade_dim_id FROM grade_descriptions