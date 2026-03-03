-- Práctica SQL2

-- 1) Obtener los registros de la relación Carmaker para las que el atributo ciudad es Barcelona. 
SELECT * 
FROM Carmaker 
WHERE cityCM = 'barcelona' 

-- 2) Obtener los registros de la relación Customer para aquellos clientes de Madrid cuyo apellido es
-- Garcia. 
SELECT * 
FROM Customer 
WHERE City = 'madrid' 
AND Surname = 'garcia'
order by surname desc, name asc
-- Lo mismo para los clientes que cumplen alguna de esas dos condiciones. 
SELECT * 
FROM Customer 
WHERE City = 'madrid' 
OR Surname = 'garcia'

-- 3) Obtener los valores de los atributos surname y city de todas los registros de la entidad
-- Customer. 
SELECT name, surname, city 
FROM Customer

-- 4) Obtener los valores del atributo surnames de los clientes (relación Customer) cuyo atributo
-- city sea Madrid. 
SELECT surname FROM Customer 
WHERE city = 'madrid'

-- 5) Obtener los valores del atributo name y surname de los clients (relación Customer) que han
-- comprado coche de color rojo (valor red del atributo color). 
SELECT name, surname 
FROM Customer, Sale
WHERE color = 'red'	-- con duplicados

SELECT DISTINCT name, surname 
FROM Customer, Sale
WHERE color = 'red' 	-- sin duplicados pero resultado parcialmente incorrecto

SELECT DISTINCT name, surname 
FROM Customer c, Sale s
WHERE color = 'red' 
AND c.nif = s.nif	-- join 

SELECT DISTINCT name, surname 
FROM Customer 
INNER JOIN Sale s 
ON c.nif = s.nif
WHERE color = 'red'

-- 6) Obtener los nombres de las marcas (relación Carmaker) que tienen modelos (atributo model)
-- ‘gtd’. 
SELECT DISTINCT nameCM      -- para que no salgan repetidos
FROM Carmaker, Manufacture, Car 
WHERE Car.model = 'gtd' 
AND Manufacture.codeCar = Car.codeCar 
AND Manufacture.cifCM = Carmaker.cifCM

-- 7) Obtener el nombre de las marcas (relación Carmaker) de las que se han vendido coches de
-- color rojo. 
SELECT nameCM 
FROM Sale, Car, Manufacture, Carmaker 
WHERE Sale.color = 'red' 
AND Sale.codeCar = Car.codeCar 
AND Car.codeCar = Manufacture.codeCar 
AND Manufacture.cifCM = Carmaker.cifCM

-- Consulta sin Car (mejor solución)
SELECT nameCM 
FROM Sale, Manufacture, Carmaker 
WHERE Sale.color = 'red' 
AND Sale.codeCar = Manufacture.codeCar 
AND Manufacture.cifCM = Carmaker.cifCM

-- **** 8) Obtener el nombre de los coches (relación Car) que tengan los mismos modelos que el coche
-- cuyo nombre es Cordoba.

-- a) Nombres de los coches cuyo modelo es...
SELECT nameCar 
FROM Car
WHERE model = 'gtd'

-- b) modelos que el coche cuyo nombre es corboba
SELECT model 
FROM Car
WHERE nameCar = 'cordoba'

-- Completo:
SELECT nameCar 
FROM Car
WHERE model = (SELECT model 
FROM Car
WHERE nameCar = 'cordoba')      -- esto solo funciona si la consulta dentro del paréntesis tiene un resultado

SELECT nameCar 
FROM Car
WHERE model IN (SELECT model 
FROM Car
WHERE nameCar = 'cordoba')

SELECT c2.nameCar
FROM Car c1, Car c2
WHERE  c1.nameCar = 'cordoba'
AND c1.model = c2.model

SELECT count(*)     -- devuelve el número de filas de car
FROM Car

