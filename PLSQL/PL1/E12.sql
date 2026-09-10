create or replace PROCEDURE PL1E12 AS 
CURSOR cCustomer IS   -- ver comentario que está al final de este procedimiento
        SELECT DISTINCT c.nif, name, surname				
        FROM customer C, sale S
        WHERE C.nif = S.nif;
        
CURSOR cCars (pnif sale.nif%TYPE) IS 
        SELECT C.codecar, namecar, model, color
        FROM car C, sale V
        WHERE V.nif = pnif AND V.codecar = C.codecar;
        
vNumCars NUMBER;
vNumDealers NUMBER;  
BEGIN
    FOR i IN cCustomer LOOP
        SELECT COUNT(*), COUNT(DISTINCT cifd) INTO vNumCars,vNumDealers
        FROM sale
        WHERE nif=i.nif;
		
        DBMS_OUTPUT.PUT_LINE('- Customer: '||i.name||' '||i.surname||' '||vNumCars||' '||vNumDealers);
		
        FOR j IN cCars(i.nif) LOOP
            DBMS_OUTPUT.PUT_LINE('---> Car: '||j.codecar||' '||j.namecar||' '||j.model||' '||j.color);
        END LOOP;
    END LOOP;

-- COMENTARIO:  En este listado los datos que se solicitan del cliente los obtenemos en dos consultas. 
-- Primero sacamos sus datos personales con un cursor y luego calculamos para 
-- cada cliente con un SELECT... into los datos que nos faltan. 
-- Esto podría haberse hecho con una única consulta obteniendo todos los datos en el cursor (tal y como se muestra a 
-- continuación) y evitandolos SELECT..into. 
-- Esta opción está lígeramente mejor porque se hace en una única consulta pero recordad que lo importante, 
-- ante todo, es que funcione y  el resultado esté correcto. 

/*CURSOR cCustomer IS
		SELECT s.nif, name, surname, COUNT(*)numCars,COUNT(DISTINCT cifd)numDealers
			FROM sale s, customer c 
			WHERE s.nif = c.nif
			group by s.nif,name,surname;*/

END PL1E12;
