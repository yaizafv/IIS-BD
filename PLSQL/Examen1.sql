create or replace PROCEDURE EXAMEN1 AS 
cursor c1 is select l.lawyer_id, lawyer_name, Count(DISTINCT db.trial_id) numTrials, Sum(work_hours) totalHours
            from lawyer l, defended_by db
            where l.lawyer_id = db.lawyer_id
            and lawyer_experience_years > 20
            group by l.lawyer_id, lawyer_name
            order by lawyer_name desc;
cursor c2(PCODLAWYERID Lawyer.lawyer_id%TYPE) is select i.accused_id, verdict, judge_name
                                                from involves i, trial t, judge j, defended_by db
                                                where db.lawyer_id = PCODLAWYERID
                                                and db.trial_id = i.trial_id        
                                                and db.accused_id = i.accused_id 
                                                and i.trial_id = t.trial_id
                                                and t.judge_id = j.judge_id
                                                and status = 'finished'
                                                and judge_experience_years > (
                                                    select avg(judge_experience_years) from judge
                                                )
                                                order by accused_id desc;
BEGIN
    for i in c1 loop
        dbms_output.put_line('DEFENDER: '||i.lawyer_id||' '||i.lawyer_name || ' ' || i.numTrials || ' ' || i.totalHours);
        for j in c2(i.lawyer_id) loop
            dbms_output.put_line('--ACCUSED: '||j.accused_id||' '||j.verdict || ' ' || j.judge_name);
        end loop;
    end loop;
    
END EXAMEN1;
