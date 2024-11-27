-- models/violations_dim.sql

{{ config(materialized='table') }}

WITH violation_table AS(SELECT DISTINCT violation_code, violation_description, critical_flag FROM `cis9440gp.RawDataset.RestaurantInspection`)
SELECT * , ROW_NUMBER() OVER() AS violation_dim_id FROM violation_table WHERE violation_code IS NOT NULL