-- 1) Detalle de pedido con producto y total de línea
SELECT pd.PedidoID, pr.ProductoID, pr.Nombre AS Producto,
       pd.Cantidad, pr.Precio, (pd.Cantidad * pr.Precio) AS TotalLinea
FROM dbo.PedidoDetalle pd
INNER JOIN dbo.Productos pr ON pr.ProductoID = pd.ProductoID
ORDER BY pd.PedidoID;

-- 2) Total gastado por cliente
SELECT c.ClienteID, c.Nombre AS Cliente,
       SUM(pd.Cantidad * pr.Precio) AS MontoTotal
FROM dbo.Clientes c
INNER JOIN dbo.Pedidos p       ON p.ClienteID = c.ClienteID
INNER JOIN dbo.PedidoDetalle pd ON pd.PedidoID = p.PedidoID
INNER JOIN dbo.Productos pr     ON pr.ProductoID = pd.ProductoID
GROUP BY c.ClienteID, c.Nombre
ORDER BY MontoTotal DESC;

--3) Incluye clientes sin pedidos (Pedidos.* será NULL en esos casos)
SELECT cl.ClienteID, cl.Nombre AS Cliente, pe.PedidoID, pe.Fecha
FROM Clientes AS cl
LEFT JOIN Pedidos AS pe ON pe.ClienteID = cl.ClienteID
ORDER BY cl.ClienteID, pe.Fecha;

--4) Muestra empleados sin pedidos (campos de Pedido serán NULL)
SELECT em.EmpleadoID, em.Nombre AS Empleado, pe.PedidoID, pe.Fecha
FROM Pedidos AS pe
RIGHT JOIN Empleados AS em ON em.EmpleadoID = pe.EmpleadoID
ORDER BY em.EmpleadoID, pe.Fecha;

