create database CafeteriaBD7;
use CafeteriaBD7;
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
insert into Categorias (Nombre) values('Bebidas'), ('Pastelería'), ('Snacks');
insert into Productos (Nombre, Precio, CategoriaID) values
('Café Americano', 8.50, 1),
('Capuchino',      12.00, 1),
('Té Verde',        7.00, 1),
('Croissant',       6.50, 2),
('Brownie',         9.00, 2),
('Papitas fritas',   5.50, 3);
insert into Clientes (Nombre, Email) values
('Juan Antoni',  'antonjuan@gmail.com'),
('Nathaly Aracely','natRamos@gmail.com'),
('Lucia Gomez','lucyg123@gmail.com'),
('Leydy Guadalupe',  'leydlupe@gmail.com'),
('Luis Miguel',  NULL);  -- email nulo a propósito
insert into Empleados (Nombre, FechaContratacion, Salario) values
('Lucía Ramos', '2024-02-10', 4200.00),
('Marco Díaz',  NULL,          3600.00),  
('Omar Antonio','2022-06-11',3000.00),
('Sofía Villanueva',  '2023-11-05',  3700.00);     
-- más pedidos
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
(3, 3, 2),   -- 2 Tés verdes
(4, 5, 3),   -- 3 Brownie
(4, 1, 1),   -- 1 Americano
(5, 4, 3),   -- 3 Croissant
(6, 6, 2),   -- 2 Papitas Fritas
(7, 3, 2);   -- 2 Tes verdes

-- Aumentar 12% a los productos de la categoría Pastelería
UPDATE p
SET p.Precio = p.Precio * 1.12
FROM Productos p
INNER JOIN Categorias c ON p.CategoriaID = c.CategoriaID
WHERE c.Nombre = 'Pastelería';

-- Productos pedidos por cliente, agrupados por MES
SELECT Cliente, [2025-07] AS Julio, [2025-08] AS Agosto
FROM (
    SELECT c.Nombre AS Cliente,
           FORMAT(pe.Fecha,'yyyy-MM') AS Mes,
           d.Cantidad
    FROM PedidoDetalle d
    INNER JOIN Pedidos pe   ON d.PedidoID = pe.PedidoID
    INNER JOIN Clientes c  ON pe.ClienteID = c.ClienteID
) AS sr
PIVOT (
    SUM(Cantidad) FOR Mes IN ([2025-07],[2025-08])
) AS pV
ORDER BY Cliente;
