/***************************************************************************************************
Join de tablas
***************************************************************************************************/
USE Northwind
GO

/* Consuta interna: INNER JOIN
******************************************************/
SELECT p.ProductName, c.CategoryName
FROM Products AS p
	INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
GO


/* Consulta externa: LFET JOIN  o LEFT OUTER JOIN
******************************************************/
SELECT c.CategoryName, p.ProductName 
FROM Categories AS c
	LEFT JOIN Products AS p ON(c.CategoryID = p.CategoryID)
GO

/* Consulta externa: RIGHT JOIN o RIGHT OUTER JOIN
******************************************************/
SELECT c.CategoryName, p.ProductName 
FROM Categories AS c
	RIGHT JOIN Products AS p ON(c.CategoryID = p.CategoryID)
GO

/* FULL JOIN
******************************************************/
SELECT c.CategoryName, p.ProductName 
FROM Categories AS c
	FULL JOIN Products AS p ON(c.CategoryID = p.CategoryID)
GO