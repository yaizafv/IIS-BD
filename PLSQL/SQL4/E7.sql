create or replace PROCEDURE SQL4E7 AS 
vName Client.client_name%TYPE;
cursor c1 is SELECT branch_name
FROM Account
GROUP BY branch_name
HAVING AVG(balance) = (
    SELECT MAX(AVG(balance))
    FROM Account
    GROUP BY branch_name
);
BEGIN
  OPEN c1;
    FETCH c1 into vName;
    WHILE (c1%FOUND) loop
       DBMS_OUTPUT.put_line(vName);
       FETCH c1 into vName;
    END LOOP;
    CLOSE c1;
END SQL4E7;
