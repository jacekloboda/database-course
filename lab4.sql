--SELECT sup.CompanyName, shp.CompanyName
--FROM Suppliers AS sup CROSS JOIN Shippers AS shp;

-- 1.1
--SELECT p.ProductName, p.UnitPrice, s.Address, c.CategoryName
--FROM Products AS p
--INNER JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
--INNER JOIN Categories AS c ON p.CategoryID = p.CategoryID
--WHERE p.UnitPrice BETWEEN 20 AND 30
--AND c.CategoryName = 'Meat/Poultry'
--;

-- 1.2
--SELECT p.ProductName, p.UnitPrice, s.CompanyName, c.CategoryName
--FROM Products AS p
--INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
--INNER JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
--WHERE c.CategoryName = 'Confections';

-- 1.3
--SELECT c.CompanyName, COUNT(*) AS order_count
--FROM Orders AS o
--INNER JOIN Customers AS c ON o.CustomerID = c.CustomerID
--GROUP BY c.CompanyName
--ORDER BY COUNT(*) DESC;

-- 1.4
--SELECT c.CustomerID, COUNT(*) AS order_count
--FROM Customers AS c
--INNER JOIN Orders AS o ON c.CustomerID = o.CustomerID
--WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 3
--GROUP BY c.CustomerID
--ORDER BY COUNT(*) DESC
--;

-- 2.1
--SELECT TOP 1 CompanyName, COUNT(*) AS order_count
--FROM Orders AS o
--INNER JOIN Shippers AS s ON o.ShipVia = s.ShipperID
--WHERE YEAR(o.ShippedDate) = 1997
--GROUP BY s.CompanyName
--ORDER BY COUNT(*) DESC
--;

-- 2.2
--SELECT o.OrderID, o.OrderDate, c.CompanyName, SUM(od.UnitPrice*od.Quantity*(1-od.Discount)) AS value
--FROM Orders AS o
--INNER JOIN Customers AS c ON o.CustomerID = c.CustomerID
--INNER JOIN [Order Details] AS od ON o.OrderID = od.OrderID
--GROUP BY o.OrderID, o.OrderDate, c.CompanyName
--ORDER BY value DESC
--;

-- 2.3
--SELECT o.OrderID, o.OrderDate, c.CompanyName, SUM(od.UnitPrice*od.Quantity*(1-od.Discount)+o.Freight) AS value
--FROM Orders AS o
--INNER JOIN [Order Details] AS od ON o.OrderID = od.OrderID
--INNER JOIN Customers AS c ON o.CustomerID = c.CustomerID
--GROUP BY o.OrderID, o.OrderDate, c.CompanyName
--ORDER BY value DESC
--;

-- 3.1
--SELECT DISTINCT cus.CompanyName, cus.Phone
--FROM Customers AS cus
--INNER JOIN Orders AS o ON cus.CustomerID = o.CustomerID
--INNER JOIN [Order Details] AS od ON o.OrderID = od.OrderID
--INNER JOIN Products AS p ON od.ProductID = p.ProductID
--INNER JOIN Categories AS cat ON p.CategoryID = cat.CategoryID
--WHERE cat.CategoryName = 'Confections'
--;

-- 3.2
--SELECT CustomerID, CompanyName, Phone
--FROM Customers
--WHERE CustomerID NOT IN (   SELECT DISTINCT cus.CustomerID
--                            FROM Customers AS cus
--                            INNER JOIN Orders AS o ON cus.CustomerID = o.CustomerID
--                            INNER JOIN [Order Details] AS od ON o.OrderID = od.OrderID
--                            INNER JOIN Products AS p ON od.ProductID = p.ProductID
--                            INNER JOIN Categories AS cat ON p.CategoryID = cat.CategoryID
--                            WHERE cat.CategoryName = 'Confections')
--;

-- 3.3
SELECT CustomerID, CompanyName, Phone
FROM Customers
WHERE CustomerID NOT IN (   SELECT DISTINCT cus.CustomerID
                            FROM Customers AS cus
                            INNER JOIN Orders AS o ON cus.CustomerID = o.CustomerID
                            INNER JOIN [Order Details] AS od ON o.OrderID = od.OrderID
                            INNER JOIN Products AS p ON od.ProductID = p.ProductID
                            INNER JOIN Categories AS cat ON p.CategoryID = cat.CategoryID
                            WHERE cat.CategoryName = 'Confections'
                            AND YEAR(o.OrderDate) = 1997)
;

-- 4.1
SELECT m.firstname, m.lastname, j.birth_date, a.street
FROM juvenile AS j
LEFT OUTER JOIN member AS m on j.member_no = m.member_no
INNER JOIN adult AS a ON j.adult_member_no = a.member_no
;

-- 4.2
SELECT m.firstname,
       m.lastname,
       j.birth_date,
       a.street,
       j.adult_member_no,
       m2.firstname,
       m2.lastname
FROM juvenile AS j
LEFT OUTER JOIN member AS m
    on j.member_no = m.member_no
INNER JOIN adult AS a
    ON j.adult_member_no = a.member_no
INNER JOIN member AS m2
    ON j.adult_member_no = m2.member_no
;

-- 5.1
SELECT
    e2.EmployeeID AS master,
    e1.EmployeeID AS slave
FROM Employees AS e1
INNER JOIN Employees AS e2
    ON e1.ReportsTo = e2.EmployeeID
ORDER BY e1.ReportsTo
;

-- 5.2
SELECT e2.EmployeeID
FROM Employees AS e1
RIGHT OUTER JOIN Employees AS e2
    ON e1.ReportsTo = e2.EmployeeID
WHERE e1.EmployeeID IS NULL
;

-- 5.3
SELECT DISTINCT e2.EmployeeID
FROM Employees AS e1
RIGHT OUTER JOIN Employees AS e2
    ON e1.ReportsTo = e2.EmployeeID
WHERE e1.EmployeeID IS NOT NULL
;

-- 6.1
SELECT
    a.member_no,
    a.state,
    COUNT(*) AS children_count
FROM adult AS a
INNER JOIN juvenile AS j
    ON j.adult_member_no = a.member_no
GROUP BY
    a.member_no,
    a.state
HAVING COUNT(*) > 2
AND a.state = 'AZ'
;

-- 6.2
SELECT
    a.member_no,
    a.state,
    COUNT(*) AS children_count
FROM adult AS a
INNER JOIN juvenile AS j
    ON j.adult_member_no = a.member_no
GROUP BY
    a.member_no,
    a.state
HAVING COUNT(*) > 2
AND a.state = 'AZ'
UNION
SELECT
    a.member_no,
    a.state,
    COUNT(*) AS children_count
FROM adult AS a
INNER JOIN juvenile AS j
    ON j.adult_member_no = a.member_no
GROUP BY
    a.member_no,
    a.state
HAVING COUNT(*) > 3
AND a.state = 'CA'
ORDER BY member_no
;






