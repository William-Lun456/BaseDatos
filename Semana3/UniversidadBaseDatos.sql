
-- TABLA: Alumnos
CREATE TABLE Alumnos (
    IdAlumno INT PRIMARY KEY IDENTITY(1,1),
    IdentidadAlumno VARCHAR(20) UNIQUE NOT NULL,
    Nombres VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Genero CHAR(1),
    EstadoCivil VARCHAR(20),
    Fecha_Nacimiento DATE,
    Telefono VARCHAR(20),
    Correo VARCHAR(100),
    Direccion VARCHAR(200)
);

-- TABLA: Carreras
CREATE TABLE Carreras (
    IdCarrera INT PRIMARY KEY IDENTITY(1,1),
    CodCarrera VARCHAR(20) UNIQUE NOT NULL,
    NombreCarrera VARCHAR(100) NOT NULL
);
-- TABLA: PeriodosAcademicos
CREATE TABLE PeriodosAcademicos (
    IdPeriodoAcademico INT PRIMARY KEY IDENTITY(1,1),
    NombreP VARCHAR(50) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFinal DATE NOT NULL
);
-- TABLA: Profesores
CREATE TABLE Profesores (
    IdProfesor INT PRIMARY KEY IDENTITY(1,1),
    IdentidadProfesor VARCHAR(20) UNIQUE NOT NULL,
    Nombres VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Genero CHAR(1),
    Correo VARCHAR(100),
    Telefono VARCHAR(20),
    EstadoCivil VARCHAR(20),
    Profesion VARCHAR(100),
    Fecha_Nacimiento DATE,
    Fecha_Ingreso DATE
);
-- TABLA: Asignaturas
CREATE TABLE Asignaturas (
    IdAsignatura INT PRIMARY KEY IDENTITY(1,1),
    CodAsignatura VARCHAR(20) UNIQUE NOT NULL,
    NombreAsignatura VARCHAR(100) NOT NULL,
    Unidades INT NOT NULL,
    CodCarrera VARCHAR(20) NOT NULL,
    FOREIGN KEY (CodCarrera) REFERENCES Carreras(CodCarrera)
);
-- TABLA: MatriculaAlumnos
CREATE TABLE MatriculaAlumnos (
    IdMatricula INT PRIMARY KEY IDENTITY(1,1),
    IdPeriodoAcademico INT NOT NULL,
    CodCarrera VARCHAR(20) NOT NULL,
    IdentidadAlumno VARCHAR(20) NOT NULL,
    Fecha_Matricula DATE NOT NULL,
    FOREIGN KEY (IdPeriodoAcademico) REFERENCES PeriodosAcademicos(IdPeriodoAcademico),
    FOREIGN KEY (CodCarrera) REFERENCES Carreras(CodCarrera),
    FOREIGN KEY (IdentidadAlumno) REFERENCES Alumnos(IdentidadAlumno)
);
-- TABLA: Profesores_Asignaturas
CREATE TABLE Profesores_Asignaturas (
    IdProfesorAsignatura INT PRIMARY KEY IDENTITY(1,1),
    IdentidadProfesor VARCHAR(20) NOT NULL,
    CodAsignatura VARCHAR(20) NOT NULL,
    IdPeriodoAcademico INT NOT NULL,
    FOREIGN KEY (IdentidadProfesor) REFERENCES Profesores(IdentidadProfesor),
    FOREIGN KEY (CodAsignatura) REFERENCES Asignaturas(CodAsignatura),
    FOREIGN KEY (IdPeriodoAcademico) REFERENCES PeriodosAcademicos(IdPeriodoAcademico)
);
-- TABLA: Notas
CREATE TABLE Notas (
    IdNota INT PRIMARY KEY IDENTITY(1,1),
    IdMatricula INT NOT NULL,
    CodAsignatura VARCHAR(20) NOT NULL,
    Nota DECIMAL(5,2) CHECK (Nota >= 0 AND Nota <= 20),
    FOREIGN KEY (IdMatricula) REFERENCES MatriculaAlumnos(IdMatricula),
    FOREIGN KEY (CodAsignatura) REFERENCES Asignaturas(CodAsignatura)
);
--Insertando datos:
INSERT INTO Carreras (CodCarrera, NombreCarrera)
VALUES 
('ING-SIS', 'Ingeniería de Sistemas'),
('ADM-EMP', 'Administración de Empresas'),
('DER-01', 'Derecho');
INSERT INTO PeriodosAcademicos (NombreP, FechaInicio, FechaFinal)
VALUES
('2025-I', '2025-03-01', '2025-07-31'),
('2025-II', '2025-08-01', '2025-12-15');
INSERT INTO Profesores (IdentidadProfesor, Nombres, Apellidos, Genero, Correo, Telefono, EstadoCivil, Profesion, Fecha_Nacimiento, Fecha_Ingreso)
VALUES
('PROF001', 'Carlos', 'Ramírez', 'M', 'carlos.ramirez@uni.edu', '987654321', 'Soltero', 'Ingeniero de Sistemas', '1980-05-12', '2010-03-15'),
('PROF002', 'María', 'Fernández', 'F', 'maria.fernandez@uni.edu', '987123456', 'Casada', 'Abogada', '1978-09-25', '2012-04-20'),
('PROF003', 'José', 'Pérez', 'M', 'jose.perez@uni.edu', '987111222', 'Soltero', 'Administrador', '1985-02-10', '2015-01-10');
INSERT INTO Asignaturas (CodAsignatura, NombreAsignatura, Unidades, CodCarrera)
VALUES
('BD101', 'Base de Datos I', 4, 'ING-SIS'),
('PR101', 'Programación I', 5, 'ING-SIS'),
('ADM201', 'Gestión Empresarial', 3, 'ADM-EMP'),
('DER101', 'Introducción al Derecho', 4, 'DER-01');
INSERT INTO Alumnos (IdentidadAlumno, Nombres, Apellidos, Genero, EstadoCivil, Fecha_Nacimiento, Telefono, Correo, Direccion)
VALUES
('ALU001', 'Juan', 'Lopez', 'M', 'Soltero', '2002-04-15', '999888777', 'juan.lopez@alumnos.edu', 'Av. Principal 123'),
('ALU002', 'Ana', 'Torres', 'F', 'Soltera', '2001-11-20', '999555444', 'ana.torres@alumnos.edu', 'Calle Secundaria 456'),
('ALU003', 'Luis', 'Martinez', 'M', 'Soltero', '2003-01-10', '999222333', 'luis.martinez@alumnos.edu', 'Jr. Central 789');
INSERT INTO MatriculaAlumnos (IdPeriodoAcademico, CodCarrera, IdentidadAlumno, Fecha_Matricula)
VALUES
(1, 'ING-SIS', 'ALU001', '2025-03-05'),
(1, 'ADM-EMP', 'ALU002', '2025-03-06'),
(1, 'ING-SIS', 'ALU003', '2025-03-07');
INSERT INTO Profesores_Asignaturas (IdentidadProfesor, CodAsignatura, IdPeriodoAcademico)
VALUES
('PROF001', 'BD101', 1),
('PROF001', 'PR101', 1),
('PROF002', 'DER101', 1),
('PROF003', 'ADM201', 1);
INSERT INTO Notas (IdMatricula, CodAsignatura, Nota)
VALUES
(1, 'BD101', 15.5),
(1, 'PR101', 12.0),
(2, 'ADM201', 18.0),
(3, 'BD101', 10.0),
(3, 'PR101', 8.5);


