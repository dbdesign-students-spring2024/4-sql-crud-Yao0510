-- 1. Register a new User.
INSERT INTO users (Email, Password, Handle) VALUES ('user@example.com', 'password123', 'user_handle');

-- 2. Create a new Message sent by a particular User to a particular User
INSERT INTO posts (UserID, PostType, Content, RecipientID, Visible, Timestamp) VALUES (1, 'Message', 'Hello!', 2, 1, datetime('now'));

-- 3. Create a new Story by a particular User
INSERT INTO posts (UserID, PostType, Content, Visible, Timestamp) VALUES (1, 'Story', 'Check out my new story!', 1, datetime('now'));

-- 4. Show the 10 most recent visible Messages and Stories, in order of recency.
SELECT * FROM posts WHERE Visible = 1 ORDER BY Timestamp DESC LIMIT 10;

-- 5. Show the 10 most recent visible Messages sent by a particular User to a particular User, in order of recency.
SELECT * FROM posts WHERE UserID = 1 AND RecipientID = 2 AND PostType = 'Message' AND Visible = 1 ORDER BY Timestamp DESC LIMIT 10;

-- 6. Make all Stories that are more than 24 hours old invisible.
UPDATE posts SET Visible = 0 WHERE PostType = 'Story' AND ROUND((JULIANDAY('now') - JULIANDAY(Timestamp)) * 24) > 24;

-- 7. Show all invisible Messages and Stories, in order of recency.
SELECT * FROM posts WHERE Visible = 0 ORDER BY Timestamp DESC;

-- 8. Show the number of posts by each User.
SELECT UserID, COUNT(*) as PostCount FROM posts GROUP BY UserID;

-- 9. Show the post text and email address of all posts and the User who made them within the last 24 hours.
SELECT p.Content, u.Email FROM posts p JOIN users u ON p.UserID = u.UserID WHERE ROUND((JULIANDAY('now') - JULIANDAY(p.Timestamp)) * 24) <= 24;

-- 10. Show the email addresses of all Users who have not posted anything yet.
SELECT Email FROM users WHERE UserID NOT IN (SELECT DISTINCT UserID FROM posts);
