SELECT * FROM data;

-- 1. Total number of smartphones available.
SELECT COUNT(*) FROM data;

-- 2. Total number of unique brands.
SELECT DISTINCT(brand) FROM data;
SELECT COUNT(DISTINCT(brand)) FROM data;

-- 3. Average smartphone price.
SELECT AVG(price) FROM data;

-- 4. Average user rating.
SELECT AVG(rating) FROM data;

-- 5. Average discount percentage.
SELECT AVG(discount) FROM data;

-- 6. Average battery capacity.
SELECT AVG(battery) FROM data;

-- 7. Average RAM offered.
SELECT AVG(ram) FROM data;

-- 8. Average storage offered.
SELECT AVG(storage) FROM data;

-- 9. Most expensive smartphone.
SELECT *
FROM (
SELECT *, DENSE_RANK() OVER(ORDER BY price DESC) AS r FROM data
) t
WHERE r = 1 ;

-- 10. Cheapest smartphone.
SELECT *
FROM (
SELECT *, DENSE_RANK() OVER(ORDER BY price ASC) AS r FROM data
) t
WHERE r = 1 ;

-- 11. Number of smartphones offered by each brand.
SELECT brand, COUNT(name) FROM DATA
GROUP BY brand;

-- 12. Average price by brand.
SELECT brand, ROUND(AVG(price),2) FROM DATA
GROUP BY brand;

-- 13. Highest-priced smartphone for each brand.
SELECT *
FROM (
	SELECT *,
		DENSE_RANK() OVER(PARTITION BY brand ORDER BY price DESC
	) AS r 
	FROM data
) t
WHERE r = 1;

-- 14. Lowest-priced smartphone for each brand.
SELECT *
FROM (
	SELECT *,
		DENSE_RANK() OVER(PARTITION BY brand ORDER BY price ASC
	) AS r 
	FROM data
) t
WHERE r = 1;

-- 15. Average rating by brand.
SELECT brand, ROUND(AVG(rating),2) FROM DATA
GROUP BY brand;

-- 16. Highest-rated smartphone for each brand.
SELECT *
FROM (
	SELECT *,
		DENSE_RANK() OVER(PARTITION BY brand ORDER BY rating DESC
	) AS r 
	FROM data
) t
WHERE r = 1;


-- 17. Lowest-rated smartphone for each brand.
SELECT *
FROM (
	SELECT *,
		DENSE_RANK() OVER(PARTITION BY brand ORDER BY rating ASC
	) AS r 
	FROM data
) t
WHERE r = 1;

-- 18. Average discount by brand.
SELECT brand, ROUND(AVG(discount),2) FROM DATA
GROUP BY brand;

-- 19. Average battery capacity by brand.
SELECT brand, ROUND(AVG(battery),2) FROM DATA
GROUP BY brand;

-- 20. Average RAM by brand.
SELECT brand, ROUND(AVG(ram),2) FROM DATA
GROUP BY brand;

-------------------------------------------------------------------------------------
ALTER TABLE data
ADD COLUMN price_segment VARCHAR(20);

UPDATE data
SET price_segment =
    CASE
        WHEN price < 15000 THEN 'Budget'
        WHEN price < 30000 THEN 'Mid Range'
        WHEN price < 60000 THEN 'Premium'
        ELSE 'Ultra Premium'
    END;
-------------------------------------------------------------------------------------

-- 21. Number of smartphones in each price segment.
SELECT price_segment, COUNT(*) FROM data
GROUP BY price_segment;

-- 22. Average rating by price segment.
SELECT price_segment, ROUND(AVG(rating),2) FROM data
GROUP BY price_segment;

-- 23. Average battery capacity by price segment.
SELECT price_segment, ROUND(AVG(battery),2) FROM data
GROUP BY price_segment;

-- 24. Average RAM by price segment.
SELECT price_segment, ROUND(AVG(ram),2) FROM data
GROUP BY price_segment;

-- 25. Average storage by price segment.
SELECT price_segment, ROUND(AVG(storage),2) FROM data
GROUP BY price_segment;

-- 26. Most popular brand in each price segment.
SELECT 
    price_segment,
    brand,
    total_models
FROM (
    SELECT 
        price_segment,
        brand,
        COUNT(*) AS total_models,
        ROW_NUMBER() OVER(PARTITION BY price_segment ORDER BY COUNT(*) DESC) AS rank_position
    FROM data
    GROUP BY price_segment, brand
) ranked
WHERE rank_position = 1
ORDER BY price_segment;

