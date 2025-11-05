CREATE DEFINER=`root`@`localhost` PROCEDURE `get_market_badge`(
IN in_market VARCHAR(45),
IN in_fiscal_year YEAR,
OUT out_badge VARCHAR(45)
)
BEGIN
DECLARE qty INT DEFAULT 0;
#Set default market to be india
IF in_market = "" THEN SET in_market = "India";
END IF;
# Retrieve total qty for a given market+fyear
SELECT
  SUM(sold_quantity) INTO qty
FROM
  fact_sales_monthly s 
      JOIN
  dim_customer c ON s.customer_code = c.customer_code
WHERE
  get_fiscal_year(s.date) = in_fiscal_year
      AND c.market = in_market
GROUP BY c.market;
#Datermine market badge
IF qty > 5000000 THEN SET out_badge = "Gold";
ELSE SET out_badge = "Silver";
END IF;
END
