-- Obtener todos los datos de todos los jueces.

select * from Judge

-- Obtener el nombre y los años de experiencia de todos los fiscales.
select lawyer_name, prosecutor_experience_years
from lawyer, prosecutor
where lawyer.lawyer_id = prosecutor.lawyer_id

-- Obtener el nombre de los jueces cuya localización sea 'Oviedo'.
select judge_name
from judge
where judge_location = 'Oviedo'

-- Obtener el identificador y la duración de los juicios cuyo estado sea 'finished', ordenados por duración
-- de forma descendente.
select trial_id, end_date-start_date numDays
FROM Trial
WHERE status = 'finished'
order by numDays desc

-- Insertar un nuevo acusado con id 'AC100' y nombre 'Carlos Pérez'.
INSERT INTO Accused (accused_id, accused_name)
VALUES ('A100', 'Carlos Perez');


-- Incrementar en un 5% el salario de todos los jueces.
update judge
set judge_salary = judge_salary * 1.05

-- Eliminar las evidencias de tipo 'documento' asociadas al juicio 'T01'.
FROM Evidence
WHERE trial_id = 'T01'
AND evidence_type = 'documento';

-- Obtener el nombre de cada juez junto con el identificador de cada juicio que dirige.
select judge.judge_name, trial_id 
from trial, judge
where trial.judge_id = judge.judge_id


-- Obtener el nombre de los acusados implicados en el juicio 'T005', junto con el veredicto que recibieron.
select accused_name , verdict
from accused, involves
where accused.accused_id = involves.accused_id
and trial_id = 'T005'

-- Obtener el identificador y el tipo de las evidencias de los juicios dirigidos por el juez 'J03'.
select distinct evidence_number, evidence_type
from evidence, trial
where judge_id = 'J001'

-- Obtener, para cada juez, su nombre y el número de juicios que dirige (incluyendo los jueces sin ningún
-- juicio asignado).
select trial.judge_id, judge_name, Count(trial_id) numTrials
from judge, trial
where trial.judge_id = judge.judge_id
group by trial.judge_id, judge_name

-- Obtener los jueces que dirigen más de 5 juicios, junto con el número de juicios.
select judge_name, Count(trial_id) numTrials
from judge, trial
where judge.judge_id = trial.judge_id
group by trial.judge_id, judge_name
having Count(trial_id) > 5


-- ************ Obtener el nombre de cada acusado junto con el número de abogados distintos que lo han defendido.
select accused_name, Count(lawyer_id) as numAbogados
from Accused a, Defended_By d
where a.accused_id = d.accused_id
group by a.accused_id, accused_name


-- Obtener, para cada defender, su nombre y el número de acusados declarados culpables ('convicted') en los
-- juicios en los que ha participado.
select lawyer_name, Count(*)
from Lawyer l, Defended_By db, Involves i
where l.lawyer_id = db.lawyer_id
and db.accused_id = i.accused_id
and db.trial_id = i.trial_id
AND i.verdict = 'convicted'
group by l.lawyer_id, lawyer_name


-- Obtener el nombre y el salario de los jueces cuyo salario sea superior al salario medio de todos los
-- jueces.
select j1.judge_name, j1.judge_salary
from judge j1, judge j2
group by j1.judge_id, j1.judge_name, j1.judge_salary
having j1.judge_salary > Avg(j2.judge_salary) 


-- Obtener el nombre de los acusados que han sido defendidos por algún abogado de 'Oviedo'.
select accused_name
from accused a, defended_by db, lawyer l
where a.accused_id = db.accused_id
and db.lawyer_id = l.lawyer_id
and lawyer_location = 'Oviedo'

-- Obtener el nombre de los jueces que no dirigen ningún juicio.
select judge_name
from judge, trial
where judge.judge_id = trial.judge_id
and trial_id is null

-- Obtener el nombre de los jueces que no supervisan
select judge_id, judge_name
from judge
where judge_id not in (select senior_judge_id from supervises) 

-- Obtener los identificadores de los acusados implicados en algún juicio dirigido por el juez 'J001', que
-- nunca hayan sido defendidos por el abogado 'L002'.
SELECT DISTINCT a.accused_id
FROM Accused a, Trial t, Involves i
WHERE a.accused_id = i.accused_id
AND i.trial_id = t.trial_id
AND t.judge_id = 'J001'
AND a.accused_id NOT IN (
    SELECT db.accused_id
    FROM Defended_by db
    WHERE db.lawyer_id = 'L002'
);

-- Obtener el identificador y el nombre del juez que dirige el mayor número de juicios, junto con dicho
-- número.
select judge.judge_id, judge_name, Count(trial_id)
from judge, trial
where judge.judge_id = trial.judge_id
group by judge.judge_id, judge_name
order by Count(trial_id) desc
fetch first 1 row only

