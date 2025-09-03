create database CafeteriaBD;
use CafeteriaBD;
--Creando Tablas
create table Categorias (
    CategoriaID int identity primary key,
    Nombre      nvarchar(80) not null unique
);
create table Productos (
    ProductoID  int identity primary key,
    Nombre      nvarchar(100) not null,
    Precio      decimal(10,2) not null,
    CategoriaID int not null,
    constraint FK_Productos_Categorias
        foreign key(CategoriaID) references Categorias(CategoriaID)
);
create table Clientes (
    ClienteID int identity primary key,
    Nombre    nvarchar(100) not null,
    Email     nvarchar(100) null
);
create table Empleados (
    EmpleadoID          int identity primary key,
    Nombre              nvarchar(100) not null,
    FechaContratacion   date null,        -- NULL para ejemplos de IS NULL
    Salario             decimal(10,2) NULL
);
create table Pedidos (
    PedidoID  int identity primary key,
    ClienteID int not null,
    EmpleadoID int null,
    Fecha     date not null,
    constraint FK_Pedidos_Clientes  foreign key(ClienteID) references Clientes(ClienteID),
    constraint FK_Pedidos_Empleados foreign key(EmpleadoID) references Empleados(EmpleadoID)
);
create table PedidoDetalle (
    DetalleID  int identity primary key,
    PedidoID   int not null,
    ProductoID int not null,
    Cantidad   int not null,
    constraint FK_Detalle_Pedidos    foreign key (PedidoID)   references Pedidos(PedidoID),
    constraint FK_Detalle_Productos  foreign key (ProductoID) references Productos(ProductoID)
);
--Insertando Datos
insert into Categorias (Nombre) values('Bebidas'), ('Pasteler�a'), ('Snacks');
insert into Productos (Nombre, Precio, CategoriaID) values
('Caf� Americano', 8.50, 1),
('Capuchino',      12.00, 1),
('T� Verde',        7.00, 1),
('Croissant',       6.50, 2),
('Brownie',         9.00, 2),
('Papitas fritas',   5.50, 3);
insert into Clientes (Nombre, Email) values
('Juan Antoni',  'antonjuan@gmail.com'),
('Nathaly Aracely','natRamos@gmail.com'),
('Lucia Gomez','lucyg123@gmail.com'),
('Leydy Guadalupe',  'leydlupe@gmail.com'),
('Luis Miguel',  NULL);  -- email nulo a prop�sito
insert into Empleados (Nombre, FechaContratacion, Salario) values
('Luc�a Ramos', '2024-02-10', 4200.00),
('Marco D�az',  NULL,          3600.00),  
('Omar Antonio','2022-06-11',3000.00),
('Sof�a Villanueva',  '2023-11-05',  3700.00);     
-- m�s pedidos
INSERT INTO Pedidos (ClienteID, EmpleadoID, Fecha) VALUES
(1,1,'2025-08-20'),
(2,2,'2025-08-21'),
(1,1,'2025-08-12'),
(3,4,'2025-08-15'),
(5,3,'2025-07-29'),
(4,2,'2025-07-20'),
(2,4,'2025-08-05');

INSERT INTO PedidoDetalle (PedidoID, ProductoID, Cantidad) VALUES
(1, 1, 2),   -- 2 Americanos
(1, 4, 1),   -- 1 Croissant
(2, 2, 1),   -- 1 Capuchino
(3, 3, 2),   -- 2 T�s verdes
(4, 5, 3),   -- 3 Brownie
(4, 1, 1),   -- 1 Americano
(5, 4, 3),   -- 3 Croissant
(6, 6, 2),   -- 2 Papitas Fritas
(7, 3, 2);   -- 2 Tes verdes

--Aplicando consultas
-- SELECT b�sico + ORDER BY
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

-- WHERE + LIKE: clientes cuyo nombre empieza con 'l'
SELECT * FROM Clientes
WHERE Nombre LIKE 'L%';

-- WHERE + IN: productos que pertenecen a Bebidas o Pasteler�a (categor�as 1 y 2)
SELECT Nombre, Precio FROM Productos
WHERE CategoriaID IN (1, 2);

-- WHERE + BETWEEN: productos con precio entre 7 y 10
SELECT Nombre, Precio FROM Productos
WHERE Precio BETWEEN 7 AND 10;

-- IS NULL: empleados sin fecha de contrataci�n registrada
SELECT * FROM Empleados
WHERE FechaContratacion IS NULL;

-- L�gica de Tres Valores (TRUE / FALSE / UNKNOWN):
-- si Salario es NULL, 'Salario > 3000' resulta UNKNOWN; por eso se usa OR IS NULL.
SELECT Nombre, Salario
FROM Empleados
WHERE Salario > 3000 OR Salario IS NULL;

-- Funciones de grupo + GROUP BY
-- total de productos por categor�a y precio promedio
SELECT c.Nombre AS Categoria,
       COUNT(*)       AS NumeroProductos,
       AVG(p.Precio)  AS PrecioPromedio
FROM Productos p
INNER JOIN Categorias c ON p.CategoriaID = c.CategoriaID
GROUP BY c.Nombre;

-- HAVING: solo categor�as con m�s de 2 productos
SELECT c.Nombre AS Categoria, COUNT(*) AS NumeroProductos
FROM Productos p
INNER JOIN Categorias c ON p.CategoriaID = c.CategoriaID
GROUP BY c.Nombre
HAVING COUNT(*) > 2;

-- CASE: clasificaci�n de precios
SELECT Nombre,
       Precio,
       CASE
         WHEN Precio < 7 THEN 'Barato'
         WHEN Precio BETWEEN 7 AND 10 THEN 'Medio'
         ELSE 'Caro'
       END AS RangoPrecio
FROM Productos;

-- Otro CASE con salarios (incluye NULL expl�citamente)
SELECT Nombre,
       COALESCE(CONVERT(NVARCHAR(20), Salario), 'Sin dato') AS SalarioMostrar,
       CASE
         WHEN Salario IS NULL           THEN 'No registrado'
         WHEN Salario < 3800            THEN 'Bajo'
         WHEN Salario BETWEEN 3800 AND 4500 THEN 'Medio'
         ELSE 'Alto'
       END AS NivelSalarial
FROM Empleados;
USE CafeteriaBD
-- HAVING: clientes con m�s de 1 pedido realizado
SELECT c.Nombre AS Cliente, COUNT(p.PedidoID) AS TotalPedidos
FROM Pedidos p
INNER JOIN Clientes c ON p.ClienteID = c.ClienteID
GROUP BY c.Nombre
HAVING COUNT(p.PedidoID) > 1;

-- CASE: clasificaci�n de clientes seg�n n�mero de pedidos
SELECT c.Nombre AS Cliente,
       COUNT(p.PedidoID) AS TotalPedidos,
       CASE
         WHEN COUNT(p.PedidoID) = 0 THEN 'Sin pedidos'
         WHEN COUNT(p.PedidoID) BETWEEN 1 AND 2 THEN 'Cliente Ocasional'
         ELSE 'Cliente Frecuente'
       END AS TipoCliente
FROM Clientes c
LEFT JOIN Pedidos p ON c.ClienteID = p.ClienteID
GROUP BY c.Nombre;
