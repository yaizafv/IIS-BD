create or replace PROCEDURE SQL5E16(p_cantidadX IN NUMBER) AS 
v_rows_affected NUMBER;
BEGIN
  UPDATE Employee e
    SET e.salary = e.salary * 1.15
    WHERE EXISTS (
        SELECT 1 
        FROM Job j 
        WHERE j.job_id = e.job_id 
          AND j.min_salary = p_cantidadX
    );

    -- Guardamos el número de filas modificadas para informar al usuario
    v_rows_affected := SQL%ROWCOUNT;

    IF v_rows_affected > 0 THEN
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Actualización exitosa: ' || v_rows_affected || ' empleados recibieron el aumento.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No se encontraron empleados en puestos con salario mínimo igual a: ' || p_cantidadX);
    END IF;
END SQL5E16;
