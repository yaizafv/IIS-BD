create or replace PROCEDURE PL4E1 (p_branch_name IN Branch.branch_name%TYPE) AS 
    CURSOR c_all_clients IS 
        SELECT B.client_name
        FROM Borrowed_By B JOIN Loan L ON B.loan_number = L.loan_number
        WHERE L.branch_name = p_branch_name
        UNION 
        Select O.client_name
        from Owned_By O join Account A ON O.account_number = A.account_number
        WHERE A.branch_name = p_branch_name;                       
                      
    CURSOR c_loans_by_client ( p_client_name Client.client_name%TYPE,
                               p_branch_name Branch.branch_name%TYPE) IS 
        SELECT L.loan_number, L.amount 
        from Borrowed_By B join Loan L ON B.loan_number = L.loan_number
        WHERE b.client_name = p_client_name 
        AND L.branch_name = p_branch_name;
        
    CURSOR c_accs_by_client ( p_client_name Client.client_name%TYPE,
                              p_branch_name Branch.branch_name%TYPE) IS 
        SELECT A.account_number, A.balance
        from Owned_By O join Account A ON O.account_number = A.account_number
        WHERE O.client_name = p_client_name 
        AND A.branch_name = p_branch_name;
        
  BEGIN
    FOR cli IN c_all_clients LOOP
      DBMS_OUTPUT.PUT_LINE('Client: ' || cli.client_name);
      FOR loan IN c_loans_by_client(cli.client_name, p_branch_name) LOOP
        DBMS_OUTPUT.PUT_LINE('    ---> Loan: ' || loan.loan_number || '  ' || loan.amount);
      END LOOP;
      FOR accnt IN c_accs_by_client(cli.client_name, p_branch_name) LOOP
        DBMS_OUTPUT.PUT_LINE('    ---> Account: ' || accnt.account_number || '  ' || accnt.balance);
      END LOOP;
    END LOOP;
   
END PL4E1;
