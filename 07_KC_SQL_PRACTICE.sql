SELECT 
  calls_ivr_id,
  ARRAY_AGG(billing_account_id ORDER BY billing_account_id LIMIT 1)[OFFSET(0)] AS billing_account_id
FROM `keepcoding.ivr_detail`
WHERE billing_account_id != 'UNKNOWN' 
GROUP BY 1;
