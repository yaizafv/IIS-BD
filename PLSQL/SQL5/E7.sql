create or replace PROCEDURE SQL5E7 AS 
    CURSOR c_depts IS
            SELECT d.department_id, d.department_name, d.location_id
            FROM Department d
            WHERE d.department_id NOT IN (
                SELECT DISTINCT e.department_id
                FROM Employee e
                WHERE e.job_id = 'SA_REP'
                  AND e.department_id IS NOT NULL
            )
            ORDER BY d.department_id;
BEGIN    
        FOR i IN c_depts LOOP
            DBMS_OUTPUT.PUT_LINE('ID: ' || i.department_id || 
                                 ' | Nombre: ' || RPAD(i.department_name, 20) || 
                                 ' | Localización: ' || i.location_id);
        END LOOP;
END SQL5E7;
