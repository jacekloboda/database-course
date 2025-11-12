-- 1.1
SELECT o.OrderID,
       o.CustomerID,
       SUM(od.Quantity) as unit_sum
FROM [Order Details] AS od
INNER JOIN Orders AS o
    ON od.OrderID = o.OrderID
INNER JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
GROUP BY o.OrderID,
         o.CustomerID
ORDER BY unit_sum DESC
;

-- 1.2
SELECT o.OrderID,
       o.CustomerID,
       SUM(od.Quantity) as unit_sum
FROM [Order Details] AS od
INNER JOIN Orders AS o
    ON od.OrderID = o.OrderID
INNER JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
GROUP BY o.OrderID,
         o.CustomerID
HAVING SUM(od.Quantity) > 250
ORDER BY unit_sum DESC
;

-- 1.3
SELECT o.OrderID,
       o.CustomerID,
       SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) as total_value
FROM [Order Details] AS od
INNER JOIN Orders AS o
    ON od.OrderID = o.OrderID
INNER JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
GROUP BY o.OrderID,
         o.CustomerID
ORDER BY total_value DESC
;

-- 1.4
SELECT o.OrderID,
       o.CustomerID,
       SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) as total_value,
       SUM(od.Quantity) AS unit_sum
FROM [Order Details] AS od
INNER JOIN Orders AS o
    ON od.OrderID = o.OrderID
INNER JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
GROUP BY o.OrderID,
         o.CustomerID
HAVING SUM(od.Quantity) > 250
ORDER BY total_value DESC
;

-- 1.5
SELECT o.OrderID,
       o.CustomerID,
       e.FirstName,
       e.LastName,
       SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) as total_value,
       SUM(od.Quantity) AS unit_sum
FROM [Order Details] AS od
INNER JOIN Orders AS o
    ON od.OrderID = o.OrderID
INNER JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
INNER JOIN Employees as e
    ON o.EmployeeID = e.EmployeeID
GROUP BY o.OrderID,
         o.CustomerID,
         e.LastName,
         e.FirstName
HAVING SUM(od.Quantity) > 250
ORDER BY total_value DESC
;

-- 2.1
SELECT c.CategoryID,
       c.CategoryName,
       SUM(od.Quantity) AS total_quantity
FROM Categories AS c
INNER JOIN Products AS p
    ON c.CategoryID = p.CategoryID
INNER JOIN [Order Details] AS od
    ON od.ProductID = p.ProductID
GROUP BY c.CategoryID, c.CategoryName
;

-- 2.2
SELECT c.CategoryID,
       c.CategoryName,
       ROUND(SUM(od.Quantity*od.UnitPrice*(1-od.Discount)), 2) AS total_value
FROM Categories AS c
INNER JOIN Products AS p
    ON c.CategoryID = p.CategoryID
INNER JOIN [Order Details] AS od
    ON od.ProductID = p.ProductID
GROUP BY c.CategoryID, c.CategoryName
;

-- 2.3a
SELECT c.CategoryID,
       c.CategoryName,
       ROUND(SUM(od.Quantity*od.UnitPrice*(1-od.Discount)), 2) AS total_value
FROM Categories AS c
INNER JOIN Products AS p
    ON c.CategoryID = p.CategoryID
INNER JOIN [Order Details] AS od
    ON od.ProductID = p.ProductID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY total_value DESC
;

-- 2.3b
SELECT c.CategoryID,
       c.CategoryName,
       ROUND(SUM(od.Quantity*od.UnitPrice*(1-od.Discount)), 2) AS total_value,
       SUM(od.Quantity) AS total_quantity
FROM Categories AS c
INNER JOIN Products AS p
    ON c.CategoryID = p.CategoryID
INNER JOIN [Order Details] AS od
    ON od.ProductID = p.ProductID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY SUM(od.Quantity) DESC
;

-- 2.4
SELECT o.OrderID,
       ROUND(SUM(od.Quantity*od.UnitPrice*(1-od.Discount)+o.Freight), 2) AS total_value
FROM [Order Details] AS od
INNER JOIN Orders AS o
    ON od.OrderID = o.OrderID
GROUP BY o.OrderID
ORDER BY total_value DESC
;

-- 3.1
SELECT s.ShipperID,
       s.CompanyName,
       COUNT(*) AS order_count
FROM Orders AS o
INNER JOIN Shippers AS s
    ON o.ShipVia = s.ShipperID
WHERE YEAR(o.ShippedDate) = 1997
GROUP BY s.ShipperID,
         s.CompanyName
;

-- 3.2
SELECT TOP 1 s.ShipperID,
       s.CompanyName,
       COUNT(*) AS order_count
FROM Orders AS o
INNER JOIN Shippers AS s
    ON o.ShipVia = s.ShipperID
WHERE YEAR(o.ShippedDate) = 1997
GROUP BY s.ShipperID,
         s.CompanyName
ORDER BY order_count DESC
;

-- 3.3
SELECT e.EmployeeID,
       e.FirstName,
       e.LastName,
       ROUND(SUM(od.Quantity*od.UnitPrice*(1-od.Discount)), 2) AS total_value
FROM Employees AS e
INNER JOIN Orders AS o
    ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID,
         e.FirstName,
         e.LastName
ORDER BY total_value DESC
;

-- 3.4
SELECT TOP 1 e.EmployeeID,
       e.FirstName,
       e.LastName,
       COUNT(*) AS total_orders
FROM Employees AS e
INNER JOIN Orders AS o
    ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
WHERE YEAR(o.ShippedDate) = 1997
GROUP BY e.EmployeeID,
         e.FirstName,
         e.LastName
ORDER BY total_orders DESC
;

-- 3.5
SELECT TOP 1 e.EmployeeID,
       e.FirstName,
       e.LastName,
       ROUND(SUM(od.Quantity*od.UnitPrice*(1-od.Discount)), 2) AS total_value
FROM Employees AS e
INNER JOIN Orders AS o
    ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
WHERE YEAR(o.ShippedDate) = 1997
GROUP BY e.EmployeeID,
         e.FirstName,
         e.LastName
ORDER BY total_value DESC
;

-- 4.1a
SELECT e.EmployeeID,
       e.FirstName,
       e.LastName,
       ROUND(SUM(od.Quantity*od.UnitPrice*(1-od.Discount)), 2) AS total_value
FROM Employees AS e
INNER JOIN Orders AS o
    ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
WHERE e.EmployeeID IN ( SELECT DISTINCT e1.EmployeeID
                        FROM Employees AS e1
                        LEFT OUTER JOIN Employees AS e2
                            ON e2.ReportsTo = e1.EmployeeID
                        WHERE e2.EmployeeID IS NOT NULL)
GROUP BY e.EmployeeID,
         e.FirstName,
         e.LastName
ORDER BY total_value DESC
;


-- 4.1b
SELECT e.EmployeeID,
       e.FirstName,
       e.LastName,
       ROUND(SUM(od.Quantity*od.UnitPrice*(1-od.Discount)), 2) AS total_value
FROM Employees AS e
INNER JOIN Orders AS o
    ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od
    ON o.OrderID = od.OrderID
WHERE e.EmployeeID NOT IN ( SELECT DISTINCT e1.EmployeeID
                            FROM Employees AS e1
                            LEFT OUTER JOIN Employees AS e2
                                ON e2.ReportsTo = e1.EmployeeID
                            WHERE e2.EmployeeID IS NOT NULL)
GROUP BY e.EmployeeID,
         e.FirstName,
         e.LastName
ORDER BY total_value DESC
;

