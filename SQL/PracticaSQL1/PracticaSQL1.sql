-- Práctica SQL1

-- 1)  Realizar una consulta básica en SQL que devuelva todos los datos sobre los coches que están
-- almacenados en la tabla Car. 
SELECT * FROM car

-- 2)  Realizar una consulta básica en SQL que devuelva todos los datos sobre los coches cuyo
-- modelo sea gtd que están almacenados en la tabla Car
SELECT * FROM car where model = 'gtd'

-- 3) Insertar un coche en la tabla Car. 
INSERT into car (codeCar, nameCar, model)
        values ('99', 'clio', 'gtx')	    		-- si se omite un atributo se le pone null
INSERT into car values ('99', 'clio', 'gtx')		-- solo funciona si es con todos los atributos

-- 4) Actualizar o modificar los datos de un coche de la tabla coches. 
UPDATE car SET namecar = 'megane', model = 'mtx' WHERE codecar = '99'

-- 5) Eliminar el coche recientemente insertado en la tabla coche
DELETE FROM car WHERE codecar = '99'
DROP TABLE car -- elimina fisicamente la tabla

