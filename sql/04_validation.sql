-- No overlapping periods per user
SELECT user_id
FROM subscription_periods sp1
JOIN subscription_periods sp2
  ON sp1.user_id = sp2.user_id
 AND sp1.start_date < sp2.end_date
 AND sp2.start_date < sp1.end_date
 AND sp1.start_date <> sp2.start_date;

-- One row per user per month
SELECT user_id, month_start, COUNT(*)
FROM monthly_mrr
GROUP BY user_id, month_start
HAVING COUNT(*) > 1;

-- No negative MRR
SELECT *
FROM monthly_mrr
WHERE normalized_mrr < 0;
