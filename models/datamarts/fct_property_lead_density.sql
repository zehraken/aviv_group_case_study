{{
    config(
        materialized='table',
        unique_key='surrogate_key'
    )
}}

with listings as (
    select * from {{ ref('stg_property_listings') }}
),

lead_counts as (
    select
        listing_id,
        count(contact_id) as total_leads 
    from {{ ref('stg_leads_contacts') }}
    group by 1
),

joined_data as (
    select
        l.city_region_id,
        l.property_type_id,
        l.listing_id,
        coalesce(lc.total_leads, 0) as leads_received
    from listings l
    left join lead_counts lc 
        on l.listing_id = lc.listing_id
),

joined_aggregated as (

    select
        city_region_id,
        property_type_id,
        count(distinct listing_id) as total_active_listings,
        sum(leads_received) as total_leads_received,
        
        -- İlan başına düşen ortalama lead sayısı (Talep Yoğunluğu)
        case 
            when count(distinct listing_id) > 0 
            then round(sum(leads_received)::numeric / count(distinct listing_id), 2)
            else 0 
        end as avg_leads_per_listing
    from joined_data
    group by 1, 2

)

-- Son aşamada bölge ve emlak tipine göre metrikleri topluyoruz
select
    {{ dbt_utils.generate_surrogate_key([
        'city_region_id',
        'property_type_id'
    ]) }} as surrogate_key,
    city_region_id,
    property_type_id,
    total_active_listings,
    total_leads_received,
    avg_leads_per_listing
from joined_aggregated