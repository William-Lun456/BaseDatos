Create database tienda_Videojuegos;
Use tienda_Videojuegos;
Create table Usuario(
	ID_Usuario int primary key ,
	Nombres varchar(100),
	Correo varchar(100)
);
Create table Videojuegos(
	ID_Videojuego int primary key,
	Titulo varchar(200),
	Plataforma varchar(100),
	Precio decimal (6,2),
);
Create table Ventas(
	ID_Venta int primary key,
	ID_Usuario int,
	Fecha date,
	Foreign key(ID_Usuario) references Usuario(ID_Usuario)
);
Create table Detalle_ventas(
	ID_Detalle int primary key,
	ID_Venta int,
	ID_Videojuego int,
	Cantidad int
);
Insert into Usuario(ID_Usuario,Nombres,Correo) values
(01,'William','willrod@gmail.com'),
(02,'Diego','dieg3ef@gmail.com');
Insert into Videojuegos(ID_Videojuego,Titulo,Plataforma,Precio)Values
(11,'Pokemon X','Nintendo 3ds',100),
(12,'God of war','PS4',150.50);
Insert into Ventas(ID_Venta,ID_Usuario,Fecha) values
(101,01,'08-18-2025'),
(102,02,'07-18-2025');
Insert into Detalle_ventas(ID_Detalle,ID_Venta,ID_Videojuego,Cantidad) Values
(1001,101,11,2),
(1002,102,12,4);

USE tienda_Videojuegos;
GO

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

