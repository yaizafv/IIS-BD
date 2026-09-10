create or replace PROCEDURE PL1E6 AS 
vS number; vC number; vCR number; vCu number; vD number;
BEGIN
    DELETE FROM Total;   -- para que si se ejecuta el codigo mas de una vez no se inserten las filas más de una vez (no se exige en el ejercicio)
    SELECT Count(*) INTO vS FROM Sale;
    SELECT Count(*) INTO vC FROM Car;
    SELECT Count(*) INTO vCR FROM Carmaker;
    SELECT Count(*) INTO vCu FROM Customer;
    SELECT Count(*) INTO vD FROM Dealer;
    
    INSERT INTO Total(tnsales, tncars, tncarmakers, tncustomers, tndealers)
    VALUES(vS, vC, vCR, vCu, vD);
    commit;
END PL1E6;
