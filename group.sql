-- 1.1
-- SELECT OrderID, SUM(UnitPrice*Quantity*(1-Discount)) AS sum FROM [Order Details] GROUP BY OrderID ORDER BY sum DESC;

-- 1.2
-- SELECT TOP 10 OrderID, SUM(UnitPrice*Quantity*(1-Discount)) AS sum FROM [Order Details] GROUP BY OrderID ORDER BY sum DESC;

-- 2.1
-- SELECT ProductID, SUM(Quantity) AS sum FROM [Order Details] GROUP BY ProductID HAVING ProductID < 3;

-- 2.2
-- SELECT ProductID, SUM(Quantity) AS sum FROM [Order Details] GROUP BY ProductID ORDER BY ProductID;

-- 2.3
-- SELECT OrderID, SUM(UnitPrice*Quantity*(1-Discount)) AS value FROM [Order Details] GROUP BY OrderID HAVING SUM(Quantity) > 250;

-- 3.1
-- SELECT EmployeeID, COUNT(*) AS orders FROM Orders GROUP BY EmployeeID;

-- 3.2
-- SELECT ShipVia, SUM(Freight) AS sum FROM Orders GROUP BY ShipVia;

-- 3.3
-- SELECT ShipVia, SUM(Freight) AS sum FROM Orders WHERE YEAR(ShippedDate) BETWEEN 1996 AND 1997 GROUP BY ShipVia;

-- 4.1
-- SELECT EmployeeID, YEAR(OrderDate) AS year, MONTH(OrderDate) AS month, COUNT(*) AS count FROM Orders GROUP BY EmployeeID, YEAR(OrderDate), MONTH(OrderDate) WITH ROLLUP ORDER BY EmployeeID, year, month;

-- 4.2
-- SELECT CategoryID, MAX(UnitPrice) AS max_price, MIN(UnitPrice) AS min_price FROM Products GROUP BY CategoryID;