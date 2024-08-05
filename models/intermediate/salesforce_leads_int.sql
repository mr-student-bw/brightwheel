with
base as (

    select
        id          as salesforce_lead_id,
        phone       as phone,
        is_deleted  as is_deleted,
        status      as salesforce_status
    from {{ ref('salesforce_leads') }}

)

select *
from base