/*
Club = (codigoClub, nombre, anioFundacion, codigoCiudad(FK))
Ciudad = (codigoCiudad, nombre)
Estadio = (codigoEstadio, codigoClub(FK), nombre, direccion)
Jugador = (DNI, nombre, apellido, edad, codigoCiudad(FK))
ClubJugador = (codigoClub (FK), DNI (FK), desde, hasta)
*/


/*
1. Reportar nombre y año de fundacion de aquellos clubes de la ciudad de La Plata que no poseen
estadio.
*/

SELECT c.nombre, c.anioFundacion
FROM Club c
INNER JOIN Ciudad ci ON c.codigoCiudad = ci.codigoCiudad
WHERE ci.nombre = 'La Plata'
AND c.codigoClub NOT IN (
  SELECT e.codigoClub
  FROM Estadio e);
  
-- o

SELECT c.nombre, c.anioFundacion
FROM Club c
INNER JOIN Ciudad ci ON c.codigoCiudad = ci.codigoCiudad
LEFT JOIN Estadio e ON c.codigoClub = e.codigoClub
WHERE ci.nombre = 'La Plata' AND e.codigoEstadio IS NULL;


/*
2. Listar nombre de los clubes que no hayan tenido ni tengan jugadores de la ciudad de Berisso
*/

SELECT c.nombre
FROM Club c
WHERE c.codigoClub NOT IN (
  SELECT cj.codigoClub
  FROM ClubJugador cj
  INNER JOIN Jugador j ON cj.DNI = j.DNI
  INNER JOIN Ciudad ci ON j.codigoCiudad = ci.codigoCiudad
  WHERE ci.nombre = 'Berisso');


/*
3. Mostrar DNI, nombre y apellido de aquellos jugadores que jugaron o juegan en el club Gimnasia
y Esgrima La Plata.
*/

SELECT j.DNI, j.nombre, j.apellido
FROM Jugador j
WHERE j.DNI IN (
  SELECT cj.DNI
  FROM ClubJugador cj
  INNER JOIN Club c ON cj.codigoClub = c.codigoClub
  WHERE c.nombre = 'Gimnasia y Esgrima LP');


/*
4. Mostrar DNI, nombre y apellido de aquellos jugadores que tengan mas de 29 años y hayan
jugado o juegan en algun club de la ciudad de Cordoba.
*/

SELECT j.DNI, j.nombre, j.apellido
FROM Jugador j
WHERE j.edad > 29
AND j.DNI IN (
  SELECT cj.DNI
  FROM ClubJugador cj
  INNER JOIN Club c ON cj.codigoClub = c.codigoClub
  INNER JOIN Ciudad ci ON c.codigoCiudad = ci.codigoCiudad
  WHERE ci.nombre = 'Cordoba');


/*
5. Mostrar para cada club, nombre de club y la edad promedio de los jugadores que juegan
actualmente en cada uno.
*/

SELECT c.nombre, AVG(j.edad) AS Edad_promedio
FROM Club c
INNER JOIN ClubJugador cj ON c.codigoClub = cj.codigoClub
INNER JOIN Jugador j ON cj.DNI = j.DNI
WHERE cj.hasta IS NULL
GROUP BY c.nombre;


/*
6. Listar para cada jugador nombre, apellido, edad y cantidad de clubes diferentes en los que jugo.
(incluido el actual)
*/

SELECT j.DNI, j.nombre, j.apellido, j.edad, COUNT(DISTINCT cj.codigoClub) AS CantClubes
FROM Jugador j
INNER JOIN ClubJugador cj ON j.DNI = cj.DNI
GROUP BY j.DNI, j.nombre, j.apellido, j.edad;


/*
7. Mostrar el nombre de los clubes que nunca hayan tenido jugadores de la ciudad de Mar del
Plata.
*/

SELECT c.nombre
FROM Club c
WHERE c.codigoClub NOT IN (
  SELECT cj.codigoClub
  FROM ClubJugador cj
  INNER JOIN Jugador j ON cj.DNI = j.DNI
  INNER JOIN Ciudad ci ON j.codigoCiudad = ci.codigoCiudad
  WHERE ci.nombre = 'Mar del Plata');


/*
8. Reportar el nombre y apellido de aquellos jugadores que hayan jugado en todos los clubes de la
ciudad de Cordoba.
*/

SELECT j.nombre, j.apellido
FROM Jugador j
INNER JOIN ClubJugador cj ON j.DNI = cj.DNI
INNER JOIN Club c ON cj.codigoClub = c.codigoClub
INNER JOIN Ciudad ci ON c.codigoCiudad = ci.codigoCiudad
WHERE ci.nombre = 'Cordoba'
GROUP BY j.nombre, j.apellido
HAVING COUNT(DISTINCT cj.codigoClub)
=
(SELECT COUNT(c.codigoClub)
 FROM Club c
 INNER JOIN Ciudad ci ON c.codigoCiudad = ci.codigoCiudad
 WHERE ci.nombre = 'Cordoba');


/*
9. Agregar el club “Estrella de Berisso”, con código 1234, que se fundo en 1921 y que pertenece a
la ciudad de Berisso. Puede asumir que el codigoClub 1234 no existe en la tabla Club.
*/

INSERT INTO Club VALUES (1234, 'Estrella de Berisso', 1921, 2);

-- o

INSERT INTO Club VALUES (1234, 'Estrella de Berisso', 1921, 
        (SELECT codigoCiudad FROM Ciudad WHERE nombre = 'Berisso'));