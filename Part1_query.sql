-- 1. Find all cheap restaurants in a particular neighborhood
SELECT *
FROM restaurants
WHERE PriceTier = 'cheap'
	AND Neighborhood = 'Brooklyn';
-- 2. Find all restaurants in a particular genre with 3 stars or more, ordered by the number of stars in descending order
SELECT *
FROM restaurants
WHERE Category = 'Italian'
	AND AverageRating >= 3
ORDER BY AverageRating DESC;
-- 3. Find all restaurants that are open now
SELECT *
FROM restaurants
WHERE strftime('%H:%M', 'now', 'localtime') BETWEEN OpeningTime AND ClosingTime;
-- 4. Leave a review for a restaurant
INSERT INTO reviews (
		RestaurantID,
		Rating,
		ReviewText,
		ReviewerName,
		ReviewDate
	)
VALUES (
		1,
		5,
		'Great food and atmosphere!',
		'John Doe',
		'2024-02-26'
	);
-- 5. Delete all restaurants that are not good for kids
DELETE FROM restaurants
WHERE GoodForKids = 0;
-- 6. Find the number of restaurants in each NYC neighborhood
SELECT Neighborhood,
	COUNT(*) AS NumberOfRestaurants
FROM restaurants
GROUP BY Neighborhood;
