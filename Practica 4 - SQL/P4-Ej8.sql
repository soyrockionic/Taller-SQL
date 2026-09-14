/*
Equipo = (codigoE, nombreE, descripcionE)
Integrante = (DNI, nombre, apellido, ciudad, email, telefono, codigoE(fk))
Laguna = (nroLaguna, nombreL, ubicación, extension, descripción)
TorneoPesca = (codTorneo, fecha, hora, nroLaguna(fk), descripcion)
Inscripcion = (codTorneo(fk), codigoE(fk), asistio, gano) // asistio y gano son true o false segun corresponda
*/


-- 1. Listar DNI, nombre, apellido y email de integrantes que sean de la ciudad ‘La Plata’ y esten
    -- inscriptos en torneos disputados en 2023.

SELECT i.DNI, i.nombre, i.apellido, i.email
FROM Integrante i
WHERE i.ciudad = 'La Plata'
AND i.codigoE IN (
  SELECT ins.codigoE
  From Inscripcion ins
  INNER JOIN TorneoPesca t ON ins.codTorneo = t.codTorneo
  WHERE t.fecha >= '2023-01-01' AND t.fecha < '2024-01-01');


-- 2. Reportar nombre y descripcion de equipos que solo se hayan inscripto en torneos de 2020.

SELECT e.nombreE, e.descripcionE
FROM Equipo e
WHERE e.codigoE IN (
  SELECT ins.codigoE
  FROM Inscripcion ins
  INNER JOIN TorneoPesca t ON ins.codTorneo = t.codTorneo
  WHERE t.fecha >= '2020-01-01' AND t.fecha < '2021-01-01')
AND e.codigoE NOT IN (
  SELECT ins.codigoE
  FROM Inscripcion ins
  INNER JOIN TorneoPesca t ON ins.codTorneo = t.codTorneo
  WHERE t.fecha < '2020-01-01' OR t.fecha >= '2021-01-01');


-- 3. Listar DNI, nombre, apellido,email y ciudad de integrantes que asistieron a torneos en la laguna con
    -- nombre ‘La Salada, Coronel Granada’ y su equipo no tenga inscripciones a torneos disputados en 2023.

SELECT i.DNI, i.nombre, i.apellido, i.email, i.ciudad
FROM Integrante i
WHERE i.codigoE IN (
  SELECT ins.codigoE
  FROM Inscripcion ins
  INNER JOIN TorneoPesca t ON ins.codTorneo = t.codTorneo
  INNER JOIN Laguna l ON t.nroLaguna = l.nroLaguna
  WHERE l.nombreL = 'La Salada, Coronel Granada' AND ins.asistio = TRUE)
AND i.codigoE NOT IN (
  SELECT ins.codigoE
  FROM Inscripcion ins
  INNER JOIN TorneoPesca t ON t.codTorneo = ins.codTorneo
  WHERE t.fecha >='2023-01-01' AND t.fecha < '2024-01-01');


-- 4. Reportar nombre y descripcion de equipos que tengan al menos 5 integrantes.Ordenar por nombre.

SELECT e.nombreE, e.descripcionE
FROM Equipo e
INNER JOIN Integrante i ON e.codigoE = i.codigoE
GROUP BY e.nombreE, e.descripcionE
HAVING COUNT(i.codigoE) >= 5
ORDER BY e.nombreE;


-- 5. Reportar nombre y descripcion de equipos que tengan inscripciones en todas las lagunas.

SELECT e.nombreE, e.descripcionE
FROM Equipo e
INNER JOIN Inscripcion ins ON e.codigoE = ins.codigoE
INNER JOIN TorneoPesca t ON ins.codTorneo  = t.codTorneo
GROUP BY e.nombreE, e.descripcionE
HAVING COUNT(DISTINCT t.nroLaguna) = (SELECT COUNT(*) FROM Laguna);


-- 6. Eliminar el equipo con codigo 10000

DELETE FROM Inscripcion WHERE codigoE = 10000;
DELETE FROM Integrante WHERE codigoE = 10000;
DELETE FROM Equipo WHERE codigoE = 10000;


-- 7. Listar nombre, ubicación,extensión y descripción de lagunas que no tuvieron torneos.

-- Solucion 1

SELECT l.nombreL, l.ubicación, l.extension, l.descripción
FROM Laguna l
LEFT JOIN TorneoPesca t ON l.nroLaguna = t.nroLaguna
GROUP BY l.nombreL, l.ubicación, l.extension, l.descripción
HAVING COUNT(t.nroLaguna) = 0;

-- Solucion 2

SELECT l.nombreL, l.ubicación, l.extension, l.descripción
FROM Laguna l
WHERE l.nroLaguna NOT IN (
    SELECT t.nroLaguna FROM TorneoPesca t);


-- 8. Reportar nombre y descripcion de equipos que tengan inscripciones a torneos a disputarse durante
    -- 2024, pero no tienen inscripciones a torneos de 2023

SELECT e.nombreE, e.descripcionE
FROM Equipo e
WHERE e.codigoE IN (
  SELECT ins.codigoE
  FROM Inscripcion ins
  INNER JOIN TorneoPesca t ON ins.codTorneo = t.codTorneo
  WHERE t.fecha >='2024-01-01' AND t.fecha < '2025-01-01')
AND e.codigoE NOT IN (
  SELECT ins.codigoE
  FROM Inscripcion ins
  INNER JOIN TorneoPesca t ON ins.codTorneo = t.codTorneo
  WHERE t.fecha >='2023-01-01' AND t.fecha < '2024-01-01');


-- 9. Listar DNI, nombre, apellido, ciudad y email de integrantes que ganaron algun torneo que se disputo
    -- en la laguna con nombre: ‘Laguna de Chascomús’.

SELECT i.DNI, i.nombre, i.apellido, i.ciudad, i.email
FROM Integrante i
WHERE i.codigoE IN (
  SELECT ins.codigoE
  FROM Inscripcion ins
  INNER JOIN TorneoPesca t ON ins.codTorneo = t.codTorneo
  INNER JOIN Laguna l ON t.nroLaguna = l.nroLaguna
  WHERE ins.gano = TRUE AND l.nombreL = 'Laguna de Chascomús');