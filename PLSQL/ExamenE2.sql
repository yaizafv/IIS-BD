create or replace FUNCTION EXAMEN2 (PANIO IN NUMBER) RETURN Lawyer.lawyer_id%TYPE AS
v_lawyer_id Lawyer.lawyer_id%TYPE; 

BEGIN

    SELECT db.lawyer_id INTO v_lawyer_id
    FROM Defended_by db, Trial t, Involves i
    WHERE db.trial_id = t.trial_id
    AND db.accused_id = i.accused_id
    AND db.trial_id = i.trial_id
    AND t.status = 'finished'
    AND EXTRACT(YEAR FROM t.end_date) = PANIO
    AND i.verdict = 'acquitted'
    GROUP BY db.lawyer_id
    ORDER BY COUNT(*) DESC
    FETCH FIRST 1 ROW ONLY;
    
  RETURN v_lawyer_id;
  
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No hay defensores para el año ' || PANIO);

END EXAMEN2;
