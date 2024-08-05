with base as (
    
    select
        {{ clean_input_fields('address', 'string', false) }}                as address,
        {{ clean_input_fields('name', 'string', false) }}                   as name,
        {{ clean_input_fields('phone', 'numeric', true) }}                  as phone,
        {{ clean_input_fields('county', 'string', false) }}                 as county,
        {{ clean_input_fields('primary_contact_name', 'string', false) }}   as primary_contact_name,
        {{ clean_input_fields('status', 'string', false) }}                 as status,
        {{ clean_input_fields('credential_number', 'numeric', true) }}      as credential_number,
        {{ clean_input_fields('credential_type', 'string', false) }}        as credential_type,
        {{ clean_input_fields('state', 'string', false) }}                  as state,
        {{ clean_input_fields('primary_contact_role', 'string', false) }}   as primary_contact_role
    from {{ source('raw','source1') }}
)
select *
from base