create or replace PROCEDURE SQL4E1 AS 
vName Client.client_name%TYPE;
cursor c1 is SELECT Client.client_name 
FROM Client, Borrowed_By, Loan
WHERE Client.client_name = Borrowed_By.client_name
AND Borrowed_By.loan_number = Loan.loan_number
AND Loan.branch_name = 'Perryridge';
BEGIN
  OPEN c1;
    FETCH c1 into vName;
    WHILE (c1%FOUND) loop
       DBMS_OUTPUT.put_line(vName);
       FETCH c1 into vName;
    END LOOP;
    CLOSE c1;
END SQL4E1;
