-- 1.1
SELECT od.OrderID,
       ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) + f.Freight, 2)
FROM [Order Details] od
INNER JOIN (SELECT o.OrderID,
                   o.Freight
            FROM Orders o) f
    ON od.OrderID =f.OrderID
WHERE od.OrderID = 10250
GROUP BY od.OrderID, f.Freight
;

-- 1.2
SELECT od.OrderID,
       ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount))+ f.Freight, 2) AS sum
FROM [Order Details] od
INNER JOIN (SELECT o.OrderID,
                   o.Freight
            FROM Orders o) f
    ON od.OrderID = f.OrderID
GROUP BY od.OrderID, f.Freight
ORDER BY od.OrderID
;

-- 1.3
SELECT p.ProductName,
       q1.max
FROM Products p
INNER JOIN (SELECT od.ProductID,
                   MAX(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS max
            FROM [Order Details] od
            GROUP BY od.ProductID) q1
    ON p.ProductID = q1.ProductID
ORDER BY q1.max DESC
;


-- 1.4
SELECT p.ProductName,
       ISNULL(q1.max, 0)
FROM Products p
LEFT OUTER JOIN (SELECT od.ProductID,
                   MAX(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS max
            FROM [Order Details] od
            INNER JOIN Orders o
                ON od.OrderID = o.OrderID
            WHERE YEAR(o.OrderDate) = 1997
            GROUP BY od.ProductID) q1
    ON p.ProductID = q1.ProductID
ORDER BY q1.max DESC
;

-- 2.1
WITH OrderValue AS (
    SELECT od.OrderID,
           od.Quantity * od.UnitPrice * (1 - od.Discount) AS value
    FROM [Order Details] od
),
Orders1996 AS (
    SELECT o.OrderID,
           o.CustomerID,
           SUM(ov.value) as total_value
    FROM Orders o
    INNER JOIN orderValue ov
        ON o.OrderID = ov.OrderID
    WHERE YEAR(o.OrderDate) = 1996
    GROUP BY o.OrderID, o.CustomerID
)
SELECT c.CustomerID,
       ROUND(SUM(o.total_value), 2) AS total_value
FROM Customers c
INNER JOIN Orders1996 o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY total_value DESC


-- 2.2
WITH OrderValue AS (
    SELECT od.OrderID,
           od.Quantity * od.UnitPrice * (1 - od.Discount) AS value
    FROM [Order Details] od
),
Orders1996 AS (
    SELECT o.OrderID,
           o.CustomerID,
           SUM(ov.value) + o.Freight as total_value
    FROM Orders o
    INNER JOIN OrderValue ov
        ON o.OrderID = ov.OrderID
    WHERE YEAR(o.OrderDate) = 1996
    GROUP BY o.OrderID, o.CustomerID, o.Freight
)
SELECT c.CustomerID,
       ROUND(SUM(o.total_value), 2) AS total_value
FROM Customers c
INNER JOIN Orders1996 o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY total_value DESC
;

-- 2.3
WITH OrderValue AS (
    SELECT od.OrderID,
           od.Quantity * od.UnitPrice * (1 - od.Discount) AS value
    FROM [Order Details] od
),
Orders1997 AS (
    SELECT o.OrderID,
           o.CustomerID,
           SUM(ov.value) + o.Freight as total_value
    FROM Orders o
    INNER JOIN OrderValue ov
        ON o.OrderID = ov.OrderID
    WHERE YEAR(o.OrderDate) = 1997
    GROUP BY o.OrderID, o.CustomerID, o.Freight
)
SELECT c.CustomerID,
       ROUND(MAX(o.total_value), 2) AS max_value
FROM Customers c
INNER JOIN Orders1997 o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY max_value DESC
;

-- 3.1
USE library
WITH ChildCount AS (
    SELECT j.adult_member_no,
           COUNT(*) AS juvenile_count
    FROM juvenile j
    GROUP BY j.adult_member_no
),
AdultsWithChildCount AS (
    SELECT a.member_no,
           ISNULL(c.juvenile_count, 0) AS child_count
    FROM adult a
    LEFT OUTER JOIN ChildCount c
        ON a.member_no = c.adult_member_no
)
SELECT m.firstname,
       m.lastname,
       a.child_count
FROM member m
INNER  JOIN AdultsWithChildCount a
    ON m.member_no = a.member_no
;

-- 3.2
USE library
WITH ChildCount AS (
    SELECT j.adult_member_no,
           COUNT(*) AS juvenile_count
    FROM juvenile j
    GROUP BY j.adult_member_no
),
AdultsWithChildCount AS (
    SELECT a.member_no,
           ISNULL(c.juvenile_count, 0) AS child_count
    FROM adult a
    LEFT OUTER JOIN ChildCount c
        ON a.member_no = c.adult_member_no
),
ReservationsCount AS (
    SELECT r.member_no,
           COUNT(*) AS reservation_count
    FROM reservation r
    GROUP BY r.member_no
),
AdultReservationCount AS (
    SELECT a.member_no,
           ISNULL(r.reservation_count, 0) AS reservation_count
    FROM adult a
    LEFT OUTER JOIN ReservationsCount r
        ON a.member_no = r.member_no
),
LoanCount AS (
    SELECT l.member_no,
           COUNT(*) AS loan_count
    FROM loan l
    GROUP BY member_no
),
AdultLoanCount AS (
    SELECT a.member_no,
           isnull(l.loan_count, 0) AS loan_count
    FROM adult a
    LEFT OUTER JOIN LoanCount l
        ON a.member_no = l.member_no
)
SELECT m.firstname,
       m.lastname,
       ac.child_count,
       ar.reservation_count,
       al.loan_count
FROM member m
INNER  JOIN AdultsWithChildCount ac
    ON m.member_no = ac.member_no
INNER JOIN AdultReservationCount ar
    ON m.member_no = ar.member_no
INNER JOIN AdultLoanCount al
    ON m.member_no = al.member_no
;

-- 3.3
WITH ChildCount AS (
    SELECT j.adult_member_no,
           COUNT(*) AS juvenile_count
    FROM juvenile j
    GROUP BY j.adult_member_no
),
ReservationsCount AS (
    SELECT r.member_no,
           COUNT(*) AS reservation_count
    FROM reservation r
    GROUP BY r.member_no
),
LoanCount AS (
    SELECT l.member_no,
           COUNT(*) AS loan_count
    FROM loan l
    GROUP BY member_no
),
AggregatedChildStats AS (
    SELECT j.adult_member_no,
           SUM(ISNULL(r.reservation_count, 0))AS reservation_count,
           SUM(ISNULL(l.loan_count, 0)) AS loan_count
    FROM juvenile j
    LEFT OUTER JOIN ReservationsCount r
        ON j.member_no = r.member_no
    LEFT OUTER JOIN LoanCount l
        ON j.member_no = l.member_no
    GROUP BY j.adult_member_no
)
SELECT m.firstname,
       m.lastname,
       ISNULL(c.juvenile_count, 0) AS child_count,
       ISNULL(r.reservation_count, 0) AS reservation_count,
       ISNULL(l.loan_count, 0) AS loan_count,
       ISNULL(cs.reservation_count, 0) AS child_res_count,
       ISNULL(cs.loan_count, 0) AS child_loan_count
FROM member m
INNER JOIN adult a
    ON m.member_no = a.member_no
LEFT OUTER JOIN ChildCount c
    ON m.member_no = c.adult_member_no
LEFT OUTER JOIN ReservationsCount r
    ON m.member_no = r.member_no
LEFT OUTER JOIN LoanCount l
    ON m.member_no = l.member_no
LEFT OUTER JOIN AggregatedChildStats cs
    ON m.member_no = cs.adult_member_no
;

-- 3.4
WITH Loaned2001 AS (
    SELECT l.title_no,
           COUNT(*) AS loan_count
    FROM loanhist l
    WHERE YEAR(out_date) = 2001
    GROUP BY l.title_no
)
SELECT t.title,
       ISNULL(l.loan_count, 0) AS loan_count
FROM title t
LEFT OUTER JOIN Loaned2001 l
    ON t.title_no = l.title_no
ORDER BY loan_count DESC
;

-- 3.5
WITH Loan2002 AS (
    SELECT l.title_no,
           COUNT(*) AS loan_count
    FROM loan l
    WHERE YEAR(out_date) = 2002
    GROUP BY l.title_no
),
LoanHist2002 AS (
    SELECT lh.title_no,
           COUNT(*) AS loan_count
    FROM loanhist lh
    WHERE YEAR(out_date) = 2002
    GROUP BY lh.title_no
)
SELECT t.title,
       ISNULL(l.loan_count, 0) + ISNULL(lh.loan_count, 0) AS loan_count
FROM title t
LEFT OUTER JOIN Loan2002 l
    ON t.title_no = l.title_no
LEFT OUTER JOIN LoanHist2002 lh
    ON t.title_no = lh.title_no
ORDER BY loan_count DESC
;

-- 4.1
USE Northwind
WITH Orders1997 AS (
    SELECT DISTINCT o.CustomerID
    FROM Orders o
    WHERE YEAR(o.OrderDate) = 1997
)
SELECT
    c.CompanyName,
    c.Address,
    c.City,
    c.PostalCode,
    c.Country
FROM Customers c
WHERE c.CustomerID NOT IN (SELECT o.CustomerID FROM Orders1997 o)
;

-- 4.2
WITH UntedPackageOrders1997 AS (
    SELECT DISTINCT o.CustomerID
    FROM Orders o
    INNER JOIN Shippers s
        ON o.ShipVia = s.ShipperID
    WHERE s.CompanyName = 'United Package'
    AND YEAR(o.ShippedDate) = 1997
)
SELECT c.CompanyName,
       c.Phone
FROM Customers c
WHERE c.CustomerID IN (SELECT CustomerID FROM UntedPackageOrders1997)
;

-- 4.3
WITH UntedPackageOrders1997 AS (
    SELECT DISTINCT o.CustomerID
    FROM Orders o
    INNER JOIN Shippers s
        ON o.ShipVia = s.ShipperID
    WHERE s.CompanyName = 'United Package'
    AND YEAR(o.ShippedDate) = 1997
)
SELECT c.CompanyName,
       c.Phone
FROM Customers c
WHERE c.CustomerID NOT IN (SELECT CustomerID FROM UntedPackageOrders1997)
;

-- 4.4
WITH ConfectionsOrders AS (
    SELECT DISTINCT o.CustomerID
    FROM Orders o
    INNER JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    INNER JOIN Products p
        ON od.ProductID = p.ProductID
    INNER JOIN Categories c
        ON p.CategoryID = c.CategoryID
    WHERE c.CategoryName = 'Confections'
)
SELECT c.CompanyName,
       c.Phone
FROM Customers c
WHERE c.CustomerID IN (SELECT CustomerID FROM ConfectionsOrders)
;

-- 4.5
WITH ConfectionsOrders AS (
    SELECT DISTINCT o.CustomerID
    FROM Orders o
    INNER JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    INNER JOIN Products p
        ON od.ProductID = p.ProductID
    INNER JOIN Categories c
        ON p.CategoryID = c.CategoryID
    WHERE c.CategoryName = 'Confections'
)
SELECT c.CompanyName,
       c.Phone
FROM Customers c
WHERE c.CustomerID NOT IN (SELECT CustomerID FROM ConfectionsOrders)
;

-- 4.6
WITH ConfectionsOrders AS (
    SELECT DISTINCT o.CustomerID
    FROM Orders o
    INNER JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    INNER JOIN Products p
        ON od.ProductID = p.ProductID
    INNER JOIN Categories c
        ON p.CategoryID = c.CategoryID
    WHERE c.CategoryName = 'Confections'
    AND YEAR(o.OrderDate) = 1997
)
SELECT c.CompanyName,
       c.Phone
FROM Customers c
WHERE c.CustomerID NOT IN (SELECT CustomerID FROM ConfectionsOrders)
;

-- 5.1
WITH AvgPrice AS (
    SELECT ROUND(AVG(p.UnitPrice), 2) AS avg_price
    FROM Products p
)
SELECT p.ProductID,
       p.ProductName,
       p.UnitPrice AS UnitPrice,
       (SELECT avg_price FROM AvgPrice) AS avg_price
FROM Products p
WHERE p.UnitPrice < (SELECT avg_price FROM AvgPrice)
;


