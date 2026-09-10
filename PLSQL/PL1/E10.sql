create or replace PROCEDURE PL1E10 (PCIFD IN sale.cifD%TYPE , 
PNUMVENTAS OUT distribution.cifD%TYPE ) AS 
BEGIN
    SELECT Count(cifD) into pnumventas
    FROM Sale
    WHERE cifD = pcifd;
END PL1E10;
