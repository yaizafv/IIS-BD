create or replace PROCEDURE SQL3E23 AS 
CURSOR c1 IS SELECT A.au_name, A.au_surname
            FROM Author A 
            WHERE A.au_id in ( SELECT au_id 
                                FROM WRITTEN_BY
                                WHERE contribution_rate = 1
                                INTERSECT
                                SELECT au_id 
                                FROM WRITTEN_BY
                                WHERE contribution_rate < 1);
BEGIN
      FOR i IN c1 LOOP
            DBMS_OUTPUT.PUT_LINE(i.au_name ||i.au_surname);
      end loop;
END SQL3E23;
