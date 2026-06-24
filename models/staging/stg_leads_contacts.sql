{{
    config(
        materialized='incremental',
        unique_key='surrogate_key',
        incremental_strategy='delete+insert',
        on_schema_change='append_new_columns'
    )
}}

select 
    {{ dbt_utils.generate_surrogate_key([
        'contact_id',
        'listing_id'
    ]) }} as surrogate_key,
    *
from {{ source('aviv_group_case_study','leads_contacts') }}