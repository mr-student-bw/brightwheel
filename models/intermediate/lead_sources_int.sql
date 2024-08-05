
with

source1 as (

    select
        'source1'                   as lead_source,
        cast(null as string)        as accepts_financial_aid,
        cast(null as string)        as ages_served,
        cast(null as numeric)       as capacity,
        cast(null as date)          as certificate_expiration_date,
        cast(null as string)        as city,
        address                     as address1,
        cast(null as string)        as address2,
        name                        as company,
        phone                       as phone,
        cast(null as string)        as phone2,
        county                      as county,
        cast(null as string)        as curriculum_type,
        cast(null as string)        as email,
        substr(primary_contact_name,
            0,
            strpos(primary_contact_name, ' ')
            )                       as first_name,
        cast(null as string)        as language,
        substr(primary_contact_name,
            strpos(primary_contact_name, ' ')
            )                       as last_name,
        status                      as license_status,
        credential_number           as license_number,
        cast(null as string)        as license_renewed,
        credential_type             as license_type,
        cast(null as string)        as licensee_name,
        cast(null as numeric)       as max_age,
        cast(null as numeric)       as min_age,
        cast(null as string)        as operator,
        cast(null as string)        as provider_id,
        cast(null as string)        as schedule,
        state                       as state,
        primary_contact_role        as title,
        cast(null as string)        as website_address,
        regexp_extract(address,r"\s\d{5}$") as zip,
        cast(null as string)                as facility_type
    from {{ ref('source1') }}
),

source2 as (

    select
        'source2'                   as lead_source,
        accepts_subsidy             as accepts_financial_aid,
        concat(
            if(ages_accepted_1 is not null, concat(ages_accepted_1, ','), ''),
            if(aa2 is not null, concat(aa2, ','), ''),
            if(aa3 is not null, concat(aa3, ','), ''),
            if(aa4 is not null, concat(aa4, ','), '')
            )                       as ages_served,
        total_cap                   as capacity,
        cast(null as date)          as certificate_expiration_date,
        city                        as city,
        address1                    as address1,
        cast(null as string)        as addres2,
        company                     as company,
        phone                       as phone,
        cast(null as string)        as phone2,
        cast(null as string)        as county,
        cast(null as string)        as curriculum_type,
        email                       as email,
        substr(primary_caregiver,
            0,
            strpos(primary_caregiver, ' ')
            )                       as first_name,
        cast(null as string)        as language,
        substr(primary_caregiver,
            strpos(primary_caregiver, ' ')
            )                       as last_name,
        cast(null as string)        as license_status,
        cast(null as numeric)       as license_number,
        cast(null as string)        as license_renewed,
        type_license                as license_type,
        cast(null as string)        as licensee_name,
        cast(null as numeric)       as max_age,
        cast(null as numeric)       as min_age,
        cast(null as string)        as operator,
        cast(null as string)        as provider_id,
        year_round                  as schedule,
        state                       as state,
        'PRIMARY CAREGIVER'         as title,
        cast(null as string)        as website_address,
        zip                         as zip,
        cast(null as string)        as facility_type
    from {{ ref('source2') }}
),

unioned as (

    select *
    from source1
    union all
    select *
    from source2

),

final as (

    select
        *,
        {{ dbt_utils.generate_surrogate_key(['lead_source',
                                            'phone',
                                            'address1'
                                            ]) }}            as dbt_unique_id -- assuming in each source file, the phone + address1 is unique (there's a test to validate)
    from unioned

)

select *
from final
