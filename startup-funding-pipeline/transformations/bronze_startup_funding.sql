CREATE OR REFRESH STREAMING TABLE bronze_startup_funding
COMMENT 'Incremental ingestion from raw_data'
TBLPROPERTIES (
  'delta.columnMapping.mode' = 'name'
)
AS
SELECT * FROM STREAM read_files(
  's3://startup-data-s3-bucket/raw_data/',
  format => 'csv',
  header => 'true',
  inferColumnTypes => 'true'
);