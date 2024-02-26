# SQL CRUD

## Part 1

### Table Creation

1. Create the `restaurants` table.

```sql
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
```

2. Create the `reviews` table.

```sql
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
```

### Practice Data

1. Generate dummy data and save as a CSV file named [restaurants.csv](./data/restaurants.csv) in the `data` directory. 
2. Write the SQLite commands necessary to import the data.

```sql
.mode csv
.import data/restaurants.csv restaurants
```

### Queries

1. Find all cheap restaurants in a particular neighborhood (Brooklyn).

```sql
SELECT *
FROM restaurants
WHERE PriceTier = 'cheap'
    AND Neighborhood = 'Brooklyn';
```

2. Find all restaurants in a particular genre (Italian) with 3 stars or more, ordered by the number of stars in descending order

```sql
SELECT *
FROM restaurants
WHERE Category = 'Italian'
    AND AverageRating >= 3
ORDER BY AverageRating DESC;
```

3. Find all restaurants that are open now

```sql
SELECT *
FROM restaurants
WHERE strftime('%H:%M', 'now', 'localtime') BETWEEN OpeningTime AND ClosingTime;
```

4. Leave a review for a restaurant.

```sql
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
```

5. Delete all restaurants that are not good for kids

```sql
DELETE FROM restaurants
WHERE GoodForKids = 0;
```

6. Find the number of restaurants in each NYC neighborhood

```sql
SELECT Neighborhood,
    COUNT(*) AS NumberOfRestaurants
FROM restaurants
GROUP BY Neighborhood;
```

## Part 2

### Table Creation

1. Create the `users` table.

```sql
CREATE TABLE users (
    UserID INTEGER PRIMARY KEY AUTOINCREMENT,
    Email TEXT UNIQUE NOT NULL,
    Password TEXT NOT NULL,
    Handle TEXT UNIQUE NOT NULL
);
```

2. Create the `posts` table.

```sql
CREATE TABLE posts (
    PostID INTEGER PRIMARY KEY AUTOINCREMENT,
    UserID INTEGER NOT NULL,
    PostType TEXT CHECK(PostType IN ('Message', 'Story')) NOT NULL,
    Content TEXT NOT NULL,
    RecipientID INTEGER,
    Visible BOOLEAN NOT NULL,
    Timestamp TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (UserID) REFERENCES users(UserID),
    FOREIGN KEY (RecipientID) REFERENCES users(UserID)
);
```

### Practice Data

1. Generate dummy data for both `users` and `posts` tables and save as CSV files named [users.csv](./data/users.csv) and [posts.csv](./data/posts.csv) in the `data` directory.
2. Write the SQLite commands necessary to import the data.

```sql
.mode csv
.import ./data/users.csv users
.import ./data/posts.csv posts
```

### Queries

1. Register a new User.

```sql
INSERT INTO users (Email, Password, Handle)
VALUES ('user@example.com', 'password123', 'user_handle');
```

2. Create a new Message sent by a particular User to a particular User

```sql
INSERT INTO posts (
        UserID,
        PostType,
        Content,
        RecipientID,
        Visible,
        Timestamp
    )
VALUES (1, 'Message', 'Hello!', 2, 1, datetime('now'));
```

3. Create a new Story by a particular User

```sql
INSERT INTO posts (UserID, PostType, Content, Visible, Timestamp)
VALUES (
        1,
        'Story',
        'Check out my new story!',
        1,
        datetime('now')
    );
```

4. Show the 10 most recent visible Messages and Stories, in order of recency.

```sql
SELECT *
FROM posts
WHERE Visible = 1
ORDER BY Timestamp DESC
LIMIT 10;
```

5. Show the 10 most recent visible Messages sent by a particular User to a particular User, in order of recency.

```sql
SELECT *
FROM posts
WHERE UserID = 1
    AND RecipientID = 2
    AND PostType = 'Message'
    AND Visible = 1
ORDER BY Timestamp DESC
LIMIT 10;
```

6. Make all Stories that are more than 24 hours old invisible.

```sql
UPDATE posts
SET Visible = 0
WHERE PostType = 'Story'
    AND ROUND((JULIANDAY('now') - JULIANDAY(Timestamp)) * 24) > 24;
```

7. Show all invisible Messages and Stories, in order of recency.

```sql
SELECT *
FROM posts
WHERE Visible = 0
ORDER BY Timestamp DESC;
```

8. Show the number of posts by each User.

```sql
SELECT UserID,
    COUNT(*) as PostCount
FROM posts
GROUP BY UserID;
```

9. Show the post text and email address of all posts and the User who made them within the last 24 hours.

```sql
SELECT p.Content, u.Email
FROM posts p
    JOIN users u ON p.UserID = u.UserID
WHERE ROUND((JULIANDAY('now') - JULIANDAY(p.Timestamp)) * 24) <= 24;
```

10. Show the email addresses of all Users who have not posted anything yet.

```sql
SELECT Email
FROM users
WHERE UserID NOT IN (
        SELECT DISTINCT UserID
        FROM posts
    );
```
