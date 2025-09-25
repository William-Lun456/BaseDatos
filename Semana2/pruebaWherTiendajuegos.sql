INSERT INTO Usuario(ID_Usuario, Nombres, Correo) VALUES
(03,'Carla','carla23@gmail.com'),
(04,'Luis','lucho_gamer@hotmail.com'),
(05,'Sof�a','sofi.pro@hotmail.com'),
(06,'Andr�s','andres_ps5@gmail.com');
INSERT INTO Videojuegos(ID_Videojuego, Titulo, Plataforma, Precio) VALUES
(13,'The Legend of Zelda: Breath of the Wild','Nintendo Switch',250.00),
(14,'FIFA 23','PS5',200.00),
(15,'Halo Infinite','Xbox Series X',220.00),
(16,'Mario Kart 8 Deluxe','Nintendo Switch',180.00),
(17,'Spider-Man 2','PS5',280.00),
(18,'Elden Ring','PS4',210.00);
INSERT INTO Ventas(ID_Venta, ID_Usuario, Fecha) VALUES
(103,03,'2025-08-10'),
(104,04,'2025-08-15'),
(105,05,'2025-08-18'),
(106,06,'2025-08-19'),
(107,03,'2025-07-20'),
(108,05,'2025-08-05');
INSERT INTO Detalle_ventas(ID_Detalle, ID_Venta, ID_Videojuego, Cantidad) VALUES
(1003,103,13,1),   -- Carla compr� Zelda
(1004,103,16,2),   -- Carla compr� 2 Mario Kart
(1005,104,14,1),   -- Luis compr� FIFA
(1006,104,18,1),   -- Luis tambi�n compr� Elden Ring
(1007,105,17,1),   -- Sof�a compr� Spider-Man 2
(1008,106,15,2),   -- Andr�s compr� 2 Halo Infinite
(1009,107,11,1),   -- Carla antes compr� Pokemon X
(1010,108,16,1),   -- Sof�a compr� Mario Kart
(1011,108,13,1);   -- Sof�a tambi�n compr� Zelda
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
JOIN dbo.Videojuegos j     ON dv.ID_Videojuego = j.ID_Videojuego
WHERE j.Plataforma = 'Nintendo Switch'
  AND v.Fecha BETWEEN '2025-08-01' AND '2025-08-31';