-- 9) Obtener todos los pares de nombres de coches (relación Car) distintos (es decir, excluyendo
-- pares cuyas dos componentes sean la misma y también pares simétricos) que tengan el mismo
-- modelo.
SELECT c1.nameCar, c2.nameCar
FROM Car c1, Car c2
WHERE c1.nameCar < c2.nameCar
AND c1.model = c2.model

-- 10) Obtener los nombres de los coches que no tengan el modelo GTD. 
SELECT DISTINCT nameCar
FROM Car
WHERE nameCar NOT IN(
SELECT nameCar
FROM Car
WHERE model = 'gtd') 

SELECT nameCar FROM Car     -- no hace falta distinct en este caso porque los quita automáticamente
MINUS
SELECT nameCar FROM Car WHERE model = 'gtd'

-- 11) Obtener todas las parejas de valores de los atributos CifCM de la relación Carmaker y NIF de
-- la relación Customer que sean de la misma ciudad. Lo mismo para los que no sean de la misma
-- ciudad. 
SELECT cifCM, nif
FROM Carmaker, Customer 
WHERE Carmaker.cityCM = Customer.city

-- 12) Obtener los valores del atributo codeCar para los coches que se encuentran en algún
-- concesionario (relación Dealer) de Barcelona. 
SELECT codeCar 
FROM Distribution, Dealer 
WHERE Dealer.cityD = 'barcelona' 
AND Dealer.cifD = Distribution.cifD

-- 13) Obtener los valores del atributo codeCar para los coches que han sido adquiridos por un
-- cliente de Madrid en un concesionario de Madrid. 
SELECT codeCar 
FROM Sale, Customer, Dealer 
WHERE Customer.city = 'madrid' 
AND Customer.nif = Sale.nif 
AND Sale.cifD = Dealer.cifD 
AND Dealer.cityD = 'madrid' 

-- 14) Obtener los valores del atributo codeCar para los coches comprados en un concesionario de la
-- misma ciudad que la del cliente que lo compra. 
SELECT DISTINCT codeCar 
FROM Sale, Customer, Dealer 
WHERE Customer.city = Dealer.cityD 
AND Customer.nif = Sale.nif 
AND Sale.cifD = Dealer.cifD

-- 15) Obtener todas las parejas de nombres de marcas que sean de la misma ciudad. 
SELECT c1.nameCM, c2.nameCM
FROM Carmaker c1, Carmaker c2
WHERE c1.cityCM = c2.cityCM
AND c1.cifCM != c2.cifCM
AND c1.cifCM < c2.cifCM     -- para que no salgan repes

-- 16) Obtener el NIF de los clientes que han comprado algún coche en un concesionario de Madrid. 
SELECT DISTINCT Sale.nif -- (un cliente pudo haber comprado varios coches)
FROM Sale, Dealer 
WHERE Dealer.cityD = 'madrid' 
AND Sale.cifD = Dealer.cifD  

SELECT DISTINCT S.nif 
FROM Sale S INNER JOIN Dealer D ON S.cifD=D.cifD
WHERE D.cityD='madrid';

SELECT DISTINCT nif
FROM Sale
WHERE EXISTS (SELECT * FROM Dealer 
WHERE cityD = 'madrid' 
AND Sale.cifD = Dealer.cifD)

-- 17) Obtener los colores de los coches vendidos por el concesionario Acar. 
SELECT color 
FROM Sale, Dealer 
WHERE Dealer.nameD = 'acar' 
AND Sale.cifD = Dealer.cifD

-- 18) Obtener los valores del atributo codeCar para los coches vendidos por algún concesionario de
-- Madrid. 
SELECT codeCar 
FROM Sale, Dealer 
WHERE Dealer.cityD = 'madrid' 
AND Sale.cifD = Dealer.cifD

-- 19) Obtener todos los nombres de los clientes que hayan adquirido algún coche en el
-- concesionario Dcar. 
SELECT name
FROM Customer, Sale, Dealer
WHERE Dealer.nameD = 'dcar'
AND Customer.nif = Sale.nif
AND Sale.cifD = Dealer.cifD

