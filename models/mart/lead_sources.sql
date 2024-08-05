with
lead_sources as (

    select *
    from {{ ref('lead_sources_int') }}

),

salesforce_leads as (

    select *
    from {{ ref('salesforce_leads_int') }}

),

final as (

    select
        lead_sources.* except (dbt_unique_id),
        salesforce_leads.* except (phone),
        {{ dbt_utils.generate_surrogate_key(['lead_sources.dbt_unique_id',
                                            'salesforce_leads.salesforce_lead_id'
                                            ]) }}            as dbt_unique_id
    from lead_sources
        left join salesforce_leads
            on lead_sources.phone = salesforce_leads.phone -- I changed the phone numbers in 3 records in salesforce_leads to match those in the sources so the join would return some values

)

select *
from final