--Probando INNER JOIN (alumnos con sus matrículas)
SELECT 
    a.Nombres,
    a.Apellidos,
    m.IdMatricula,
    p.NombreP AS Periodo,
    c.NombreCarrera
FROM Alumnos a
INNER JOIN MatriculaAlumnos m ON a.IdentidadAlumno = m.IdentidadAlumno
INNER JOIN PeriodosAcademicos p ON m.IdPeriodoAcademico = p.IdPeriodoAcademico
INNER JOIN Carreras c ON m.CodCarrera = c.CodCarrera
WHERE p.NombreP = '2025-I';
--Probadno left join(alumnos q no cuentan con matricula)
SELECT 
    a.Nombres,
    a.Apellidos,
    m.IdMatricula,
    c.NombreCarrera
FROM Alumnos a
LEFT JOIN MatriculaAlumnos m ON a.IdentidadAlumno = m.IdentidadAlumno
LEFT JOIN Carreras c ON m.CodCarrera = c.CodCarrera;
--Uso de inner join para ver alumnnos y calificaciones:
SELECT 
    a.Nombres,
    a.Apellidos,
    asig.NombreAsignatura,
    n.Nota
FROM Notas n
INNER JOIN MatriculaAlumnos m ON n.IdMatricula = m.IdMatricula
INNER JOIN Alumnos a ON m.IdentidadAlumno = a.IdentidadAlumno
INNER JOIN Asignaturas asig ON n.CodAsignatura = asig.CodAsignatura
WHERE n.Nota < 11;