-- 27. Top 5 most expensive smartphones.
SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER (
               ORDER BY price DESC
           ) AS r
    FROM data
) t
WHERE r < 6;

-- 28. Top 5 cheapest smartphones.
SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER (
               ORDER BY price ASC
           ) AS r
    FROM data
) t
WHERE r < 6;

-- 29. Best-rated smartphone under ₹10,000.
SELECT *
FROM (
	SELECT *,
		DENSE_RANK() OVER(
			ORDER BY rating DESC) AS r
		FROM data
		WHERE price <= 10000
) t
WHERE R = 1;

-- 30. Best-rated smartphone under ₹20,000.
SELECT *
FROM (
	SELECT *,
		DENSE_RANK() OVER(
			ORDER BY rating DESC) AS r
		FROM data
		WHERE price <= 20000
) t
WHERE R = 1;

-- 31. Distribution of smartphones by RAM size.
SELECT
    ram,
    COUNT(*) AS total_smartphones
FROM data
GROUP BY ram
ORDER BY ram;

-- 32. Distribution of smartphones by storage size.
SELECT
    storage,
    COUNT(*) AS total_smartphones
FROM data
GROUP BY storage
ORDER BY storage;

-- 33. Distribution of smartphones by battery capacity.
SELECT
    battery,
    COUNT(*) AS total_smartphones
FROM data
GROUP BY battery
ORDER BY battery;

-- 34. Most common processor family.
SELECT 
    processor,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM data
GROUP BY processor
ORDER BY count DESC
LIMIT 5;

-- 35. Average price for each RAM size.
SELECT
    ram,
    ROUND(AVG(price), 2) AS avg_price
FROM data
GROUP BY ram
ORDER BY ram;

-- 36. Average price for each storage size.
SELECT
    storage,
    ROUND(AVG(price), 2) AS avg_price
FROM data
GROUP BY storage
ORDER BY storage;

-- 37. Average price for each processor family.
SELECT
    processor,
    ROUND(AVG(price), 2) AS avg_price
FROM data
GROUP BY processor
ORDER BY avg_price DESC;

-- 38. Top 10 smartphones with the highest ratings.
SELECT * 
FROM(
	SELECT *, 
		DENSE_RANK() OVER(
			ORDER BY rating DESC
		) AS r
	FROM data
) t
WHERE r < 11;

-- 39. Top 10 smartphones with the highest rating counts.
SELECT * 
FROM(
	SELECT *, 
		DENSE_RANK() OVER(
			ORDER BY ratings DESC
		) AS r
	FROM data
) t
WHERE r < 11;

-- 40. Top 10 smartphones with the highest review counts.
SELECT * 
FROM(
	SELECT *, 
		DENSE_RANK() OVER(
			ORDER BY reviews DESC
		) AS r
	FROM data
) t
WHERE r < 11;

-- 41. Smartphones with ratings above the overall average.
SELECT *
FROM (
    SELECT *,
           AVG(rating) OVER () AS avg_rating
    FROM data
) t
WHERE rating > avg_rating;

-- 42. Smartphones priced above their brand's average price.
SELECT *
FROM (
    SELECT *,
           AVG(price) OVER () AS avg_price
    FROM data
) t
WHERE price > avg_price;

-- 43. Smartphones priced below their brand's average price.
SELECT *
FROM (
    SELECT *,
           AVG(price) OVER (PARTITION BY brand) AS avg_price
    FROM data
) t
WHERE price < avg_price;

-- 44. Rank smartphones by price within each brand.
SELECT *,
DENSE_RANK() OVER(PARTITION BY brand ORDER BY price DESC) AS r
FROM data;

-- 45. Rank smartphones by rating within each brand.
SELECT *,
DENSE_RANK() OVER(PARTITION BY brand ORDER BY rating DESC) AS r
FROM data;

--  46. Top 3 smartphones from each brand based on ratings.
SELECT *
FROM (
	SELECT *,
		DENSE_RANK() OVER(PARTITION BY brand ORDER BY ratings DESC
		) AS r
	FROM data
) t
WHERE r <= 3;

-- 47. Brand with the highest average discount.
SELECT
    brand,
    ROUND(AVG(discount), 2) AS avg_discount
