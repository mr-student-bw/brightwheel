  with base as (
    
    select
        {{ clean_input_fields('accepts_subsidy', 'string', false) }}                as accepts_subsidy,
        {{ clean_input_fields('ages_accepted_1', 'string', false) }}                as ages_accepted_1,
        {{ clean_input_fields('aa2', 'string', false) }}                            as aa2,
        {{ clean_input_fields('aa3', 'string', false) }}                            as aa3,
        {{ clean_input_fields('aa4', 'string', false) }}                            as aa4,
        {{ clean_input_fields('total_cap', 'numeric', false) }}                     as total_cap,
        {{ clean_input_fields('city', 'string', false) }}                           as city,
        {{ clean_input_fields('address1', 'string', false) }}                       as address1,
        {{ clean_input_fields('company', 'string', false) }}                        as company,
        {{ clean_input_fields('phone', 'numeric', true) }}                          as phone,
        {{ clean_input_fields('email', 'string', false) }}                          as email,
        {{ clean_input_fields('primary_caregiver', 'string', false) }}              as primary_caregiver,
        {{ clean_input_fields('type_license', 'string', false) }}                   as type_license,
        {{ clean_input_fields('year_round', 'string', false) }}                     as year_round,
        {{ clean_input_fields('state', 'string', false) }}                          as state,
        {{ clean_input_fields('zip', 'string', false) }}                            as zip
    from {{ source('raw','source2') }}
)
select *
from base