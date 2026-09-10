create or replace PROCEDURE SQL5E12 AS 
    v_emp_id       Employee.employee_id%TYPE;
    v_emp_sal      Employee.salary%TYPE;
    v_sup_id       Employee.employee_id%TYPE;
    v_sup_sal      Employee.salary%TYPE;
    v_diff         NUMBER;
BEGIN
    SELECT emp_id, emp_salary, sup_id, sup_salary, diff
    INTO v_emp_id, v_emp_sal, v_sup_id, v_sup_sal, v_diff
    FROM (
        SELECT 
            e.employee_id AS emp_id, 
            e.salary      AS emp_salary, 
            m.employee_id AS sup_id, 
            m.salary      AS sup_salary,
            ABS(e.salary - m.salary) AS diff
        FROM Employee e
        JOIN Employee m ON e.employee_id = m.employee_id -- Relación de supervisión
        WHERE e.employee_id IS NOT NULL -- Aseguramos que tenga supervisor
        ORDER BY diff ASC
    )
    WHERE ROWNUM = 1; -- Nos quedamos solo con el que tiene la menor diferencia

    DBMS_OUTPUT.PUT_LINE('Empleado: ID ' || v_emp_id || ' | Salario: ' || v_emp_sal);
    DBMS_OUTPUT.PUT_LINE('Supervisor: ID ' || v_sup_id || ' | Salario: ' || v_sup_sal);
    DBMS_OUTPUT.PUT_LINE('Diferencia: ' || v_diff);
END SQL5E12;
