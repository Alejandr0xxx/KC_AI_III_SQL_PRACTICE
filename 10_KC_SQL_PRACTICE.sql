SELECT 
  calls_ivr_id,
  CASE
    WHEN COUNTIF(step_result = 'OK' AND step_name = 'CUSTOMERINFOBYDNI.TX') >= 1 THEN 1
    ELSE 0
  END AS info_by_dni_lg
FROM `keepcoding.ivr_detail`
GROUP BY 1;