FROM data
GROUP BY brand
ORDER BY avg_discount DESC
LIMIT 1;

-- 48. Brand with the highest average rating.
SELECT
    brand,
    ROUND(AVG(rating), 2) AS avg_rating
FROM data
GROUP BY brand
ORDER BY avg_rating DESC
LIMIT 1;

-- 49. Brand with the highest average battery capacity.
SELECT
    brand,
    ROUND(AVG(battery), 2) AS avg_battery
FROM data
GROUP BY brand
ORDER BY avg_battery DESC
LIMIT 1;

-- 50. Create a summary report showing each brand's phone count, average price, average rating, average discount, average battery, average RAM, and average storage.
SELECT
    brand,
    COUNT(*) AS total_phones,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(discount), 2) AS avg_discount,
    ROUND(AVG(battery), 2) AS avg_battery,
    ROUND(AVG(ram), 2) AS avg_ram,
    ROUND(AVG(storage), 2) AS avg_storage
FROM data
GROUP BY brand
ORDER BY brand;

-- 51. Price-to-rating value analysis
SELECT 
    brand,
    ROUND(AVG(price / rating), 2) AS cost_per_rating_point,
    COUNT(*) AS sample_size
FROM data
GROUP BY brand
HAVING COUNT(*) >= 5
ORDER BY cost_per_rating_point;

-- 52. Best value segments (high rating, low price)
SELECT 
    name,
    brand,
    price,
    rating,
    ROUND(price / rating, 2) AS price_per_rating,
    DENSE_RANK() OVER(ORDER BY price / rating) AS value_rank
FROM data
WHERE rating >= 4.0
ORDER BY price_per_rating
LIMIT 10;

-- 53. Brand market share by price segment
SELECT 
    price_segment,
    brand,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY price_segment), 2) AS segment_share
FROM data
GROUP BY price_segment, brand
ORDER BY price_segment, segment_share DESC;

-- 54. Discount effectiveness
SELECT 
    CASE 
        WHEN discount < 10 THEN 'Low Discount'
        WHEN discount < 25 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS discount_category,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*) AS models_count
FROM data
GROUP BY discount_category
ORDER BY discount_category;

-- 55. Which brands dominate each price segment?
SELECT 
    price_segment,
    brand,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY price_segment), 2) AS segment_share
FROM data
GROUP BY price_segment, brand
ORDER BY price_segment, segment_share DESC;

-- 56. Which brands offer the best ratings (Average Rating + Phone Count)?
SELECT 
    brand,
    COUNT(*) AS phone_count,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(rating) * COUNT(*) / NULLIF(MAX(AVG(rating)) OVER(), 0), 2) AS rating_score
FROM data
GROUP BY brand
HAVING COUNT(*) >= 5
ORDER BY avg_rating DESC, phone_count DESC
LIMIT 10;

-- 57. Which processor family has the highest average rating?
SELECT 
    processor,
    COUNT(*) AS phone_count,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(MIN(rating), 2) AS min_rating,
    ROUND(MAX(rating), 2) AS max_rating
FROM data
GROUP BY processor
HAVING COUNT(*) >= 5
ORDER BY avg_rating DESC
LIMIT 10;

-- 58. Which processor family offers the best value (Average Price vs Average Rating)?
SELECT 
    processor,
    COUNT(*) AS phone_count,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(price) / NULLIF(AVG(rating), 0), 2) AS price_per_rating_point,
    ROUND(AVG(rating) / NULLIF(AVG(price), 0) * 1000, 2) AS value_score
FROM data
GROUP BY processor
HAVING COUNT(*) >= 5
ORDER BY price_per_rating_point ASC
LIMIT 10;

-- 59. Does paying more increase smartphone ratings?
SELECT 
    price_segment,
    COUNT(*) AS phone_count,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(MIN(rating), 2) AS min_rating,
    ROUND(MAX(rating), 2) AS max_rating,
    ROUND(AVG(rating) - LAG(AVG(rating)) OVER(ORDER BY AVG(price)), 2) AS rating_change
FROM data
GROUP BY price_segment
ORDER BY avg_price;

-- 60. Which brands provide the best value in terms of Price per GB of RAM?
SELECT 
    brand,
    COUNT(*) AS phone_count,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(ram), 2) AS avg_ram,
    ROUND(AVG(price) / NULLIF(AVG(ram), 0), 2) AS price_per_gb_ram,
    ROUND(MIN(price / NULLIF(ram, 0)), 2) AS best_price_per_gb
