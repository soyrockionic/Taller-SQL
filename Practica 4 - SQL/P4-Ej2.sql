-- ================================== Schema ====================================

/*
Localidad = (codigoPostal, nombreL, descripcion, nroHabitantes)
Arbol = (nroArbol, especie, anios, calle, nro, codigoPostal(fk))
Podador = (DNI, nombre, apellido, telefono, fnac, codigoPostalVive(fk))
Poda = (codPoda, fecha, DNI(fk), nroArbol(fk))
*/

CREATE TABLE Localidad (
    codigoPostal VARCHAR(10) PRIMARY KEY,
    nombreL VARCHAR(100),
    descripcion VARCHAR(300),
    nroHabitantes INT
);

CREATE TABLE Arbol (
    nroArbol INT PRIMARY KEY,
    especie VARCHAR(100),
    anios INT,
    calle VARCHAR(200),
    nro INT,
    codigoPostal VARCHAR(10),
    FOREIGN KEY (codigoPostal) REFERENCES Localidad(codigoPostal)
);

CREATE TABLE Podador (
    DNI VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    telefono VARCHAR(30),
    fnac DATE,
    codigoPostalVive VARCHAR(10),
    FOREIGN KEY (codigoPostalVive) REFERENCES Localidad(codigoPostal)
);

CREATE TABLE Poda (
    codPoda INT PRIMARY KEY,
    fecha DATE,
    DNI VARCHAR(20),
    nroArbol INT,
    FOREIGN KEY (DNI) REFERENCES Podador(DNI),
    FOREIGN KEY (nroArbol) REFERENCES Arbol(nroArbol)
);

-- =================================== Datos =====================================

-- Localidades (6)
INSERT INTO Localidad VALUES ('1900', 'La Plata', 'Capital provincial', 800000);
INSERT INTO Localidad VALUES ('1902', 'Berisso', 'Zona portuaria', 95000);
INSERT INTO Localidad VALUES ('1904', 'Ensenada', 'Zona industrial', 60000);
INSERT INTO Localidad VALUES ('7100', 'Mar del Plata', 'Ciudad balnearia', 680000);
INSERT INTO Localidad VALUES ('7600', 'Tandil', 'Ciudad serrana', 120000);
INSERT INTO Localidad VALUES ('4400', 'Salta', 'Ciudad norteña', 535000);

-- Arboles (10) - distribuidos en distintas localidades
INSERT INTO Arbol VALUES (1, 'Roble', 25, 'Calle 7', 500, '1900');
INSERT INTO Arbol VALUES (2, 'Eucalipto', 10, 'Av. 13', 1200, '1900');
INSERT INTO Arbol VALUES (3, 'Jacaranda', 15, 'Calle 48', 800, '1902');
INSERT INTO Arbol VALUES (4, 'Platano', 30, 'Av. Montevideo', 300, '1902');
INSERT INTO Arbol VALUES (5, 'Ombu', 50, 'Calle 10', 150, '1904');
INSERT INTO Arbol VALUES (6, 'Pino', 8, 'Av. Colon', 2500, '7100');
INSERT INTO Arbol VALUES (7, 'Ceibo', 20, 'Calle Belgrano', 400, '7100');
INSERT INTO Arbol VALUES (8, 'Tilo', 12, 'Av. España', 900, '7600');
-- Especie compartida: Roble en ambas localidades
INSERT INTO Arbol VALUES (11, 'Roble', 18, 'Calle Caseros', 300, '4400');
-- Especie solo en Salta: Lapacho
INSERT INTO Arbol VALUES (12, 'Lapacho', 25, 'Av. San Martin', 500, '4400');

-- Podadores (6) - viven en distintas localidades
INSERT INTO Podador VALUES ('30111222', 'Carlos', 'Ruiz', '221-555-0001', '1985-03-15', '1900');
INSERT INTO Podador VALUES ('32333444', 'Ana', 'Garcia', '221-555-0002', '1990-07-22', '1900');
INSERT INTO Podador VALUES ('35555666', 'Juan', 'Perez', '221-555-0003', '1978-11-03', '1902');
INSERT INTO Podador VALUES ('38777888', 'Maria', 'Lopez', '221-555-0004', '1995-01-30', '1904');
INSERT INTO Podador VALUES ('40999000', 'Jorge', 'Martinez', '223-555-0005', '1988-06-18', '7100');
INSERT INTO Podador VALUES ('42111333', 'Lucia', 'Fernandez', '249-555-0006', '2000-09-10', '7600');

-- Podas (11) - relacionando podadores con arboles
INSERT INTO Poda VALUES (1, '2023-03-10', '30111222', 1);   -- Carlos poda Roble
INSERT INTO Poda VALUES (2, '2023-06-15', '30111222', 2);   -- Carlos poda Eucalipto
INSERT INTO Poda VALUES (3, '2023-09-20', '32333444', 3);   -- Ana poda Jacaranda
INSERT INTO Poda VALUES (4, '2024-01-05', '32333444', 1);   -- Ana poda Roble
INSERT INTO Poda VALUES (5, '2024-02-14', '35555666', 4);   -- Juan poda Platano
INSERT INTO Poda VALUES (6, '2022-04-22', '35555666', 5);   -- Juan poda Ombu
INSERT INTO Poda VALUES (7, '2022-07-30', '38777888', 5);   -- María poda Ombu
INSERT INTO Poda VALUES (8, '2024-10-11', '40999000', 6);   -- Jorge poda Pino
INSERT INTO Poda VALUES (9, '2025-01-20', '40999000', 7);   -- Jorge poda Ceibo
INSERT INTO Poda VALUES (10,'2025-03-05', '30111222', 7);   -- Carlos poda Ceibo
INSERT INTO Poda VALUES (11, '2022-06-15', '30111222', 8); -- Carlos poda Tilo en 2022