-- Obtener, para cada abogado defensor con al menos 3 defensas realizadas (numDefenses), su
-- nombre, el número de casos ganados (cases_won)
select lawyer_name, cases_won, Count(trial_id) numDefensas
from Lawyer l, Defender d, Defended_By db
where d.lawyer_id = db.lawyer_id
and l.lawyer_id = d.lawyer_id
group by l.lawyer_id, lawyer_name, cases_won
having Count(trial_id) >= 3


-- Obtener el identificador de los juicios finalizados ('finished') cuyo número de evidencias sea mayor que
-- el número medio de evidencias entre todos los juicios finalizados, junto con dicho número de
-- evidencias.
SELECT t.trial_id, COUNT(*) AS num_evidencias
FROM Trial t, Evidence e
WHERE t.trial_id = e.trial_id
AND t.status = 'finished'
GROUP BY t.trial_id
HAVING COUNT(*) > (
    SELECT AVG(cnt) FROM (
        SELECT COUNT(*) AS cnt
        FROM Trial t2, Evidence e2
        WHERE t2.trial_id = e2.trial_id
        AND t2.status = 'finished'
        GROUP BY t2.trial_id
    )
);

-- Obtener el nombre de los jueces senior (tabla Supervises) que supervisan a más jueces junior que la
-- media de jueces junior supervisados por el conjunto de jueces senior, junto con el número de junior
-- supervisados, ordenado de forma descendente por dicho número.
SELECT j.judge_name, COUNT(*) AS num_juniors
FROM Judge j, Supervises s
WHERE j.judge_id = s.senior_judge_id
GROUP BY j.judge_id, j.judge_name
HAVING COUNT(*) > (
    SELECT AVG(cnt) FROM (
        SELECT COUNT(*) AS cnt
        FROM Supervises
        GROUP BY senior_judge_id
    )
)
ORDER BY num_juniors DESC;


-- Obtener los acusados que tienen antecedentes (criminal_record no es NULL).

select accused_name, criminal_record
from accused
where criminal_record is not null


-- Obtener el número de juicios por tipo (trial_type)
select trial_type, Count(*) as numJuicios
from trial
group by trial_type

-- Obtener los juicios finalizados que tienen evidencias de todos los tipos ('forensic', 'digital', 'document', 'testimonial').
SELECT t.trial_id
FROM Trial t, Evidence e
WHERE t.trial_id = e.trial_id
AND t.status = 'finished'
GROUP BY t.trial_id
HAVING COUNT(DISTINCT e.evidence_type) = 4;

-- Obtener el nombre de los jueces que han presidido juicios de los tres estados posibles (finished, ongoing, not_started).
select judge.judge_id, judge_name
from judge, trial
where judge.judge_id = trial.judge_id
group by judge.judge_id, judge_name
having Count(distinct status) = 3

-- Obtener el defensor que ha acumulado más horas totales trabajadas en juicios finalizados, junto con dicho número de horas.
SELECT l.lawyer_id, l.lawyer_name, SUM(db.work_hours) AS totalHours
FROM Lawyer l, Defended_by db, Trial t
WHERE l.lawyer_id = db.lawyer_id
AND db.trial_id = t.trial_id
AND t.status = 'finished'
GROUP BY l.lawyer_id, l.lawyer_name
ORDER BY totalHours DESC
FETCH FIRST 1 ROW ONLY;


Cread un procedimiento que muestre para aquellos jueces que han presidido juicios finalizados la siguiente información: el judge_id, el judge_name, el número de juicios finalizados que ha presidido (numFinishedTrials) y su salario (judge_salary). El resultado ha de aparecer ordenado ascendentemente por judge_name.
Para esta primera parte (jueces), solo se considerarán:

jueces con más de 15 años de experiencia (judge_experience_years).
jueces cuyo salario sea superior a la media de salarios de todos los jueces.


select j.judge_id, judge_name, Count(*) numFinishedTrials, judge_salary
from judge j, trial t
where judge_experience_years > 15
and j.judge_id = t.judge_id
and status = 'finished'
and judge_salary > (select Avg(judge_salary) from judge)
group by j.judge_id, judge_name, judge_salary
order by judge_name asc

select i.accused_id, verdict, trial_type, Count(evidence_number)
from involves i, trial t, evidence e, accused a
where verdict = 'convicted'
and trial_type = 'Criminal'
and criminal_record is not null
and a.accused_id = i.accused_id
and i.trial_id = t.trial_id
and t.trial_id = e.trial_id
and t.judge_id = 'J001'     -- parametro
group by i.accused_id, verdict, trial_type
order by trial_type desc


-- Obtener el judge_id de todos los jueces que son supervisores (aparecen como senior_judge_id).

