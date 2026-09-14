/*
Club = (IdClub, nombreClub, ciudad)
Complejo = (IdComplejo, nombreComplejo, IdClub(fk))
Cancha = (IdCancha, nombreCancha, IdComplejo(fk))
Entrenador = (IdEntrenador, nombreEntrenador, fechaNacimiento, direccion)
Entrenamiento = (IdEntrenamiento, fecha, IdEntrenador(fk), IdCancha(fk))
*/


-- 1. Listar nombre, fecha de nacimiento y direccion de entrenadores que hayan tenido
   --  entrenamientos durante 2023.


SELECT e.nombreEntrenador, e.fechaNacimiento, e.direccion
FROM Entrenador e
WHERE e.idEntrenador IN (
  SELECT en.idEntrenador
  FROM Entrenamiento en
  WHERE en.fecha >= '2023-01-01' AND en.fecha < '2024-01-01');


-- 2. Listar para cada cancha del complejo 'Complejo 1', la cantidad de entrenamientos que se
   --  realizaron durante el 2022. Informar nombre de la cancha y cantidad de entrenamientos.

SELECT c.nombreCancha, COUNT(en.idCancha) AS Cantidad_Entrenamientos
FROM Cancha c
INNER JOIN Complejo co ON c.idComplejo = co.idComplejo
LEFT JOIN Entrenamiento en ON c.idCancha = en.idCancha
    AND en.fecha >= '2022-01-01' AND en.fecha < '2023-01-01'
WHERE co.nombreComplejo = 'Complejo 1'
GROUP BY c.nombreCancha;


-- 3. Listar los complejos donde haya realizado entrenamientos el entrenador 'Jorge Gonzalez'.
   --  Informar nombre de complejo, ordenar el resultado de manera ascendente.

SELECT DISTINCT co.nombreComplejo
FROM Complejo co
WHERE co.idComplejo IN (
    SELECT c.idComplejo
    FROM Cancha c
    INNER JOIN Entrenamiento en ON c.idCancha = en.idCancha
    INNER JOIN Entrenador e ON en.idEntrenador = e.idEntrenador
    WHERE e.nombreEntrenador = 'Jorge Gonzalez')
ORDER BY co.nombreComplejo ASC;


-- 4. Listar nombre, fecha de nacimiento y dirección de entrenadores que hayan entrenado en los
   --  clubes con nombre 'Everton' y 'Estrella de Berisso'.

SELECT e.nombreEntrenador, e.fechaNacimiento, e.direccion
FROM Entrenador e
WHERE e.idEntrenador IN (
  SELECT en.idEntrenador
  FROM Entrenamiento en
  INNER JOIN Cancha c ON en.idCancha = c.idCancha
  INNER JOIN Complejo co ON c.idComplejo = co.idComplejo
  INNER JOIN Club cl ON co.idClub = cl.idClub
  WHERE cl.nombreClub = 'Everton')
AND e.idEntrenador IN (
  SELECT en.idEntrenador
  FROM Entrenamiento en
  INNER JOIN Cancha c ON en.idCancha = c.idCancha
  INNER JOIN Complejo co ON c.idComplejo = co.idComplejo
  INNER JOIN Club cl ON co.idClub = cl.idClub
  WHERE cl.nombreClub = 'Estrella de Berisso');


-- 5. Listar todos los clubes en los que entrena el entrenador 'Marcos Perez'. Informar nombre del
   --  club y ciudad.

SELECT cl.nombreClub, cl.ciudad
FROM Club cl
WHERE cl.idClub IN (
  SELECT co.idClub
  FROM Complejo co
  INNER JOIN Cancha c ON co.idComplejo = c.idComplejo
  INNER JOIN Entrenamiento en ON c.idCancha = en.idCancha
  INNER JOIN Entrenador e ON en.idEntrenador = e.idEntrenador
  WHERE e.nombreEntrenador = 'Marcos Perez');


-- 6. Eliminar los entrenamientos del entrenador 'Juan Perez'.

DELETE FROM Entrenamiento WHERE IdEntrenador IN (
    SELECT IdEntrenador
    FROM Entrenador
    WHERE nombreEntrenador = 'Juan Perez');