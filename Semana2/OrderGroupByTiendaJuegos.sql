CREATE VIEW dbo.vw_VentasDetalle AS
SELECT v.ID_Venta,
       u.Nombres      AS Cliente,
       v.Fecha,
       j.Titulo       AS Videojuego,
       j.Plataforma,
       dv.Cantidad,
       j.Precio,
       (dv.Cantidad * j.Precio) AS Subtotal
FROM dbo.Ventas v
JOIN dbo.Usuario u         ON v.ID_Usuario     = u.ID_Usuario
JOIN dbo.Detalle_ventas dv ON v.ID_Venta       = dv.ID_Venta
JOIN dbo.Videojuegos j     ON dv.ID_Videojuego = j.ID_Videojuego;
GO

-- Usos rápidos de la vista (opcional):
SELECT * 
FROM dbo.vw_VentasDetalle
ORDER BY Fecha, ID_Venta;

-- Ejemplo de total por venta (muestra que sabes agrupar, pero usando la vista):
SELECT ID_Venta, SUM(Subtotal) AS TotalVenta
FROM dbo.vw_VentasDetalle
GROUP BY ID_Venta;