-- 20) Obtener el nombre y apellido de los clientes que hayan comprador un GTI blanco (valor white
-- del atributo color). 
SELECT name, surname
FROM Customer, Sale, Car
WHERE Customer.nif = Sale.nif
AND Sale.color = 'white'
AND Sale.codeCar = Car.codeCar
AND Car.model = 'gti'

-- **** 21) Obtener el nombre y el apellido de los clientes que han adquirido un automóvil en un
-- concesionario de Madrid que dispone de coches del modelo GTI. 
SELECT DISTINCT name, surname
FROM Customer, Sale, Dealer, Distribution, Car
WHERE Customer.nif = Sale.nif 
AND Sale.cifD = Dealer.cifD  
AND Dealer.cityD = 'madrid'
AND Dealer.cifD = Distribution.cifD
AND Distribution.stock > 0
AND Distribution.codeCar = Car.codeCar
AND Car.model = 'gti'
-- no solicitado en el ejercicio:
-- AND Sale.codeCar = Car.codeCar   -- con esta línea el coche que compró también es gti, sino no tiene por qué

-- 22) Obtener el nombre y el apellido de los clientes que han comprado como mínimo un coche
-- blanco y un coche rojo. 
SELECT name, surname
FROM Customer c
WHERE c.nif IN (SELECT s.nif
FROM Sale s
WHERE s.color = 'white')
AND c.nif IN (SELECT s.nif
FROM Sale s
WHERE s.color = 'red')

SELECT name, surname
FROM Customer
WHERE nif IN(SELECT nif FROM Sale WHERE color = 'red'
INTERSECT
SELECT nif FROM Sale WHERE color = 'white')
-- si haces el intersect con el nombre y apellidos no seria correcto porque debe hacerlo con el nif
SELECT name,surname
FROM Sale S1, Sale S2, Customer C
WHERE S1.color='white' AND S2.color='red' AND S1.nif=S2.nif AND S1.nif=C.nif

-- ****** 23) Obtener los valores del atributo NIF para los clientes que sólo han comprado coches al
-- concesionario con cifD = 1. 
SELECT nif
FROM Sale s
WHERE s.nif NOT IN (SELECT nif
FROM Sale
WHERE cifD != 1)

(SELECT nif FROM Sale)
MINUS --others RDBMS EXCEPT
(SELECT DISTINCT nif FROM Sale WHERE cifD != '1');

-- 24) Obtener los nombres de los clientes que no han comprado coches de color rojo en
-- concesionarios de Madrid. 
SELECT DISTINCT C.name
FROM Customer C 
WHERE C.nif NOT IN ( SELECT S.nif 
                    FROM Sale S INNER JOIN Dealer D ON S.cifD=D.cifD
                    WHERE S.color='red' AND D.cityD='madrid' );

SELECT DISTINCT C.name
FROM customer C, sale S
WHERE S.nif=C.nif AND C.nif NOT IN (SELECT S.nif
    FROM dealer D, sale S
    WHERE D.cifd=S.cifd AND D.cityd='madrid' AND S.color='red');

SELECT DISTINCT C.name
FROM customer C INNER JOIN sale S ON S.nif=C.nif
WHERE C.nif NOT IN (SELECT S.nif
    FROM dealer D INNER JOIN sale S ON D.cifd=S.cifd
    WHERE D.cityd='madrid' AND S.color='red');

SELECT name
FROM customer
WHERE nif IN ((SELECT nif FROM sale)
    MINUS --others RDBMS EXCEPT
    (SELECT nif FROM dealer D, sale S WHERE D.cifd=S.cifd AND D.cityd='madrid' AND S.color='red'));


-- 25) Mostrar para cada concesionario (cifD) la cantidad total de coches que contiene. 
SELECT cifD, Sum(stock)
FROM Distribution 
GROUP BY cifD

