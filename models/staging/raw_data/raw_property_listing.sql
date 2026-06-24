{{
    config(
        materialized='table',
        unique_key='surrogate_key',
        enabled = false 
    )
}}


--first create a stage referring to s3 bucket on snowflake
--then use copy into command to load data into the stage

select 1 as surrogate_key