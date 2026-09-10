create or replace PROCEDURE PL1E8 AS 
vName user_objects.object_name%TYPE;
vType user_objects.object_type%TYPE;
cursor c1 is SELECT object_name, object_type FROM user_objects;
BEGIN
    OPEN c1;
    FETCH c1 into vName, vType;
    WHILE (c1%FOUND) loop
       DBMS_OUTPUT.put_line('Nombre: '||vName||' Tipo: '||vType);
       FETCH c1 into vName,vType;
    END LOOP;
    CLOSE c1;
END PL1E8;
