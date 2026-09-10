create or replace PROCEDURE SQL4E4 AS 
vName Client.client_name%TYPE;
cursor c1 is SELECT b1.branch_name
FROM branch b1
WHERE EXISTS (
    SELECT *
    FROM branch b2
    WHERE b2.branch_city = 'Brooklyn'
      AND b1.assets > b2.assets
);
BEGIN
  OPEN c1;
    FETCH c1 into vName;
    WHILE (c1%FOUND) loop
       DBMS_OUTPUT.put_line(vName);
       FETCH c1 into vName;
    END LOOP;
    CLOSE c1;
END SQL4E4;