-- ================================== Querys =====================================

-- 1. Listar especie, años, calle, nro y localidad de arboles podados por el podador ‘Juan Perez’
    -- y por el podador ‘Jose Garcia’.

SELECT a.especie, a.anios, a.calle, a.nro, l.nombreL
FROM Arbol a
INNER JOIN Localidad l ON a.codigoPostal = l.codigoPostal
WHERE a.nroArbol IN (
    SELECT po.nroArbol
    FROM Poda po
    INNER JOIN Podador p ON po.DNI = p.DNI
    WHERE p.nombre = 'Juan' AND p.apellido = 'Perez'
)
AND a.nroArbol IN (
    SELECT po.nroArbol
    FROM Poda po
    INNER JOIN Podador p ON po.DNI = p.DNI
    WHERE p.nombre = 'Jose' AND p.apellido = 'Garcia'
);


-- 2. Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
    -- podadores que tengan podas realizadas durante 2023.

SELECT p.DNI, p.nombre, p.apellido, p.fnac, l.nombreL
FROM Podador p
INNER JOIN Localidad l ON p.codigoPostalVive = l.codigoPostal
WHERE p.DNI IN (
  SELECT po.DNI
  FROM Poda po
  WHERE po.fecha >= '2023-01-01' AND po.fecha < '2024-01-01');


-- 3. Listar especie, años, calle, nro y localidad de arboles que no fueron podados nunca.

SELECT a.especie, a.anios, a.calle, a.nro, l.nombreL
FROM Arbol a
INNER JOIN Localidad l ON a.codigoPostal = l.codigoPostal
WHERE NOT EXISTS (
  SELECT 1 FROM Poda po
  WHERE po.nroArbol = a.nroArbol);
--WHERE a.nroArbol NOT IN (
  --SELECT po.nroArbol
  --FROM Poda po);


-- 4. Reportar especie, años,calle, nro y localidad de arboles que fueron podados durante 2022 y no
    -- fueron podados durante 2023

SELECT DISTINCT a.especie, a.anios, a.calle, a.nro, l.nombreL
FROM Arbol a
INNER JOIN Localidad l ON a.codigoPostal = l.codigoPostal
INNER JOIN Poda po ON a.nroArbol = po.nroArbol
WHERE po.fecha >= '2022-01-01' AND po.fecha < '2023-01-01'
AND a.nroArbol NOT IN (
  SELECT nroArbol
  FROM Poda
  WHERE fecha >= '2023-01-01' AND fecha < '2024-01-01');


--5. Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
   -- podadores con apellido terminado con el string ‘ata’ y que tengan al menos una poda durante
   -- 2024. Ordenar por apellido y nombre.

SELECT p.DNI, p.nombre, p.apellido, p.fnac, l.nombreL
FROM Podador p
INNER JOIN Localidad l ON p.codigoPostalVive = l.codigoPostal
WHERE p.apellido LIKE '%ata'
AND p.DNI IN (
  SELECT po.DNI
  FROM Poda po
  WHERE fecha >= '2024-01-01' AND po.fecha < '2025-01-01')
ORDER BY p.apellido, p.nombre;


/*6. Listar DNI, apellido, nombre, telefono y fecha de nacimiento de podadores que solo podaron arboles de 
especie 'Coniferas'.*/

SELECT p.DNI, p.nombre, p.apellido, p.telefono, p.fnac
FROM Podador p
WHERE p.DNI IN (
  SELECT po.DNI
  FROM Poda po
  INNER JOIN Arbol a ON po.nroArbol = a.nroArbol
  WHERE a.especie = 'Coniferas')
AND p.DNI NOT IN (
  SELECT po.DNI
  FROM Poda po
  INNER JOIN Arbol a ON po.nroArbol = a.nroArbol
  WHERE a.especie != 'Coniferas');


-- 7. Listar especies de arboles que se encuentren en la localidad de ‘La Plata’ y tambien en la
    -- localidad de ‘Salta’

SELECT a.especie
FROM Arbol a
INNER JOIN Localidad l ON a.codigoPostal = l.codigoPostal
WHERE l.nombreL = 'La Plata'
AND a.especie IN (
  SELECT a.especie
  FROM Arbol a
  INNER JOIN Localidad l ON a.codigoPostal = l.codigoPostal
  WHERE l.nombreL = 'Salta');


-- 8. Eliminar el podador con DNI 22234566.

DELETE FROM Podador WHERE DNI = '22234566';


-- 9. Reportar nombre, descripcion y cantidad de habitantes de localidades que tengan menos de 5
    -- arboles.

SELECT l.nombreL, l.descripcion, l.nroHabitantes
FROM Localidad l
LEFT JOIN Arbol a ON l.codigoPostal = a.codigoPostal
GROUP BY l.nombreL, l.descripcion, l.nroHabitantes
HAVING COUNT(a.nroArbol) < 5;
