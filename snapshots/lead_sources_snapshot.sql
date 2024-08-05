{% snapshot lead_sources_snapshot %}

    -- takes snapshot of lead_sources to track changes over time

    {{
        config(
          target_schema='snapshots',
          strategy='check',
          unique_key='dbt_unique_id',
          check_cols= 'all',
        )
    }}

select *
from {{ ref('lead_sources') }}

{% endsnapshot %}