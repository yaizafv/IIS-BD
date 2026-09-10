create or replace PROCEDURE PL1E5 (PCIFD IN distribution.cifD%TYPE) AS 
vCoches distribution.stock%TYPE;
BEGIN
    SELECT Sum(stock) INTO vCoches
    FROM Distribution
    WHERE cifD = pCifD;
    dbms_output.put_line('El número total de coches en el concesionario '|| pCifD || 
    ' es de: ' || vCoches); 
END PL1E5;
