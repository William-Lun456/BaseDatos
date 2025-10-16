-- Crear la base de datos
CREATE DATABASE CineDB;
USE CineDB;

-- Tabla de Clientes
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY IDENTITY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100),
    fecha_registro DATE
);

-- Tabla de Películas
CREATE TABLE Peliculas (
    id_pelicula INT PRIMARY KEY IDENTITY,
    titulo VARCHAR(100) NOT NULL,
    genero VARCHAR(50),
    duracion INT,
    clasificacion VARCHAR(10)
);

-- Tabla intermedia: relación muchos a muchos
CREATE TABLE Clientes_Peliculas (
    id_cliente INT,
    id_pelicula INT,
    fecha_vista DATE,
    calificacion INT,  -- opcional (por ejemplo, 1 a 5 estrellas)
    PRIMARY KEY (id_cliente, id_pelicula),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_pelicula) REFERENCES Peliculas(id_pelicula)
);
-- Insertar clientes
INSERT INTO Clientes (nombre, correo, fecha_registro)
VALUES ('Ana Torres', 'ana@gmail.com', '2025-10-10'),
       ('Luis Gómez', 'luis@gmail.com', '2025-10-12');

-- Insertar películas
INSERT INTO Peliculas (titulo, genero, duracion, clasificacion)
VALUES ('Avatar', 'Ciencia Ficción', 162, 'PG-13'),
       ('Interestelar', 'Ciencia Ficción', 169, 'PG-13');

-- Relacionar clientes con películas (muchos a muchos)
INSERT INTO Clientes_Peliculas (id_cliente, id_pelicula, fecha_vista, calificacion)
VALUES (1, 1, '2025-10-11', 5),
       (1, 2, '2025-10-12', 4),
       (2, 1, '2025-10-13', 5);

SELECT 
    c.nombre AS Cliente,
    p.titulo AS Pelicula,
    cp.fecha_vista AS FechaVista,
    cp.calificacion AS Calificacion
FROM Clientes c
JOIN Clientes_Peliculas cp ON c.id_cliente = cp.id_cliente
JOIN Peliculas p ON cp.id_pelicula = p.id_pelicula;

