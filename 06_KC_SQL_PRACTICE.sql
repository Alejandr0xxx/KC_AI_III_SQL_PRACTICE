SELECT 
  calls_ivr_id,
  ARRAY_AGG(customer_phone ORDER BY customer_phone LIMIT 1)[OFFSET(0)] AS customer_phone
FROM `keepcoding.ivr_detail`
WHERE customer_phone != 'UNKNOWN' 
GROUP BY 1;