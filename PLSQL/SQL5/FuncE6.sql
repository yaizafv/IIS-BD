create or replace FUNCTION FSQL5E6(p_min_salary OUT NUMBER) RETURN VARCHAR2 AS 
v_dept_id NUMBER;
BEGIN
    SELECT department_id, MIN(salary) INTO v_dept_id, p_min_salary
    FROM Employee
    WHERE department_id IS NOT NULL
    GROUP BY department_id
    HAVING AVG(salary) = (
        SELECT MAX(AVG(salary))
        FROM Employee
        WHERE department_id IS NOT NULL
        GROUP BY department_id
    )
    FETCH FIRST 1 ROW ONLY; 

    RETURN v_dept_id;
  
END FSQL5E6;
