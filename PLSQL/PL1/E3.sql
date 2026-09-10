create or replace PROCEDURE PL1E3 
(
  PNOMBRE IN VARCHAR2 
) AS 
BEGIN
    dbms_output.put_line('Hola'||pnombre);
END PL1E3;
