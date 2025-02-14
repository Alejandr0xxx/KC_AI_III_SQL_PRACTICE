SELECT 
  calls_ivr_id,
  CASE
    WHEN COUNTIF(module_name = 'AVERIA_MASIVA') >= 1 THEN 1 
    ELSE 0
  END AS masiva_lg
FROM `keepcoding.ivr_detail`
GROUP BY 1;