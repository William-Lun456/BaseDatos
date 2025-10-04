USE CafeteriaBD7;
GO
IF OBJECT_ID('dbo.HistorialPrecios','U') IS NULL
BEGIN
    CREATE TABLE dbo.HistorialPrecios (
        HistorialID     INT IDENTITY PRIMARY KEY,
        ProductoID      INT NOT NULL,
        PrecioAnterior  DECIMAL(10,2) NOT NULL,
        PrecioNuevo     DECIMAL(10,2) NOT NULL,
        FechaCambio     DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),
        Motivo          NVARCHAR(200)  NULL,
        CONSTRAINT FK_Historial_Productos
            FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
    );
END
GO
USE CafeteriaBD7;
GO
CREATE OR ALTER PROCEDURE dbo.sp_AplicarDescuentoCategoria
    @CategoriaID         INT,
    @PorcentajeDescuento DECIMAL(5,4),   -- ej: 0.10 para 10%
    @Motivo              NVARCHAR(200) = NULL,
    @ProductosAfectados  INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRAN;

        -- 1) Validaciones
        IF NOT EXISTS (SELECT 1 FROM Categorias WHERE CategoriaID = @CategoriaID)
            THROW 60001, 'La categoría no existe.', 1;

        IF @PorcentajeDescuento IS NULL OR @PorcentajeDescuento <= 0 OR @PorcentajeDescuento >= 0.90
            THROW 60002, 'El porcentaje de descuento debe ser > 0 y < 0.90.', 1;

        IF NOT EXISTS (SELECT 1 FROM Productos WHERE CategoriaID = @CategoriaID)
            THROW 60003, 'No hay productos en la categoría indicada.', 1;

        -- 2) Capturar precios actuales en una tabla temporal para registrar historial
        IF OBJECT_ID('tempdb..#Antes') IS NOT NULL DROP TABLE #Antes;
        CREATE TABLE #Antes(
            ProductoID     INT PRIMARY KEY,
            PrecioAnterior DECIMAL(10,2)
        );

        INSERT INTO #Antes(ProductoID, PrecioAnterior)
        SELECT ProductoID, Precio
        FROM Productos
        WHERE CategoriaID = @CategoriaID;

        -- 3) Actualizar precios
        UPDATE p
        SET p.Precio = ROUND(p.Precio * (1 - @PorcentajeDescuento), 2)
        FROM Productos p
        WHERE p.CategoriaID = @CategoriaID;

        SET @ProductosAfectados = @@ROWCOUNT;

        -- 4) Registrar historial producto por producto
        INSERT INTO dbo.HistorialPrecios(ProductoID, PrecioAnterior, PrecioNuevo, Motivo)
        SELECT a.ProductoID,
               a.PrecioAnterior,
               p.Precio,
               COALESCE(@Motivo, CONCAT(N'Descuento del ', CAST(@PorcentajeDescuento*100 AS NVARCHAR(10)), N'% aplicado por categoría'))
        FROM #Antes a
        JOIN Productos p ON p.ProductoID = a.ProductoID;

        COMMIT TRAN;

        -- 5) Devolver resumen de lo afectado (opcional: resultset)
        SELECT p.ProductoID, p.Nombre, a.PrecioAnterior, p.Precio AS PrecioNuevo
        FROM #Antes a
        JOIN Productos p ON p.ProductoID = a.ProductoID
        ORDER BY p.Nombre;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRAN;

        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(),
                @ErrSev INT=ERROR_SEVERITY(),
                @ErrSt  INT=ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSev, @ErrSt);
        RETURN;
    END CATCH
END;
GO

DECLARE @Afectados INT;

EXEC dbo.sp_AplicarDescuentoCategoria
     @CategoriaID = 2,             -- 1=Bebidas, 2=Pastelería, 3=Snacks (según tus inserts)
     @PorcentajeDescuento = 0.15,  -- 15% de descuento
     @Motivo = N'Promo Pastelería agosto',
     @ProductosAfectados = @Afectados OUTPUT;

SELECT @Afectados AS ProductosActualizados;

-- Ver el historial reciente
SELECT TOP 20 *
FROM dbo.HistorialPrecios
ORDER BY HistorialID DESC;
