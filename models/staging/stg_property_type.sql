{{
    config(
        materialized='table',
        unique_key='surrogate_key'
    )
}}

select 
    {{ dbt_utils.generate_surrogate_key([
        'property_type_id'
    ]) }} as surrogate_key,
    *
from {{ source('aviv_group_case_study','property_type') }}