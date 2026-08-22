CREATE OR REFRESH STREAMING TABLE silver_startup_funding
(
    CONSTRAINT valid_date
    EXPECT (funding_date IS NOT NULL)
    ON VIOLATION DROP ROW,

    CONSTRAINT valid_startup
    EXPECT (startup IS NOT NULL AND TRIM(startup) <> '')
    ON VIOLATION DROP ROW,

    CONSTRAINT valid_vertical
    EXPECT (vertical IS NOT NULL AND TRIM(vertical) <> '')
    ON VIOLATION DROP ROW,

    CONSTRAINT valid_city
    EXPECT (city IS NOT NULL AND TRIM(city) <> '')
    ON VIOLATION DROP ROW,

    CONSTRAINT valid_investors
    EXPECT (investors IS NOT NULL AND TRIM(investors) <> '')
    ON VIOLATION DROP ROW,

    CONSTRAINT valid_round
    EXPECT (round IS NOT NULL AND TRIM(round) <> '')
    ON VIOLATION DROP ROW,

    CONSTRAINT valid_amount
    EXPECT (amount_inr_crore IS NOT NULL AND amount_inr_crore >= 0)
    ON VIOLATION DROP ROW
)

AS

SELECT
    CAST(`Sr No` AS INT) AS funding_id,

    TO_DATE(
        TRIM(`Date dd/mm/yyyy`),
        'dd/MM/yyyy'
    ) AS funding_date,

    NULLIF(TRIM(`Startup Name`), '') AS startup,

    NULLIF(TRIM(`Industry Vertical`), '') AS vertical,

    NULLIF(TRIM(`SubVertical`), '') AS subvertical,

    NULLIF(TRIM(`City  Location`), '') AS city,

    COALESCE(
        NULLIF(TRIM(`Investors Name`), ''),
        'Undisclosed'
    ) AS investors,

    NULLIF(TRIM(`InvestmentnType`), '') AS round,

    (
        CAST(
            CASE
                WHEN LOWER(TRIM(`Amount in USD`)) IN
                    ('undisclosed', 'unknown', '')
                THEN '0'
                WHEN `Amount in USD` IS NULL
                THEN '0'
                ELSE REGEXP_REPLACE(
                    TRIM(`Amount in USD`),
                    ',',
                    ''
                )
            END
            AS DOUBLE
        ) * 82.5
    ) / 10000000 AS amount_inr_crore

FROM STREAM(bronze_startup_funding);