FROM data
GROUP BY brand
HAVING COUNT(*) >= 3
ORDER BY price_per_gb_ram ASC
LIMIT 10;

-- 61. Which brands provide the best value in terms of Price per GB of Storage?
SELECT 
    brand,
    COUNT(*) AS phone_count,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(storage), 2) AS avg_storage,
    ROUND(AVG(price) / NULLIF(AVG(storage), 0), 2) AS price_per_gb_storage,
    ROUND(MIN(price / NULLIF(storage, 0)), 2) AS best_price_per_gb
FROM data
GROUP BY brand
HAVING COUNT(*) >= 3
ORDER BY price_per_gb_storage ASC
LIMIT 10;

-- 62. Which smartphones are overpriced compared to their brand's average price?
SELECT *
FROM (
    SELECT
        name,
        brand,
        price,
        ROUND(AVG(price) OVER(PARTITION BY brand), 2) AS brand_avg_price,
        ROUND(price - AVG(price) OVER(PARTITION BY brand), 2) AS price_difference
    FROM data
) t
WHERE price > brand_avg_price
ORDER BY price_difference DESC;

-- 63. Which smartphones are underrated (high rating at a relatively low price)?
SELECT 
    name,
    brand,
    price,
    rating,
    ROUND(price / NULLIF(rating, 0), 2) AS price_per_rating,
    ROUND(price - AVG(price) OVER(PARTITION BY brand), 2) AS price_vs_brand_avg
FROM data
WHERE rating >= 4.0
ORDER BY price_per_rating ASC
LIMIT 20;

-- 64. Which brands rely on heavy discounts (Average, Median, and Maximum Discount)?
SELECT
    brand,
    ROUND(AVG(discount), 2) AS avg_discount,
    MAX(discount) AS max_discount,
    COUNT(*) AS total_models
FROM data
GROUP BY brand
ORDER BY avg_discount DESC, max_discount DESC;

-- 65. Is there a relationship between discount percentage and user ratings?
SELECT 
    CASE 
        WHEN discount < 5 THEN 'No Discount (0-5%)'
        WHEN discount < 15 THEN 'Low Discount (5-15%)'
        WHEN discount < 30 THEN 'Medium Discount (15-30%)'
        WHEN discount < 50 THEN 'High Discount (30-50%)'
        ELSE 'Very High Discount (>50%)'
    END AS discount_category,
    COUNT(*) AS phone_count,
    ROUND(AVG(discount), 2) AS avg_discount,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(MIN(rating), 2) AS min_rating,
    ROUND(MAX(rating), 2) AS max_rating,
    ROUND(AVG(price), 2) AS avg_price
FROM data
GROUP BY discount_category
ORDER BY avg_discount;

-- 66. Is there a relationship between smartphone price and review count?
SELECT 
    price_segment,
    COUNT(*) AS phone_count,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(reviews), 0) AS avg_reviews,
    ROUND(MIN(reviews), 0) AS min_reviews,
    ROUND(MAX(reviews), 0) AS max_reviews,
    ROUND(AVG(ratings), 0) AS avg_rating_count,
    ROUND(AVG(rating), 2) AS avg_rating
FROM data
GROUP BY price_segment
ORDER BY avg_price;

-- 67. What is the best-rated smartphone in each price segment?
SELECT *
FROM (
    SELECT *,
        ROW_NUMBER() OVER(PARTITION BY price_segment ORDER BY rating DESC, ratings DESC) AS rank_position
    FROM data
) ranked
WHERE rank_position = 1
ORDER BY price_segment;

-- 68. What is the market share of each smartphone brand (count and percentage)?
SELECT 
    brand,
    COUNT(*) AS phone_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS market_share_percentage,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(rating), 2) AS avg_rating
FROM data
GROUP BY brand
ORDER BY phone_count DESC;

-- 69. Which battery capacities dominate the smartphone market (count and percentage)?
SELECT 
    battery,
    COUNT(*) AS phone_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS market_share_percentage,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(ram), 2) AS avg_ram,
    ROUND(AVG(storage), 2) AS avg_storage
FROM data
GROUP BY battery
ORDER BY phone_count DESC
LIMIT 15;

