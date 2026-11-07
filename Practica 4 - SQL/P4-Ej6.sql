-- ================================== Schema ====================================

/*
Técnico = (codTec, nombre, especialidad) // tecnicos
Repuesto = (codRep, nombre, stock, precio) // repuestos
RepuestoReparacion = (nroReparac (fk), codRep (fk), cantidad, precio) // repuestos utilizados en reparaciones.
Reparación = (nroReparac, codTec (fk), precio_total, fecha) // reparaciones realizadas.
*/

CREATE TABLE Tecnico (
    codTec INT PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(100)
);

CREATE TABLE Repuesto (
    codRep INT PRIMARY KEY,
    nombre VARCHAR(100),
    stock INT,
    precio DECIMAL(10,2)
);

CREATE TABLE Reparacion (
    nroReparac INT PRIMARY KEY,
    codTec INT,
    precio_total DECIMAL(10,2),
    fecha DATE,
    FOREIGN KEY (codTec) REFERENCES Tecnico(codTec)
);

CREATE TABLE RepuestoReparacion (
    nroReparac INT,
    codRep INT,
    cantidad INT,
    precio DECIMAL(10,2),
    PRIMARY KEY (nroReparac, codRep),
    FOREIGN KEY (nroReparac) REFERENCES Reparacion(nroReparac),
    FOREIGN KEY (codRep) REFERENCES Repuesto(codRep)
);


-- =================================== Datos =====================================

-- Tecnicos (5) - distintas especialidades
INSERT INTO Tecnico VALUES (1, 'Carlos Méndez', 'Electricidad');
INSERT INTO Tecnico VALUES (2, 'Ana Torres', 'Mecánica');
INSERT INTO Tecnico VALUES (3, 'Jorge Ruiz', 'Chapa y Pintura');
INSERT INTO Tecnico VALUES (4, 'María López', 'Electricidad');
INSERT INTO Tecnico VALUES (5, 'Pedro Sánchez', 'Mecánica');  -- Sin reparaciones

-- Repuestos (7) - distintos precios y stocks
INSERT INTO Repuesto VALUES (10, 'Batería 12V', 15, 45000.00);
INSERT INTO Repuesto VALUES (20, 'Filtro de aceite', 50, 8000.00);
INSERT INTO Repuesto VALUES (30, 'Pastillas de freno', 30, 12000.00);
INSERT INTO Repuesto VALUES (40, 'Bujía NGK', 100, 3500.00);
INSERT INTO Repuesto VALUES (50, 'Alternador', 5, 85000.00);
INSERT INTO Repuesto VALUES (60, 'Correa dentada', 20, 15000.00);
INSERT INTO Repuesto VALUES (70, 'Amortiguador trasero', 0, 35000.00);  -- Stock 0, nunca usado

-- Reparaciones (8) - distribuidas en fechas y tecnicos
INSERT INTO Reparacion VALUES (1001, 1, 95000.00, '2023-01-15');  -- Carlos Méndez
INSERT INTO Reparacion VALUES (1002, 2, 52000.00, '2024-02-20');  -- Ana Torres
INSERT INTO Reparacion VALUES (1003, 1, 120000.00, '2024-03-10'); -- Carlos Méndez
INSERT INTO Reparacion VALUES (1004, 3, 75000.00, '2024-04-05');  -- Jorge Ruiz
INSERT INTO Reparacion VALUES (1005, 2, 38000.00, '2024-05-18');  -- Ana Torres
INSERT INTO Reparacion VALUES (1006, 4, 62000.00, '2024-06-22');  -- María López
INSERT INTO Reparacion VALUES (1007, 1, 48000.00, '2024-07-30');  -- Carlos Méndez
INSERT INTO Reparacion VALUES (1008, 3, 90000.00, '2024-08-15');  -- Jorge Ruiz

-- RepuestoReparacion (14) - repuestos usados en cada reparacion
INSERT INTO RepuestoReparacion VALUES (1001, 10, 1, 45000.00);   -- Batería x1
INSERT INTO RepuestoReparacion VALUES (1001, 40, 4, 3500.00);    -- Bujía x4
INSERT INTO RepuestoReparacion VALUES (1002, 20, 2, 8000.00);    -- Filtro aceite x2
INSERT INTO RepuestoReparacion VALUES (1002, 30, 1, 12000.00);   -- Pastillas freno x1
INSERT INTO RepuestoReparacion VALUES (1003, 50, 1, 85000.00);   -- Alternador x1
INSERT INTO RepuestoReparacion VALUES (1003, 60, 1, 15000.00);   -- Correa dentada x1
INSERT INTO RepuestoReparacion VALUES (1004, 30, 2, 12000.00);   -- Pastillas freno x2
INSERT INTO RepuestoReparacion VALUES (1004, 20, 1, 8000.00);    -- Filtro aceite x1
INSERT INTO RepuestoReparacion VALUES (1005, 40, 4, 3500.00);    -- Bujía x4
INSERT INTO RepuestoReparacion VALUES (1006, 10, 1, 45000.00);   -- Batería x1
INSERT INTO RepuestoReparacion VALUES (1006, 60, 1, 15000.00);   -- Correa dentada x1
INSERT INTO RepuestoReparacion VALUES (1007, 20, 1, 8000.00);    -- Filtro aceite x1
INSERT INTO RepuestoReparacion VALUES (1007, 40, 4, 3500.00);    -- Bujía x4
INSERT INTO RepuestoReparacion VALUES (1008, 30, 2, 12000.00);   -- Pastillas freno x2
INSERT INTO RepuestoReparacion VALUES (1008, 50, 1, 85000.00);   -- Alternador x1


