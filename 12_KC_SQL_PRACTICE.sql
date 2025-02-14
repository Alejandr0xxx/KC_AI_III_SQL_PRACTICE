CREATE TABLE IF NOT EXISTS `keepcoding.ivr_summary` AS
WITH vdn_aggregation_cte AS (
  SELECT
    calls_ivr_id,
    CASE
      WHEN calls_vdn_label LIKE 'ATC%' THEN 'FRONT'
      WHEN calls_vdn_label LIKE 'TECH%' THEN 'TECH'
      WHEN calls_vdn_label = 'ABSORPTION' THEN calls_vdn_label
      ELSE 'RESTO'
    END AS vdn_aggregation
  FROM `keepcoding.ivr_detail`
), 
document_type_cte AS (
  SELECT 
    calls_ivr_id,
    ARRAY_AGG(document_type ORDER BY document_type LIMIT 1)[OFFSET(0)] AS  document_type,
    ARRAY_AGG(document_identification ORDER BY document_identification LIMIT 1)[OFFSET(0)] AS  document_identification
  FROM `keepcoding.ivr_detail`
  WHERE document_type != 'UNKNOWN'
  GROUP BY 1
), 
customer_phone_cte AS (
  SELECT 
    calls_ivr_id,
    ARRAY_AGG(customer_phone ORDER BY customer_phone LIMIT 1)[OFFSET(0)] AS customer_phone
  FROM `keepcoding.ivr_detail`
  WHERE customer_phone != 'UNKNOWN' 
  GROUP BY 1
),
billing_account_id_cte AS (
  SELECT 
    calls_ivr_id,
    ARRAY_AGG(billing_account_id ORDER BY billing_account_id LIMIT 1)[OFFSET(0)] AS billing_account_id
  FROM `keepcoding.ivr_detail`
  WHERE billing_account_id != 'UNKNOWN' 
  GROUP BY 1
),
masiva_lg_cte AS (
  SELECT 
    calls_ivr_id,
    CASE
      WHEN COUNTIF(module_name = 'AVERIA_MASIVA') >= 1 THEN 1 
      ELSE 0
    END AS masiva_lg
  FROM `keepcoding.ivr_detail`
  GROUP BY 1
),
info_by_phone_cte AS (
  SELECT 
    calls_ivr_id,
    CASE
      WHEN COUNTIF(step_result = 'OK' AND step_name = 'CUSTOMERINFOBYPHONE.TX') >= 1 THEN 1
      ELSE 0
    END AS info_by_phone_lg
  FROM `keepcoding.ivr_detail`
  GROUP BY 1
),
info_by_dni_cte AS (
  SELECT 
    calls_ivr_id,
    CASE
      WHEN COUNTIF(step_result = 'OK' AND step_name = 'CUSTOMERINFOBYDNI.TX') >= 1 THEN 1
      ELSE 0
    END AS info_by_dni_lg
  FROM `keepcoding.ivr_detail`
  GROUP BY 1
),
repeated_calls_cte AS (
  SELECT 
  det_curr.calls_ivr_id,
  IFNULL(
    MAX(
      CASE 
        WHEN TIMESTAMP_DIFF(det_call.calls_start_date, det_curr.calls_start_date, MINUTE) BETWEEN 0 AND 1440 THEN 1
      ELSE 0
      END
      ), 
    0) AS repeated_phone_24H,
  IFNULL(
    MAX(
      CASE 
        WHEN TIMESTAMP_DIFF(det_curr.calls_start_date, det_call.calls_start_date, MINUTE) BETWEEN 0 AND 1440 THEN 1
        ELSE 0
      END), 
    0) AS cause_recall_phone_24H
FROM `keepcoding.ivr_detail` det_curr
LEFT JOIN `keepcoding.ivr_detail` det_call
  ON det_curr.calls_phone_number = det_call.calls_phone_number
  AND det_curr.calls_ivr_id != det_call.calls_ivr_id
GROUP BY det_curr.calls_ivr_id
)
SELECT 
  DISTINCT det.calls_ivr_id,
  det.calls_phone_number,
  det.calls_ivr_result,
  agg.vdn_aggregation,
  det.calls_start_date,
  det.calls_end_date,
  det.calls_total_duration,
  det.calls_customer_segment,
  det.calls_ivr_language,
  det.calls_steps_module,
  det.calls_module_aggregation,
  ide.document_type ,
  ide.document_identification,
  pho.customer_phone,
  bill.billing_account_id,
  mas.masiva_lg  ,
  inf_phone.info_by_phone_lg,
  inf_ide.info_by_dni_lg  ,
  calls.repeated_phone_24H  ,
  calls.cause_recall_phone_24H  
FROM `keepcoding.ivr_detail` det
LEFT JOIN vdn_aggregation_cte agg USING (calls_ivr_id)
LEFT JOIN document_type_cte ide USING (calls_ivr_id)
LEFT JOIN customer_phone_cte pho USING (calls_ivr_id)
LEFT JOIN billing_account_id_cte bill USING (calls_ivr_id)
LEFT JOIN masiva_lg_cte mas USING (calls_ivr_id)
LEFT JOIN info_by_phone_cte inf_phone USING (calls_ivr_id)
LEFT JOIN info_by_dni_cte inf_ide USING (calls_ivr_id)
LEFT JOIN repeated_calls_cte calls USING(calls_ivr_id);
