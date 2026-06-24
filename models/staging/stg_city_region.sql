{{
    config(
        materialized='table',
        unique_key='surrogate_key'
    )
}}

select 
    {{ dbt_utils.generate_surrogate_key([
        'city_region_id'
    ]) }} as surrogate_key,
    *
from {{ source('aviv_group_case_study','city_region') }}