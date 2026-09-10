create or replace PROCEDURE SQL3E21 AS 
CURSOR c1 IS SELECT t1.title, T1.price
                    FROM Title T1 
                    ORDER BY T1.price ASC
                    FETCH FIRST 1 ROWS WITH TIES;
BEGIN
    FOR i IN c1 LOOP
        DBMS_OUTPUT.PUT_LINE(i.title ||i.price);
    end loop;
END SQL3E21;
