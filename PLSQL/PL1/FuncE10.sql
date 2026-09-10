create or replace FUNCTION FPL1E10 (PCIFD IN sale.cifD%TYPE, pDealers OUT number) RETURN NUMBER AS 
vNumVentas number;
BEGIN
    SELECT COUNT(codeCar), COUNT(DISTINCT cifD) INTO vNumVentas, pDealers
    FROM Sale
    WHERE cifD = pcifd;
    RETURN vNumVentas;
END FPL1E10;
