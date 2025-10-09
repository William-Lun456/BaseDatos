-- 1) Cliente y sus pedidos (uno a muchos: Clientes -> Pedidos)
SELECT c.ClienteID, c.Nombre AS Cliente, p.PedidoID, p.Fecha
FROM dbo.Clientes c
INNER JOIN dbo.Pedidos p ON p.ClienteID = c.ClienteID
ORDER BY c.ClienteID, p.Fecha;

-- 2) Detalle de pedido con producto y total de línea
SELECT pd.PedidoID, pr.ProductoID, pr.Nombre AS Producto,
       pd.Cantidad, pr.Precio, (pd.Cantidad * pr.Precio) AS TotalLinea
FROM dbo.PedidoDetalle pd
INNER JOIN dbo.Productos pr ON pr.ProductoID = pd.ProductoID
ORDER BY pd.PedidoID;

-- 3) Total gastado por cliente
SELECT c.ClienteID, c.Nombre AS Cliente,
       SUM(pd.Cantidad * pr.Precio) AS MontoTotal
FROM dbo.Clientes c
INNER JOIN dbo.Pedidos p       ON p.ClienteID = c.ClienteID
INNER JOIN dbo.PedidoDetalle pd ON pd.PedidoID = p.PedidoID
INNER JOIN dbo.Productos pr     ON pr.ProductoID = pd.ProductoID
GROUP BY c.ClienteID, c.Nombre
ORDER BY MontoTotal DESC;
