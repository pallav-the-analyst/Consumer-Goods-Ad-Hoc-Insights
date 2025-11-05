CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_markets_in_each_region`(
in_fiscal_year int,
in_top_n int
)
BEGIN
WITH cte1 AS (
SELECT
  c.market,
  c.region,
  ROUND(SUM(s.gross_price_total)/1000000,2) AS gross_sales_mln
FROM
  gross_sales s
      JOIN
  dim_customer c ON s.customer_code = c.customer_code
WHERE
  s.fiscal_year = in_fiscal_year
GROUP BY c.market, c.region),
cte2 AS (
SELECT *,
  DENSE_RANK() OVER(PARTITION BY region ORDER BY gross_sales_mln DESC) AS rank
FROM cte1)
SELECT * FROM cte2 WHERE rank <= in_top_n;
END
