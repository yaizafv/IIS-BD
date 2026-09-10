create or replace PROCEDURE SQL4E8 AS 
vName Client.client_name%TYPE;
cursor c1 is SELECT AVG(a.balance) AS promedio_saldos
FROM Client c, Owned_By ob, Account a
WHERE c.client_name = ob.client_name
  AND ob.account_number = a.account_number
  AND c.client_city = 'Harrison'
  AND c.client_name IN (
        SELECT ob2.client_name
        FROM Owned_By ob2
        GROUP BY ob2.client_name
        HAVING COUNT(ob2.account_number) >= 2
);
BEGIN
  OPEN c1;
    FETCH c1 into vName;
    WHILE (c1%FOUND) loop
       DBMS_OUTPUT.put_line(vName);
       FETCH c1 into vName;
    END LOOP;
    CLOSE c1;
END SQL4E8;
