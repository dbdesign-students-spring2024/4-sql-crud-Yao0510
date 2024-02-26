-- DROP TABLE restaurants;
-- DELETE FROM restaurants;
CREATE TABLE restaurants (
    RestaurantID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL,
    Category TEXT NOT NULL,
    PriceTier TEXT CHECK(PriceTier IN ('cheap', 'medium', 'expensive')) NOT NULL,
    Neighborhood TEXT NOT NULL,
    OpeningTime TEXT NOT NULL,
    ClosingTime TEXT NOT NULL,
    AverageRating REAL CHECK(
        AverageRating >= 0
        AND AverageRating <= 5
    ) NOT NULL,
    GoodForKids BOOLEAN NOT NULL
);
-- .mode csv
-- .import ./data/restaurants.csv restaurants
CREATE TABLE reviews (
    ReviewID INTEGER PRIMARY KEY AUTOINCREMENT,
    RestaurantID INTEGER,
    Rating INTEGER CHECK(
        Rating >= 1
        AND Rating <= 5
    ),
    ReviewText TEXT,
    ReviewerName TEXT,
    ReviewDate TEXT,
    FOREIGN KEY (RestaurantID) REFERENCES restaurants(RestaurantID)
);
