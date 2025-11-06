CREATE FUNCTION dbo.TotalPedido (@PedidoID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2);
    SELECT @Total = SUM(p.Precio * d.Cantidad)
    FROM PedidoDetalle d
    JOIN Productos p ON d.ProductoID = p.ProductoID
    WHERE d.PedidoID = @PedidoID;

    RETURN @Total;
END;

SELECT dbo.TotalPedido(2) AS TotalDelPedido1;