select distinct judge_id
from judge, supervises
where judge_id = senior_judge_id

-- Obtener el junior_judge_id y el performance_rating de los jueces supervisados por J001.

select junior_judge_id, performance_rating
from supervises
where senior_judge_id = 'J001'


-- Obtener los jueces que no son supervisados por nadie (no aparecen como junior_judge_id).

select judge_id
from judge
where judge_id not in (select junior_judge_id from supervises)


-- Obtener el nombre del juez senior y el nombre del juez junior para cada relación de supervisión.

select j1.judge_name senior, j2.judge_name junior
from judge j1, judge j2, supervises
where j1.judge_id = senior_judge_id
and j2.judge_id = junior_judge_id

-- Obtener el nombre de los jueces senior junto con el número de jueces junior que supervisan, ordenado descendentemente.

SELECT j.judge_name, COUNT(s.junior_judge_id) AS num_juniors
FROM Judge j, Supervises s
WHERE j.judge_id = s.senior_judge_id
GROUP BY j.judge_id, j.judge_name
ORDER BY num_juniors DESC;

-- Obtener el nombre de los jueces senior cuya media de performance_rating de sus supervisados sea superior a 7.

select judge_id, judge_name senior
from judge, supervises
where judge.judge_id = senior_judge_id
group by judge_id, judge_name
having Avg(performance_rating) > 7

-- Obtener el nombre de los jueces que son supervisores pero ellos mismos no son supervisados por nadie.

select judge_name
from judge, supervises
where judge_id = senior_judge_id
and senior_judge_id not in (select junior_judge_id from supervises)


-- Obtener el nombre de los jueces supervisados cuyo performance_rating sea 
-- superior al performance_rating medio de todos los supervisados por el mismo juez senior.

SELECT j.judge_name
FROM Judge j, Supervises s
WHERE j.judge_id = s.junior_judge_id
AND s.performance_rating > (
    SELECT AVG(s2.performance_rating)
    FROM Supervises s2
    WHERE s2.senior_judge_id = s.senior_judge_id
);

-- Obtener el nombre del juez senior que tiene el supervisado con mayor salario, 
-- junto con el nombre y salario de dicho supervisado.

select j1.judge_name senior, j2.judge_name junior, j2.judge_salary
from judge j1, judge j2, supervises s
where j1.judge_id = s.senior_judge_id
and j2.judge_id = s.junior_judge_id
order by j2.judge_salary desc
fetch first 1 row only;

-- Obtener el nombre de los defensores que han defendido a todos los acusados con antecedentes.

-- El doble NOT EXISTS es el patrón estándar para la cuantificación universal ("todos") en SQL

SELECT l.lawyer_name
FROM Lawyer l
WHERE NOT EXISTS (      -- no existe un acusado...
    SELECT a.accused_id
    FROM Accused a
    WHERE a.criminal_record IS NOT NULL
    AND NOT EXISTS (        -- que no haya defendido
        SELECT db.lawyer_id
        FROM Defended_by db
        WHERE db.lawyer_id = l.lawyer_id
        AND db.accused_id = a.accused_id
    )
)


-- Obtener el juicio finalizado con mayor número de acusados condenados, junto con dicho número.
select t.trial_id, COUNT(accused_id) AS numConvicted
from trial t, involves i
where status = 'finished'
and t.trial_id = i.trial_id
and verdict = 'convicted'
group by t.trial_id
order by numConvicted desc
fetch first 1 row only


-- Obtener el nombre de los acusados que han cambiado de abogado entre juicios 
-- (han sido defendidos por más de un abogado distinto en juicios distintos).

SELECT a.accused_name
FROM Accused a, Defended_by db
WHERE a.accused_id = db.accused_id
GROUP BY a.accused_id, a.accused_name
HAVING COUNT(DISTINCT db.lawyer_id) > 1


-- Obtener los jueces que han presidido juicios en los que todos los acusados han sido absueltos.

-- Dame los jueces para los que NO EXISTE
--    ningún juicio suyo
--    que tenga algún acusado no absuelto

SELECT j.judge_id
FROM Judge j
WHERE NOT EXISTS (
    SELECT t.trial_id
    FROM Trial t
    WHERE t.judge_id = j.judge_id        -- juicios de este juez
    AND EXISTS (
        SELECT i.accused_id
        FROM Involves i
        WHERE i.trial_id = t.trial_id
        AND i.verdict != 'acquitted'     -- con algún acusado no absuelto
    )
);

SELECT DISTINCT t.judge_id
FROM Trial t
WHERE NOT EXISTS (
    SELECT i.accused_id
    FROM Involves i
    WHERE i.trial_id = t.trial_id
    AND i.verdict != 'acquitted'
);
























