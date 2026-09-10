create or replace PROCEDURE PL1E4 AS 
--vMax number(20,0);
--vMin number(20,0);
vMax distribution.stock%TYPE;   --para no tener que ir a mirar el tipo a la tabla
vMin vMax%TYPE;  --declara la variable vMin del mismo tipo que vMax
--vMin distribution.stock%TYPE;
BEGIN
    SELECT Max(stock), Min(stock) INTO vMax, vMin
    FROM Distribution;
    dbms_output.put_line('El valor máximo es: '||vMax);
    dbms_output.put_line('El valor mínimo es: '||vMin);
END PL1E4;
