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
GROUP BY det_curr.calls_ivr_id;
