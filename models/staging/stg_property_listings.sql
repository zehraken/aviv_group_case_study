{{
    config(
        materialized='table',
        unique_key='surrogate_key'
    )
}}

select 
    {{ dbt_utils.generate_surrogate_key([
        'listing_id'
    ]) }} as surrogate_key,
    pl.listing_id,
    pt.property_type_id,
    cr.city_region_id,
    nullif(pl.price::numeric,0) as price_eur, --if this is in EUR
    nullif(pl.price::numeric,0) * 1.2 as price_usd, --we can convert to USD, assuming 1 EUR = 1.2 USD
    pl.created_at as created_at,
    pl.updated_at as updated_at,
    --in snowflake we can use also try_to_timestamp(pl.created_at) as created_at,
    --in snowflake we can use also try_to_timestamp(pl.updated_at) as updated_at
    --pl.created_at::timestamp as created_at,
    --pl.updated_at::timestamp as updated_at,
    --if the month value is needed in many datamart tables it can be handled here once and then used in the datamart tables, 
    --instead of calculating it in each datamart table
    left(pl.created_at::text, 7) as created_month,
    left(pl.updated_at::text, 7) as updated_month
from {{ source('aviv_group_case_study','property_listings') }} as pl
left join {{ ref('stg_property_type') }} as pt
    on pl.property_type = pt.property_type
left join {{ ref('stg_city_region') }} as cr
    on pl.city = cr.city
    and pl.region = cr.region