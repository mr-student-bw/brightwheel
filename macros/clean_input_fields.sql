{% macro clean_input_fields(field, datatype, keepOnlyAlphanumeric) %}
    
    -- trims leading/trailing whitespaces, makes upper case, casts to the selected datatype, strips non-alphanumeric characters if selected

    safe_cast(upper(
            trim(
                case when {{ keepOnlyAlphanumeric }}
                then regexp_replace( cast( {{ field }} as string),r"[^a-zA-Z0-9]+", "")
                else cast( {{ field }} as string)
                end
            )
        ) as {{ datatype }}
    )

{% endmacro %}