WITH mrr_with_prev AS (
    SELECT
        user_id,
        month_start,
        normalized_mrr,

        LAG(normalized_mrr) OVER (
            PARTITION BY user_id
            ORDER BY month_start
        ) AS previous_mrr,

        MAX(normalized_mrr) OVER (
            PARTITION BY user_id
            ORDER BY month_start
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS historical_mrr

    FROM monthly_mrr
)

SELECT
    user_id,
    month_start,
    normalized_mrr,
    previous_mrr,
    normalized_mrr - COALESCE(previous_mrr, 0) AS movement,

    CASE
        WHEN COALESCE(previous_mrr,0) = 0 
             AND normalized_mrr > 0 
             AND COALESCE(historical_mrr,0) = 0 THEN 'New MRR'

        WHEN COALESCE(previous_mrr,0) = 0 
             AND normalized_mrr > 0 
             AND COALESCE(historical_mrr,0) > 0 THEN 'Reactivation MRR'

        WHEN COALESCE(previous_mrr,0) > 0 
             AND normalized_mrr = 0 THEN 'Churn MRR'

        WHEN normalized_mrr > previous_mrr THEN 'Expansion MRR'

        WHEN normalized_mrr < previous_mrr 
             AND normalized_mrr > 0 THEN 'Contraction MRR'

        ELSE 'No Movement'
    END AS movement_type

FROM mrr_with_prev
ORDER BY user_id, month_start;
