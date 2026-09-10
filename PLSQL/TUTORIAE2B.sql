create or replace PROCEDURE TUTORIAE2B (PCITY IN cinema.city%TYPE) AS 
cursor c1 is SELECT c.cinema_code, sum(price) as totalRevenue
            FROM cinema c, room r, ticket t
            WHERE c.cinema_code=r.cinema_code AND r.room_code=t.room_code AND city=pcity
            GROUP BY c.cinema_code;
cursor c2 (PCODCINE CINEMA.cinema_code%TYPE) is SELECT t.film_code, title, sum(price) as totalRevenueFilm
            FROM ticket t INNER JOIN film f ON t.film_code = f.film_code
                   INNER JOIN room r ON r.room_code = t.room_code
            WHERE cinema_code = PCODCINE
            GROUP BY t.film_code, title;
BEGIN
    for i in c1 loop
        dbms_output.put_line('Cinema: '||i.cinema_code||' '||i.totalRevenue);
            for j in c2(i.cinema_code) loop
                dbms_output.put_line('      -->Film: '||j.film_code||' '||j.title||' '||j.totalRevenueFilm);
            end loop;
    end loop;
END TUTORIAE2B;
