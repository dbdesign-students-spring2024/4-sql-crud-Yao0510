CREATE TABLE users (
    UserID INTEGER PRIMARY KEY AUTOINCREMENT,
    Email TEXT UNIQUE NOT NULL,
    Password TEXT NOT NULL,
    Handle TEXT UNIQUE NOT NULL
);

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

-- .mode csv
-- .import ./data/users.csv users
-- .import ./data/posts.csv posts
