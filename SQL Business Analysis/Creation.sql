CREATE TABLE data (
    id SERIAL PRIMARY KEY,
    Name TEXT NOT NULL,
    Brand TEXT NOT NULL,
    Price INTEGER,
    MRP INTEGER,
    Discount INTEGER,
    Rating DECIMAL(3, 2),
    Ratings INTEGER,
    Reviews INTEGER,
    RAM INTEGER,
    Storage INTEGER,
    Display TEXT,
    Camera TEXT,
    Battery INTEGER,
    Processor TEXT,
    "Product URL" TEXT,
    "Image URL" TEXT
);

SELECT * FROM data;

SELECT COUNT(*) FROM data;

