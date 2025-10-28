-- 1.1
-- SELECT title_no, title FROM title;

-- 1.2
-- SELECT title FROM title WHERE title_no = 10;

-- 1.3
-- SELECT title_no, author FROM title where author IN ('Charles Dickens', 'Jane Austen');

-- 2.1
-- SELECT title_no, title FROM title WHERE  title LIKE '%adventure%';

-- 2.2
-- SELECT member_no, ISNULL(SUM(fine_paid), 0) AS sum_paid FROM loanhist WHERE YEAR(in_date) = 2001 GROUP BY member_no;

-- 2.3
-- SELECT city, state FROM adult GROUP BY city, state;

-- 2.4
-- SELECT title FROM title ORDER BY title;

-- 3.1
-- SELECT member_no, isbn, fine_assessed, 2*fine_assessed AS double_fine FROM loanhist WHERE fine_assessed IS NOT NULL;

-- 4.1
-- SELECT LOWER(firstname+middleinitial+SUBSTRING(lastname, 1, 2)) AS email_name FROM member;

-- 5.1
-- SELECT 'The title is: '+title+', title number '+CAST(title_no AS CHAR) AS description FROM title;