create or replace PROCEDURE PL1E7 AS 
v customer%ROWTYPE;  -- variable de tipo registro
vExiste number;
cursor c1 is SELECT  nif, name, surname, city FROM Customer;
--BEGIN
    -- SELECT  nif, name, surname, city INTO vNif, vName, vSurname, vCity
    --el into solo funciona cuando la select devuelve solo una fila
    -- DBMS_OUTPUT.put_line('Cliente: '||vNif||' '||vName||' '||vSurname||' '||vCity);
-- con while:
--     OPEN c1;
--     FETCH c1 into v;
--    WHILE (c1%FOUND) loop
--        DBMS_OUTPUT.put_line('Cliente: '||v.nif||' '||v.name||' '||v.surname||' '||v.city);
--        FETCH c1 into v;
--     END LOOP;
--     CLOSE c1;
-- con do-while:
-- LOOP
    -- fetch c1 into v;
    -- no puede ir aqui DBMS_OUTPUT.put_line('Cliente: '||v.Nif||' '||v.Name||' '||v.Surname||' '||v.City); porque se repetiria la última fila
    -- EXIT WHEN (c1%NOTFOUND);
     -- DBMS_OUTPUT.put_line('Cliente: '||v.nif||' '||v.name||' '||v.surname||' '||v.city);
    -- END LOOP;
    -- CLOSE c1;
-- con for:
/*    for i in c1 loop
        DBMS_OUTPUT.put_line('Cliente: '||i.nif||' '||i.name||' '||i.surname||' '||i.city);
        SELECT Count(*) INTO vExiste FROM CustomerHistory WHERE nif = i.nif;
        IF (vExiste = 0) THEN
            INSERT INTO CustomerHistory(nif, name, surname, city)
                VALUES(i.nif, i.name, i.surname, i.city);
        ELSE
            UPDATE CustomerHistory set name = i.name, surname = i.surname, city = i.city
                WHERE nif = i.nif;
        END IF;
    END LOOP;
    commit;     -- confirma la transacción y queda permanentemente almacenado en la tabla
*/
    
-- Con excepciones:
BEGIN
    for i in c1 loop
        DECLARE
        BEGIN
        DBMS_OUTPUT.put_line('Cliente: '||i.nif||' '||i.name||' '||i.surname||' '||i.city);
        INSERT INTO CustomerHistory(nif, name, surname, city)
                VALUES(i.nif, i.name, i.surname, i.city);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
            UPDATE CustomerHistory set name = i.name, surname = i.surname, city = i.city
                    WHERE nif = i.nif;
        END;
    END LOOP;
    commit;    

END PL1E7;
