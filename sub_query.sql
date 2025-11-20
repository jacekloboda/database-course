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
SELECT c.CustomerID,
       ROUND(SUM(od.sum), 2) as sum
FROM Customers c
INNER JOIN (SELECT o.orderID,
                   o.CustomerID
            FROM Orders o
            WHERE YEAR(o.)) o
    ON c.CustomerID = o.CustomerID
INNER JOIN (SELECT od.OrderID,
                   SUM(od.Quantity * od.UnitPrice * (1 - od.Discount) ) AS sum
            FROM [Order Details] od
            GROUP BY od.OrderID) od
    ON o.OrderID = od.OrderID
GROUP BY c.CustomerID;

-- 2.2
SELECT c.CustomerID,
       ROUND(SUM(od.sum) + o.Freight, 2) as sum
FROM Customers c
INNER JOIN (SELECT o.orderID,
                   o.CustomerID,
                   o.Freight
            FROM Orders o) o
    ON c.CustomerID = o.CustomerID
INNER JOIN (SELECT od.OrderID,
                   SUM(od.Quantity * od.UnitPrice * (1 - od.Discount) ) AS sum
            FROM [Order Details] od
            GROUP BY od.OrderID) od
    ON o.OrderID = od.OrderID
GROUP BY c.CustomerID;
