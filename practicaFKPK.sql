Create database Universidad;
Use Universidad;
-- Tabla Profesores
CREATE TABLE Profesores (
    ID_Profesor INT PRIMARY KEY,
    Nombre_Profesor VARCHAR(100) NOT NULL
);

-- Tabla Cursos
CREATE TABLE Cursos (
    ID_Curso INT PRIMARY KEY,
    Nombre_Curso VARCHAR(100) NOT NULL,
    ID_Profesor INT NOT NULL,
    CONSTRAINT FK_Cursos_Profesores FOREIGN KEY (ID_Profesor)
        REFERENCES Profesores(ID_Profesor)
);

-- Tabla Estudiantes
CREATE TABLE Estudiantes (
    ID_Estudiante INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    ID_Curso INT NOT NULL,
    CONSTRAINT FK_Estudiantes_Cursos FOREIGN KEY (ID_Curso)
        REFERENCES Cursos(ID_Curso)
);
-- Profesores
INSERT INTO Profesores (ID_Profesor, Nombre_Profesor) VALUES
(1, 'Dr. García'),
(2, 'Dra. López');

-- Cursos
INSERT INTO Cursos (ID_Curso, Nombre_Curso, ID_Profesor) VALUES
(101, 'Matemáticas', 1),
(102, 'Física', 2);

-- Estudiantes
INSERT INTO Estudiantes (ID_Estudiante, Nombre, ID_Curso) VALUES
(201, 'Juan Pérez', 101),
(202, 'Ana Torres', 102);
SELECT e.ID_Estudiante, e.Nombre AS Estudiante,
       c.Nombre_Curso, p.Nombre_Profesor
FROM Estudiantes e
JOIN Cursos c ON e.ID_Curso = c.ID_Curso
JOIN Profesores p ON c.ID_Profesor = p.ID_Profesor;
