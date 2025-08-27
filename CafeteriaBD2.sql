CREATE DATABASE CafeteriaDB;
USE CafeteriaDB;
--Creando Tablas
CREATE TABLE Categorias (
    CategoriaID INT IDENTITY PRIMARY KEY,
    Nombre      NVARCHAR(80) NOT NULL UNIQUE
);
CREATE TABLE Productos (
    ProductoID  INT IDENTITY PRIMARY KEY,
    Nombre      NVARCHAR(100) NOT NULL,
    Precio      DECIMAL(10,2) NOT NULL,
    CategoriaID INT NOT NULL,
    CONSTRAINT FK_Productos_Categorias
        FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID)
);
CREATE TABLE Clientes (
    ClienteID INT IDENTITY PRIMARY KEY,
    Nombre    NVARCHAR(100) NOT NULL,
    Email     NVARCHAR(100) NULL
);
CREATE TABLE Empleados (
    EmpleadoID          INT IDENTITY PRIMARY KEY,
    Nombre              NVARCHAR(100) NOT NULL,
    FechaContratacion   DATE NULL,        -- NULL para ejemplos de IS NULL
    Salario             DECIMAL(10,2) NULL
);
CREATE TABLE Pedidos (
    PedidoID  INT IDENTITY PRIMARY KEY,
    ClienteID INT NOT NULL,
    EmpleadoID INT NULL,
    Fecha     DATE NOT NULL,
    CONSTRAINT FK_Pedidos_Clientes  FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID),
    CONSTRAINT FK_Pedidos_Empleados FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID)
);
CREATE TABLE PedidoDetalle (
    DetalleID  INT IDENTITY PRIMARY KEY,
    PedidoID   INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad   INT NOT NULL,
    CONSTRAINT FK_Detalle_Pedidos    FOREIGN KEY (PedidoID)   REFERENCES Pedidos(PedidoID),
    CONSTRAINT FK_Detalle_Productos  FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);
--Insertando Datos
INSERT INTO Categorias (Nombre) VALUES ('Bebidas'), ('Pastelería'), ('Snacks');
INSERT INTO Productos (Nombre, Precio, CategoriaID) VALUES
('Café Americano', 8.50, 1),
('Capuchino',      12.00, 1),
('Té Verde',        7.00, 1),
('Croissant',       6.50, 2),
('Brownie',         9.00, 2),
('Chips de Papa',   5.50, 3);
INSERT INTO Clientes (Nombre, Email) VALUES
('Juan Pérez',  'juan.perez@gmail.com'),
('Ana Torres',  'ana.torres@gmail.com'),
('Luis Gómez',  NULL);  -- email nulo a propósito
INSERT INTO Empleados (Nombre, FechaContratacion, Salario) VALUES
('Lucía Ramos', '2024-02-10', 4200.00),
('Marco Díaz',  NULL,          3600.00),  
('Sofía Vega',  '2023-11-05',  NULL);     
INSERT INTO Pedidos (ClienteID, EmpleadoID, Fecha) VALUES
(1, 1, '2025-08-20'),
(2, 2, '2025-08-21'),
(1, 1, '2025-08-22');
INSERT INTO PedidoDetalle (PedidoID, ProductoID, Cantidad) VALUES
(1, 1, 2),   -- 2 Americanos
(1, 4, 1),   -- 1 Croissant
(2, 2, 1),   -- 1 Capuchino
(3, 3, 2);   -- 2 Tés verdes
--Aplicando consultas
-- SELECT básico + ORDER BY
SELECT ProductoID, Nombre, Precio
FROM Productos
ORDER BY Precio DESC;

-- INNER JOIN: detalle de pedidos con cliente y producto
SELECT c.Nombre AS Cliente, p.PedidoID, p.Fecha,
       pr.Nombre AS Producto, d.Cantidad, (d.Cantidad * pr.Precio) AS TotalLinea
FROM PedidoDetalle d
INNER JOIN Pedidos   p  ON d.PedidoID = p.PedidoID
INNER JOIN Clientes  c  ON p.ClienteID = c.ClienteID
INNER JOIN Productos pr ON d.ProductoID = pr.ProductoID;

-- WHERE + LIKE: clientes cuyo nombre empieza con 'A'
SELECT * FROM Clientes
WHERE Nombre LIKE 'A%';

-- WHERE + IN: productos que pertenecen a Bebidas o Pastelería (categorías 1 y 2)
SELECT Nombre, Precio FROM Productos
WHERE CategoriaID IN (1, 2);

-- WHERE + BETWEEN: productos con precio entre 7 y 10
SELECT Nombre, Precio FROM Productos
WHERE Precio BETWEEN 7 AND 10;

-- IS NULL: empleados sin fecha de contratación registrada
SELECT * FROM Empleados
WHERE FechaContratacion IS NULL;

-- Lógica de Tres Valores (TRUE / FALSE / UNKNOWN):
-- si Salario es NULL, 'Salario > 3000' resulta UNKNOWN; por eso se usa OR IS NULL.
SELECT Nombre, Salario
FROM Empleados
WHERE Salario > 3000 OR Salario IS NULL;

-- Funciones de grupo + GROUP BY
-- total de productos por categoría y precio promedio
SELECT c.Nombre AS Categoria,
       COUNT(*)       AS NumeroProductos,
       AVG(p.Precio)  AS PrecioPromedio
FROM Productos p
INNER JOIN Categorias c ON p.CategoriaID = c.CategoriaID
GROUP BY c.Nombre;

-- HAVING: solo categorías con más de 2 productos
SELECT c.Nombre AS Categoria, COUNT(*) AS NumeroProductos
FROM Productos p
INNER JOIN Categorias c ON p.CategoriaID = c.CategoriaID
GROUP BY c.Nombre
HAVING COUNT(*) > 2;

-- CASE: clasificación de precios
SELECT Nombre,
       Precio,
       CASE
         WHEN Precio < 7 THEN 'Barato'
         WHEN Precio BETWEEN 7 AND 10 THEN 'Medio'
         ELSE 'Caro'
       END AS RangoPrecio
FROM Productos;

-- Otro CASE con salarios (incluye NULL explícitamente)
SELECT Nombre,
       COALESCE(CONVERT(NVARCHAR(20), Salario), 'Sin dato') AS SalarioMostrar,
       CASE
         WHEN Salario IS NULL           THEN 'No registrado'
         WHEN Salario < 3800            THEN 'Bajo'
         WHEN Salario BETWEEN 3800 AND 4500 THEN 'Medio'
         ELSE 'Alto'
       END AS NivelSalarial
FROM Empleados;