-- 26) Mostrar el cifD de aquellos concesionarios cuyo promedio de coches almacenados en él supera
-- las 10 unidades. Mostrar también dicho promedio. 
SELECT cifD, Avg(stock)
FROM Distribution 
GROUP BY cifD
HAVING Avg(stock) > 10

-- 27) Obtener el cifD de todos los concesionarios que disponen de una cantidad de coches
-- comprendida entre 10 y 18 unidades, ambas inclusive. 
SELECT cifD
FROM Distribution
GROUP BY cifD
HAVING sum(stock) >= 10 and sum(stock) <= 18   -- having sum(stock) between 10 and 18

-- 28) Obtener el número de marcas (Carmakers) y el número de ciudades distintas donde están
-- ubicadas. 
SELECT count(cifCM) AS total_cif, count(distinct cityCM) AS total_ci-- cuenta las filas en las que el atributo es no nulo
FROM Carmaker

-- 29) Obtener el nombre y los apellidos de todos los clientes que se han comprado un coche en un
-- concesionario de Madrid y cuyo nombre comienza por j.
SELECT DISTINCT name, surname
FROM Customer, Sale, Dealer
WHERE Customer.nif = Sale.nif
AND Sale.cifD = Dealer.cifD
AND Dealer.cityD = 'madrid'
AND Customer.name like 'j%'
-- j% -> cualquier conjunto de caracteres
-- j_ -> un caracter

-- 30) Obtener el nombre y apellido de los clientes en orden alfabético por nombre. 
SELECT name, surname
FROM Customer
order by name asc   -- si no pones asc ordena asc por defecto

-- 31) Obtener la lista de clientes que han comprado un coche en el mismo concesionario que el
-- cliente con NIF = 2 (excluyendo al propio cliente con NIF = 2). Hacer lo mismo con el NIF
-- = 1. 
SELECT DISTINCT c.nif, c.name, c.surname
FROM Customer c
JOIN Sale s ON s.nif = c.nif
WHERE s.cifD IN (
    SELECT cifD
    FROM Sale
    WHERE nif = 2
)
AND c.nif != 2;

SELECT DISTINCT c.nif, c.name, c.surname
FROM Customer c
JOIN Sale s ON s.nif = c.nif
WHERE s.cifD IN (       -- si pones un = en lugar del in está mal porque la subconsulta devuelve más de un valor
    SELECT cifD
    FROM Sale
    WHERE nif = 1
)
AND c.nif != 1;

-- 32) Obtener un listado de los concesionarios (atributos cifD, named, cityD) cuyo total de unidades
-- supera al promedio global de unidades de todos los concesionarios

-- Total de unidades por cada concesionario. Mostrar solo las que el número de unidades sea mayor que 20
SELECT cifD, Sum(stock)
FROM Distribution
GROUP BY cifD
HAVING Sum(stock) > 20

-- Promedio global de unidades de todos los concesionarios
SELECT Sum(stock) / Count(DISTINCT cifD) as promedio         --no se puede usar avg porque no hay el mimso numero de stock que de concesionarios
FROM Distribution

SELECT Avg(Sum(stock)) 
FROM Distribution
GROUP BY cifD

SELECT Avg(total)
FROM (
SELECT Sum(stock)total
FROM Distribution
GROUP BY cifD
)

-- Solución base (enlazamos las dos consultas):
SELECT cifD, Sum(stock)
FROM Distribution
GROUP BY cifD
HAVING Sum(stock) > (SELECT Sum(stock) / Count(DISTINCT cifD) as promedio FROM Distribution)

-- Solución final

-- Solución 1: utilizando IN. No podría mostrar el total en la select externa
SELECT cifD, nameD, cityD
FROM Dealer
WHERE cifD IN(
    SELECT cifD
    FROM Distribution
    GROUP BY cifD
    HAVING Sum(stock) > (SELECT Sum(stock) / Count(DISTINCT cifD) as promedio FROM Distribution)
)

