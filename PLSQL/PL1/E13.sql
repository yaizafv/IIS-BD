create or replace PROCEDURE PL1E13 (PNIF IN customer.nif%TYPE) AS 
      CURSOR c1 IS 
        SELECT C.codecar, namecar, model, color
        FROM car C, sale V
        WHERE v.nif=pnif AND V.codecar = C.codecar;
      
    vUnCliente customer%ROWTYPE;   
    vNumCars NUMBER;
    vNumDealers NUMBER; 	
BEGIN
    select  c.nif, name, surname,city into vunCliente
    from customer c 
    where c.nif=pnif;
	
   SELECT COUNT(*), COUNT(DISTINCT cifd) INTO vNumCars,vNumDealers
   FROM sale
   WHERE nif=pnif;
	
    DBMS_OUTPUT.PUT_LINE('- Customer: '||vUnCliente.name||' '||vUnCliente.surname || ' ' || vNumCars || ' ' || vNumDealers);
    
	FOR i IN c1 LOOP
        DBMS_OUTPUT.PUT_LINE('---> Car: '||i.codecar||' '||i.namecar||' '||i.model||' '||i.color);
    END LOOP;
	
EXCEPTION
		WHEN NO_DATA_FOUND THEN
			RAISE_APPLICATION_ERROR(-20001,'Incorrect customer data');
		WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR(-20002,'Error'||sqlcode||' '||sqlerrm);
END PL1E13;
