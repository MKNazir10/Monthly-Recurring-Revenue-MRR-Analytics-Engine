DROP TABLE IF EXISTS subscription_periods;

CREATE TABLE subscription_periods AS
WITH ordered_events AS (
    SELECT
        user_id,
        new_plan_id,
        effective_date,
        LEAD(effective_date) OVER (
            PARTITION BY user_id
            ORDER BY effective_date
        ) AS next_date
    FROM subscription_events
)
SELECT
    user_id,
    new_plan_id AS plan_id,
    effective_date AS start_date,
    COALESCE(next_date, DATE '9999-12-31') AS end_date
FROM ordered_events
WHERE new_plan_id IS NOT NULL;
