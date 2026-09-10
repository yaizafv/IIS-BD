create or replace PROCEDURE PL1E11 
(
  PNIF IN sale.cifD%TYPE 
, PCARS OUT number 
, PDEALERS OUT number 
) AS 
BEGIN
    SELECT COUNT(codeCar), COUNT(DISTINCT cifD) INTO PCARS, PDEALERS
    FROM Sale
    WHERE nif = PNIF;
END PL1E11;
