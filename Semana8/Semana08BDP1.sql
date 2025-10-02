USE CafeteriaBD7;
GO
CREATE OR ALTER PROCEDURE dbo.sp_TotalPedido
    @PedidoID INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;             -- Si ocurre un error “grave”, aborta la transacción automáticamente

    BEGIN TRY
        BEGIN TRANSACTION;         -- 

        -- Validaciones simples
        IF NOT EXISTS (SELECT 1 FROM Pedidos WHERE PedidoID = @PedidoID)
            THROW 50001, 'El pedido no existe.', 1;

        IF NOT EXISTS (SELECT 1 FROM PedidoDetalle WHERE PedidoID = @PedidoID)
            THROW 50002, 'El pedido no tiene detalles.', 1;

        -- 1) Detalle del pedido 
        SELECT 
            pr.Nombre       AS Producto,
            d.Cantidad,
            pr.Precio,
            CAST(d.Cantidad * pr.Precio AS DECIMAL(10,2)) AS Importe
        FROM PedidoDetalle d
        JOIN Productos pr ON pr.ProductoID = d.ProductoID
        WHERE d.PedidoID = @PedidoID;

        -- 2) Total del pedido
        SELECT 
            @PedidoID AS PedidoID,
            CAST(SUM(d.Cantidad * pr.Precio) AS DECIMAL(10,2)) AS TotalPedido
        FROM PedidoDetalle d
        JOIN Productos pr ON pr.ProductoID = d.ProductoID
        WHERE d.PedidoID = @PedidoID;

        COMMIT TRANSACTION;        -- confirma
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0       -- Si la transacción sigue viva, revertir
            ROLLBACK TRANSACTION;  -- deshacer cambios
        THROW;                     -- Re-lanzar el error para verlo en el cliente
    END CATCH
END
GO
EXEC dbo.sp_TotalPedido @PedidoID = 1;
