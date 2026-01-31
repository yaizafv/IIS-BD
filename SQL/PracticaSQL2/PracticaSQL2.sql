-- Práctica SQL2

-- 1) Obtener los registros de la relación Carmaker para las que el atributo ciudad es Barcelona. 
SELECT * FROM Carmaker WHERE cityCM = 'barcelona' 

-- 2) Obtener los registros de la relación Customer para aquellos clientes de Madrid cuyo apellido es
-- Garcia. 
SELECT * FROM Customer WHERE City = 'madrid' AND Surname = 'garcia'
-- Lo mismo para los clientes que cumplen alguna de esas dos condiciones. 
SELECT * FROM Customer WHERE City = 'madrid' OR Surname = 'garcia'

-- 3) Obtener los valores de los atributos surname y city de todas los registros de la entidad
-- Customer. 
SELECT name, surname, city FROM Customer

-- 4) Obtener los valores del atributo surnames de los clientes (relación Customer) cuyo atributo
-- city sea Madrid. 
SELECT surname FROM Customer WHERE city = 'madrid'

-- 5) Obtener los valores del atributo name y surname de los clients (relación Customer) que han
-- comprado coche de color rojo (valor red del atributo color). 
SELECT name, surname FROM customer.sale WHERE color = 'red'	-- con duplicados
SELECT DISTINCT name, surname FROM customer.sale WHERE color = 'red' 	-- sin duplicados pero resultado parcialmente incorrecto
SELECT DISTINCT name, surname FROM customer.sale WHERE color = 'red' AND Customer.nif = Sale.nif	-- join 

-- 6) Obtener los nombres de las marcas (relación Carmaker) que tienen modelos (atributo model)
-- ‘gtd’. 
SELECT nameCM FROM Carmaker WHERE Car.model = 'gtd'


