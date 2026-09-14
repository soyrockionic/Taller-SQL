/*
Box = (nroBox, m2, ubicación, capacidad, ocupacion)
- ocupacion es un numerico indicando cantidad de mascotas en el box actualmente,
- capacidad es una descripcion. 
Mascota = (codMascota, nombre, edad, raza, peso, telefonoContacto)
Veterinario = (matricula, CUIT, nombYAp, direccion, telefono)
Supervision = (codMascota(fk), nroBox(fk), fechaEntra, fechaSale?, matricula(fk), descripcionEstadia)
- fechaSale tiene valor null si la mascota esta actualmente en el box
*/


/*
1. Listar para cada veterinario cantidad de supervisiones realizadas con fecha de salida (fechaSale)
durante enero de 2024. Indicar matricula, CUIT, nombre y apellido, direccion, telefono y cantidad de supervisiones.
*/

SELECT v.matricula, v.CUIT, v.nombYAp, v.direccion, v.telefono, COUNT(s.matricula) AS cantSupervisiones
FROM Veterinario v
INNER JOIN Supervision s ON v.matricula = s.matricula
WHERE s.fechaSale >= '2024-01-01' AND s.fechaSale < '2024-02-01'
GROUP BY v.matricula, v.CUIT, v.nombYAp, v.direccion, v.telefono;


/*
2. Listar CUIT, matricula, nombre, apellido, direccion y telefono de veterinarios que no tengan mascotas
bajo supervision actualmente.
*/

SELECT v.CUIT, v.matricula, v.nombYAp, v.direccion, v.telefono
FROM Veterinario v
WHERE v.matricula NOT IN (
  SELECT s.matricula
  FROM Supervision s
  WHERE s.fechaSale IS NULL);


/*
3. Listar nombre, edad, raza, peso y telefono de contacto de mascotas que fueron atendidas por el
veterinario 'Oscar Lopez'. Ordenar por nombre y raza de manera ascendente.
*/

SELECT m.nombre, m.edad, m.raza, m.peso, m.telefonoContacto
FROM Mascota m
WHERE m.codMascota IN (
  SELECT s.codMascota
  FROM Supervision s
  INNER JOIN Veterinario v ON s.matricula = v.matricula
  WHERE v.nombYAp = 'Oscar Lopez')
ORDER BY m.nombre, m.raza ASC;


/*
4. Modificar el nombre y apellido al veterinario con matricula 'MP 10000', debera llamarse: 'Pablo Lopez'.
*/

UPDATE Veterinario
SET nombYAp = 'Pablo Lopez'
WHERE matricula = 'MP 10000';


/*
5. Listar nombre, edad, raza y peso de mascotas que tengan supervisiones con el veterinario con
matricula 'MP 1000' y con el veterinario con matricula 'MN 4545'.
*/

SELECT m.nombre, m.edad, m.raza, m.peso
FROM Mascota m
WHERE m.codMascota IN (
  SELECT s.codMascota
  FROM Supervision s
  WHERE s.matricula = 'MP 1000')
AND m.codMascota IN (
  SELECT s.codMascota
  FROM Supervision s
  WHERE s.matricula = 'Mn 4545');


/*
6. Listar numero de box, m2, ubicación, capacidad y nombre de mascota para supervisiones con fecha de entrada durante 2024.
*/

SELECT b.nroBox, b.m2, b.ubicación, b.capacidad, m.nombre
FROM Box b
INNER JOIN Supervision s ON b.nroBox = s.nroBox
INNER JOIN Mascota m ON s.codMascota = m.codMascota
WHERE s.fechaEntra >= '2024-01-01' AND s.fechaEntra < '2025-01-01';