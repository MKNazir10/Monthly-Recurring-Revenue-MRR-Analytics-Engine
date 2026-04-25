DROP TABLE IF EXISTS monthly_mrr;

CREATE TABLE monthly_mrr AS

WITH month_ends AS (
    SELECT
        month_start,
        (month_start + INTERVAL '1 month' - INTERVAL '1 day')::date AS month_end
    FROM dim_month
),

user_months AS (
    SELECT
        u.user_id,
        m.month_start,
        m.month_end
    FROM users u
    CROSS JOIN month_ends m
)

SELECT
    um.user_id,
    um.month_start,
    COALESCE(p.monthly_price, 0) AS normalized_mrr
FROM user_months um
LEFT JOIN subscription_periods sp
    ON um.user_id = sp.user_id
   AND sp.start_date <= um.month_end
   AND sp.end_date > um.month_end
LEFT JOIN plan_dim p
    ON sp.plan_id = p.plan_id
ORDER BY um.user_id, um.month_start;
