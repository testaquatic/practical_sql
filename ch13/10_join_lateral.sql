BEGIN;


ALTER TABLE teachers ADD CONSTRAINT id_key PRIMARY KEY (id);


CREATE TABLE teachers_lab_access(access_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
                                                                        access_time TIMESTAMP WITH TIME ZONE,
                                                                                                        lab_name TEXT, teacher_id BIGINT REFERENCES teachers (id));


INSERT INTO teachers_lab_access (access_time, lab_name, teacher_id)
VALUES ('2022-11-30 08:59:00-05', 'Science A', 2),
       ('2022-12-01 08:58:00-05', 'Chemistry B', 2),
       ('2022-12-21 09:01:00-05', 'Chemistry A', 2),
       ('2022-12-02 11:01:00-05', 'Science B', 6),
       ('2022-12-07 10:02:00-05', 'Science A', 6),
       ('2022-12-17 16:00:00-05', 'Science B', 6);

SELECT t.first_name, t.last_name, a.access_time, a.lab_name
FROM teachers t
LEFT JOIN LATERAL (
  SELECT *
  FROM teachers_lab_access
  WHERE teacher_id = t.id
  ORDER BY access_time DESC
  LIMIT 2
) a
ON true
ORDER BY t.id;


COMMIT;