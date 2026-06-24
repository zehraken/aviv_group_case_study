{% test if_price_is_negative(model, column_name) %}

select *
from {{ model }}
where {{ column_name }} < 0

{% endtest %}