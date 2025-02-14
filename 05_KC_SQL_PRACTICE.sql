SELECT 
  calls_ivr_id,
  ARRAY_AGG(document_type ORDER BY document_type LIMIT 1)[OFFSET(0)] AS  document_type,
  ARRAY_AGG(document_identification ORDER BY document_identification LIMIT 1)[OFFSET(0)] AS  document_identification
FROM `keepcoding.ivr_detail`
WHERE document_type != 'UNKNOWN'
GROUP BY 1;