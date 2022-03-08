---------------------------
--CREATING TABLES --DDL
---------------------------

--Creating users table and indexes
CREATE TABLE "users" (
   "id" SERIAL, 
   "username" VARCHAR(25) NOT NULL,
   "last_login" TIMESTAMP, 
    CONSTRAINT "users_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "users_username_length" CHECK (LENGTH("username") <=25)
);

CREATE UNIQUE INDEX ON "users" (LOWER("username"));
CREATE INDEX "users_index_username_lastlogin" ON "users" ("username", "last_login");

--Creating topic table and index
CREATE TABLE "topic" (
   "id" SERIAL,
   "topic_name" VARCHAR(30) NOT NULL,
   "topic_description" VARCHAR (500),  
    CONSTRAINT "topic_pkey" PRIMARY KEY ("id"), 
    CONSTRAINT "topic_name_length"CHECK (LENGTH("topic_name") <=30),
    CONSTRAINT "topic_description_length"CHECK (LENGTH("topic_description") <=500)
);

CREATE UNIQUE INDEX ON "topic" (LOWER("topic_name"));

--Creating posts table and indexes
CREATE TABLE "posts" (
   "id" SERIAL, 
   "title" VARCHAR(100) NOT NULL, 
   "topic_id" INT NOT NULL, 
    "user_id" INT, 
    "post_URL" VARCHAR,
    "post_text" TEXT, 
    "post_timestamp" TIMESTAMP,
    CONSTRAINT "posts_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "posts_fkey_topic" FOREIGN KEY ("topic_id") REFERENCES "topic"("id") ON DELETE CASCADE,
    CONSTRAINT "posts_fkey_user" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL,
    CONSTRAINT "posts_title_length" CHECK (LENGTH("title")<=100),
    CONSTRAINT "posts_text_URL" CHECK (("post_URL" IS NOT NULL AND "post_text" IS NULL) 
                                    OR ("post_URL" IS NULL AND "post_text" IS NOT NULL))
);

CREATE INDEX "posts_index_title" ON "posts" ("title");
CREATE INDEX "posts_index_time" ON "posts" ("post_timestamp");
CREATE INDEX "posts_index_content" ON "posts" ("post_text", "post_URL");

--Creating comments table and indexes
CREATE TABLE "comments" (
    "id" SERIAL,
    "user_id" INT,
    "post_id" INT NOT NULL,
    "parent_comment_id" INT, 
    "comment_text" TEXT NOT NULL,
    "comment_timestamp" TIMESTAMP,
     CONSTRAINT "comments_pkey" PRIMARY KEY ("id"),
     CONSTRAINT "comments_fkey_user" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL,
     CONSTRAINT "comments_fkey_posts" FOREIGN KEY ("post_id") REFERENCES "posts"("id") ON DELETE CASCADE,
     CONSTRAINT "comments_fkey_comments" FOREIGN KEY ("parent_comment_id") REFERENCES "comments" ("id") ON DELETE CASCADE
);

CREATE INDEX "comments_index_parent" ON "comments" ("parent_comment_id", "id");
CREATE INDEX "comments_index_time" ON "comments" ("id", "comment_timestamp");

-- Creating votes table and index
CREATE TABLE "votes" (
     "id" SERIAL, 
     "user_id" INT, 
     "post_id" INT NOT NULL,
      "vote" SMALLINT, 
    CONSTRAINT "votes_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "votes_fkey_user" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL,
    CONSTRAINT "votes_fkey_posts" FOREIGN KEY ("post_id") REFERENCES "posts"("id") ON DELETE CASCADE,
    CONSTRAINT "votes_limit" CHECK ("vote" = '-1' OR "vote" = '1'),
    CONSTRAINT "votes_unique" UNIQUE ("user_id", "post_id")
);

CREATE INDEX "votes_index" ON "votes" ("post_id", "vote");


----------------------------
--INSERTING DATA INTO TABLES - DML
----------------------------
--Inserting distinct usernames into users table
INSERT INTO "users" ("username")
SELECT "username"
FROM
    (SELECT DISTINCT REGEXP_SPLIT_TO_TABLE("upvotes", ',') AS "username"
    FROM bad_posts
    UNION
    SELECT DISTINCT REGEXP_SPLIT_TO_TABLE("downvotes", ',') AS "username"
    FROM bad_posts
    UNION
    SELECT DISTINCT ("username") AS "username"
    FROM bad_posts
    UNION
    SELECT DISTINCT ("username") AS "username"
    FROM bad_comments) user_table;
    
--Inserting distinct topics into topic table
INSERT INTO "topic" ("topic_name")
    (SELECT DISTINCT ("topic")
     FROM bad_posts);

--Inserting posts into post table
INSERT INTO "posts" ("id", "title", "topic_id", "user_id", "post_URL", "post_text")
   (SELECT b.id, SUBSTRING ("title" FROM 1 FOR 100), t.id AS "topic_id" ,u.id AS "user_id", b.url, b.text_content
    FROM bad_posts b
    JOIN topic t
    ON b.topic=t.topic_name
    JOIN users u
    ON b.username=u.username);

--Inserting data into comments table
INSERT INTO "comments" ("user_id", "post_id", "comment_text")
    (SELECT u.id AS user_id, p.id AS post_id, b.text_content
    FROM bad_comments b
    JOIN users u
    ON u.username=b.username
    JOIN posts p
    ON p.id=b.post_id); 
    
    
--Inserting data into votes table
INSERT INTO "votes" ("vote", "user_id", "post_id")
    SELECT 1 AS "upvotes", u.id AS "user_id", p.id AS "post_id"
    FROM 
        (SELECT REGEXP_SPLIT_TO_TABLE("upvotes", ',') AS "username" 
          FROM bad_posts) bp
    JOIN users u
    ON bp.username = u.username
    JOIN posts p
    ON p.user_id = u.id
    UNION
    SELECT -1 AS "downvotes", u.id AS "user_id", p.id AS "post_id"
    FROM 
        (SELECT REGEXP_SPLIT_TO_TABLE("downvotes", ',') AS "username" 
              FROM bad_posts) bp
    JOIN users u
    ON bp.username = u.username
    JOIN posts p
    ON p.user_id = u.id
    ON CONFLICT ON CONSTRAINT "votes_pkey" DO NOTHING;


DROP TABLE bad_comments;
DROP TABLE bad_posts; 
