create or replace FUNCTION TUTORIAE2A RETURN VARCHAR2 AS 
vGenre film.genre%TYPE;
BEGIN
    SELECT genre INTO vGenre
    FROM Film
    WHERE film_code IN (
        SELECT film_code
        FROM Screening
        WHERE session_number = (SELECT Max(session_number) FROM Screening)
        GROUP BY film_code
        ORDER BY SUM(tickets_sold) DESC 
        FETCH NEXT 1 ROWS ONLY
    );
    RETURN vGenre;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        raise_application_error (-20001, 'No se han encontrado datos');
END TUTORIAE2A;