-- Solución 2: poner consulta base en el from de otra
SELECT Dealer.cifD, nameD, cityD, total --total no lo pide, pero en este caso se puede sacar
FROM(
    SELECT cifD, Sum(stock) total
    FROM Distribution
    GROUP BY cifD
    HAVING Sum(stock) > (SELECT Sum(stock) / Count(DISTINCT cifD) as promedio FROM Distribution)
) temp, Dealer
WHERE Dealer.cifD = temp.cifD

-- Solucion 3: group by con varios atributos
SELECT Distribution.cifD, nameD, cityD, Sum(stock)total  -- en este caso también puedes sacar la suma
FROM Distribution, Dealer
WHERE Distribution.cifD = Dealer.cifD
GROUP BY Distribution.cifD, nameD, cityD
HAVING Sum(stock) > (SELECT Sum(stock) / Count(DISTINCT cifD) as promedio FROM Distribution)

-- 33) Obtener el concesionario que tiene el mejor promedio de coches entre todos los
-- concesionarios; es decir, el concesionario cuyo promedio de coches supera al promedio de
-- coches de cada uno del resto de concesionarios. 

-- Para cada concesionario su promedio de coches
SELECT cifD, Avg(stock) promedio
FROM Distribution
GROUP BY cifD 

-- Obtener aquellos concesionarios cuyo promedio sea el mayor
SELECT Max(Avg(stock)) promedio
FROM Distribution
GROUP BY cifD 

SELECT Max(promedio) 
FROM (
    SELECT cifD, Avg(stock) promedio
    FROM Distribution
    GROUP BY cifD 
)

-- Solución 1: uso de max
SELECT cifD, Avg(stock) promedio
FROM Distribution
GROUP BY cifD 
HAVING Avg(stock) >= (SELECT Max(promedio) 
                    FROM (
                        SELECT cifD, Avg(stock) promedio
                        FROM Distribution
                        GROUP BY cifD 
                    )
)

-- Solución 2: uso de all
SELECT cifD, Avg(stock) promedio
FROM Distribution
GROUP BY cifD 
HAVING Avg(stock) >= ALL (SELECT Avg(stock) promedio
                        FROM Distribution
                        GROUP BY cifD 
                        )
                        
-- Solución 3: uso de fetch
SELECT Distribution.cifD, nameD, cityD, Avg(stock) promedio
FROM Distribution, Dealer
GROUP BY Distribution.cifD, nameD, cityD 
order by Avg(stock) desc
fetch next 1 rows only
-- fetch first 1 row only (otra forma de ponerlo)

-- 34) Obtener los dos clientes que han comprado más coches en total, ordenados por el número de
-- coches comprados. 
SELECT Sale.nif, name, surname, count(codecar)
FROM Sale, Customer 
WHERE Customer.nif = Sale.nif
GROUP BY Sale.nif, name, surname
order by Count(codecar) desc
fetch next 2 rows only    

-- 35) Obtener las ventas de coches ordenadas por color. Queremos eliminar el primero y obtener los
-- 2 siguientes permitiendo empates (y sin permitirlos). 
SELECT * 
FROM Sale
order by color 
offset 1 row       -- descarta 1 fila
fetch next 2 rows only      --sin empates

SELECT * 
FROM Sale
order by color 
offset 1 row       -- descarta 1 fila
fetch next 3 rows with ties      --con empates (lo puse con 3 para que se vea el empate)

-- 36) Crear una vista a partir de la consulta 34. Utilizando dicha vista, obtener para cada uno de los
-- dos clientes que han comprado más coches en total, el código (codeCar) de los coches que
-- han comprado, el cifD del concesionario donde lo compraron y el color. 
CREATE VIEW customersmorecars AS
SELECT nif, name, surname
FROM Customer
WHERE nif IN (SELECT nif
                FROM Sale S
                GROUP BY nif
                ORDER BY count(codecar) DESC
                FETCH FIRST 2 ROWS ONLY
                );

SELECT s.nif, name, surname, codecar, cifd, color
FROM sale s, customersmorecars c
WHERE s.nif=c.nif;

