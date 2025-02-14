SELECT 
  calls_ivr_id,
  CASE
    WHEN COUNTIF(step_result = 'OK' AND step_name = 'CUSTOMERINFOBYPHONE.TX') >= 1 THEN 1
    ELSE 0
  END AS info_by_phone_lg
FROM `keepcoding.ivr_detail`
GROUP BY 1;