with
base as (
    
    select
        *
    from {{ source('raw','salesforce_leads') }}

)

select *
from base