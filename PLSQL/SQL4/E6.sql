create or replace PROCEDURE SQL4E6 AS 
vName Client.client_name%TYPE;
cursor c1 is SELECT DISTINCT c.client_name
FROM Client c, Owned_By ob, Account a
WHERE c.client_name = ob.client_name
  AND ob.account_number = a.account_number
  AND a.branch_name = 'Perryridge'
ORDER BY c.client_name;
BEGIN
  OPEN c1;
    FETCH c1 into vName;
    WHILE (c1%FOUND) loop
       DBMS_OUTPUT.put_line(vName);
       FETCH c1 into vName;
    END LOOP;
    CLOSE c1;
END SQL4E6;
