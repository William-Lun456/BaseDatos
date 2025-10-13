create database Trabajo;
use Trabajo;
CREATE TABLE Empleados (
    EmpleadoID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100),
    Puesto NVARCHAR(50)
);

CREATE TABLE Proyectos (
    ProyectoID INT PRIMARY KEY IDENTITY,
    NombreProyecto NVARCHAR(100),
    FechaInicio DATE
);
CREATE TABLE EmpleadosProyectos (
    EmpleadoID INT,
    ProyectoID INT,
    Rol NVARCHAR(50),
    PRIMARY KEY (EmpleadoID, ProyectoID),
    FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID),
    FOREIGN KEY (ProyectoID) REFERENCES Proyectos(ProyectoID)
);
-- Insertar Empleados
INSERT INTO Empleados (Nombre, Puesto) VALUES ('Carlos Rivera', 'Ingeniero de Software');
INSERT INTO Empleados (Nombre, Puesto) VALUES ('Lucía Torres', 'Diseñadora UX');

-- Insertar Proyectos
INSERT INTO Proyectos (NombreProyecto, FechaInicio) VALUES ('Sistema de Ventas', '2025-05-10');
INSERT INTO Proyectos (NombreProyecto, FechaInicio) VALUES ('App Móvil Corporativa', '2025-07-01');

-- Relacionar Empleados con Proyectos
INSERT INTO EmpleadosProyectos (EmpleadoID, ProyectoID, Rol) VALUES (1, 1, 'Desarrollador');
INSERT INTO EmpleadosProyectos (EmpleadoID, ProyectoID, Rol) VALUES (1, 2, 'Líder Técnico');
INSERT INTO EmpleadosProyectos (EmpleadoID, ProyectoID, Rol) VALUES (2, 2, 'Diseñadora Principal');

SELECT e.Nombre, e.Puesto, p.NombreProyecto, ep.Rol
FROM Empleados e
JOIN EmpleadosProyectos ep ON e.EmpleadoID = ep.EmpleadoID
JOIN Proyectos p ON ep.ProyectoID = p.ProyectoID;
