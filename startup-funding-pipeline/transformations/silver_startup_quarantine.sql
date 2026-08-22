CREATE OR REFRESH STREAMING TABLE startup_funding_quarantine
AS
SELECT
    CAST(`Sr No` AS INT) AS funding_id,
    `Date dd/mm/yyyy` AS funding_date_raw,
    `Startup Name` AS startup,
    `Industry Vertical` AS vertical,
    `SubVertical` AS subvertical,
    `City  Location` AS city,
    `Investors Name` AS investors,
    `InvestmentnType` AS investment_type,
    `Amount in USD` AS amount_usd,
    `Remarks` AS remarks
FROM STREAM(bronze_startup_funding)
WHERE
    `Amount in USD` IS NULL
    OR NOT (
        REGEXP_REPLACE(
            CASE
                WHEN LOWER(TRIM(`Amount in USD`)) IN
                    ('undisclosed', 'unknown', '')
                THEN '0'
                ELSE TRIM(`Amount in USD`)
            END,
            ',',
            ''
        ) RLIKE '^[0-9]+$'
    );