-- ================================== Querys =====================================

-- 1. Listar los repuestos, informando el nombre, stock y precio. Ordenar el resultado por precio.

SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
ORDER BY r.precio;


-- 2. Listar nombre, stock y precio de repuestos que se usaron en reparaciones durante 2023 y que no
    -- se usaron en reparaciones del técnico ‘José Gonzalez’

SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
WHERE r.codRep IN (
  SELECT rr.codRep
  FROM RepuestoReparacion rr
  INNER JOIN Reparacion re ON rr.nroReparac = re.nroReparac
  WHERE re.fecha >= '2023-01-01' AND re.fecha < '2024-01-01')
AND r.codRep NOT IN (
  SELECT rr.codRep
  FROM RepuestoReparacion rr
  INNER JOIN Reparacion re ON rr.nroReparac = re.nroReparac
  INNER JOIN Tecnico t ON re.codTec = t.codTec
  WHERE t.nombre = 'José Gonzalez');


-- 3. Listar el nombre y especialidad de tecnicos que no participaron en ninguna reparacion. Ordenar
    -- por nombre ascendentemente.

SELECT t.nombre, t.especialidad
FROM Tecnico t
WHERE t.codTec NOT IN (
  SELECT re.codTec
  FROM Reparacion re
  WHERE re.codTec IS NOT NULL)
ORDER BY t.nombre ASC;


-- 4. Listar el nombre y especialidad de los tecnicos que solamente participaron en reparaciones
    -- durante 2022.

SELECT t.nombre, t.especialidad
FROM Tecnico t
WHERE t.codTec IN (
  SELECT re.codTec
  FROM Reparacion re
  WHERE re.fecha >= '2022-01-01' AND re.fecha < '2023-01-01')
AND t.codTec NOT IN (
  SELECT re.codTec
  FROM Reparacion re
  WHERE (re.fecha < '2022-01-01' OR re.fecha >= '2023-01-01')
  AND re.codTec IS NOT NULL);


-- 5. Listar para cada repuesto nombre, stock y cantidad de tecnicos distintos que lo utilizaron. Si un
    -- repuesto no participo en alguna reparacion igual debe aparecer en dicho listado.

SELECT r.nombre, r.stock, COUNT(DISTINCT re.codTec) AS cant_Tec_Usos
FROM Repuesto r
LEFT JOIN RepuestoReparacion rr ON r.codRep = rr.codRep
LEFT JOIN Reparacion re ON rr.nroReparac = re.nroReparac
GROUP BY r.nombre, r.stock;


-- 6. Listar nombre y especialidad del tecnico con mayor cantidad de reparaciones realizadas y el
    -- tecnico con menor cantidad de reparaciones.

(SELECT t.nombre, t.especialidad, COUNT(t.codTec) AS cantidad_reparaciones
FROM Tecnico t
INNER JOIN Reparacion re ON t.codTec = re.codTec
GROUP BY t.nombre, t.especialidad
ORDER BY COUNT(t.codTec) DESC
LIMIT 1)

UNION ALL

(SELECT t.nombre, t.especialidad, COUNT(t.codTec) AS cantidad_reparaciones
FROM Tecnico t
INNER JOIN Reparacion re ON t.codTec = re.codTec
GROUP BY t.nombre, t.especialidad
ORDER BY COUNT(t.codTec) ASC
LIMIT 1);


-- 7. Listar nombre, stock y precio de todos los repuestos con stock mayor a 0 y que dicho repuesto
    -- no haya estado en reparaciones con un precio total superior a $10000.

SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
WHERE r.stock > 0
AND r.codRep NOT IN (
  SELECT rr.codRep
  FROM RepuestoReparacion rr
  INNER JOIN Reparacion re ON rr.nroReparac = re.nroReparac
  WHERE re.precio_total > 10000);


-- 8. Proyectar numero, fecha y precio total de aquellas reparaciones donde se utilizo algun repuesto
    -- con precio en el momento de la reparacion mayor a $10000 y menor a $15000.

SELECT re.nroReparac, re.fecha, re.precio_total
FROM Reparacion re
WHERE re.nroReparac IN (
  SELECT rr.nroReparac
  FROM RepuestoReparacion rr
  WHERE rr.precio > 10000)
AND re.nroReparac IN (
  SELECT rr.nroReparac
  FROM RepuestoReparacion rr 
  WHERE rr.precio < 15000);


/*9. Listar nombre, stock y precio de repuestos que hayan sido utilizados por todos los tecnicos.*/

SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
INNER JOIN RepuestoReparacion rr ON r.codRep = rr.codRep
INNER JOIN Reparacion re ON rr.nroReparac = re.nroReparac
GROUP BY r.nombre, r.stock, r.precio
HAVING COUNT(DISTINCT re.codTec) = (SELECT COUNT(*) FROM Tecnico);


-- 10. Listar fecha, tecnico y precio total de aquellas reparaciones que necesitaron al menos 4
     -- repuestos distintos

SELECT re.fecha, re.codTec, re.precio_total
FROM Reparacion re
INNER JOIN RepuestoReparacion rr ON re.nroReparac = rr.nroReparac
GROUP BY re.nroReparac, re.fecha, re.codTec, re.precio_total
HAVING COUNT(DISTINCT rr.codRep) >= 4;
