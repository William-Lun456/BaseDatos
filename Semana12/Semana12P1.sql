-- 1) Pedidos de AGOSTO 2025 (con YEAR/MONTH)
SELECT *
FROM dbo.Pedidos
WHERE YEAR(Fecha) = 2025 AND MONTH(Fecha) = 8;

-- 2) Cantidad de pedidos por cliente en AGOSTO 2025 (y al menos 2)
SELECT ClienteID, COUNT(*) AS Pedidos
FROM dbo.Pedidos
WHERE Fecha >= '2025-08-01' AND Fecha < '2025-09-01'
GROUP BY ClienteID
HAVING COUNT(*) >= 2;

-- 3) Última fecha de pedido por cliente (MAX + GROUP BY)
SELECT ClienteID, MAX(Fecha) AS UltimoPedido
FROM dbo.Pedidos
GROUP BY ClienteID;
