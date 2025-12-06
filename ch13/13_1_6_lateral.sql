SELECT
    county_name,
    state_name,
    pop_est_2018,
    pop_est_2019,
    raw_chg,
    ROUND(pct_chg * 100, 2) AS pct_chg
FROM
    us_counties_pop_est_2019,
    LATERAL (SELECT pop_est_2019 - pop_est_2018 AS raw_chg) rc,
    LATERAL ( SELECT raw_chg / pop_est_2018::NUMERIC AS pct_chg) pc
ORDER BY
    pct_chg DESC;


START TRANSACTION;

ALTER TABLE teachers
    ADD CONSTRAINT id_key PRIMARY KEY (id);

CREATE TABLE teachers_lab_access (
    access_id   BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    access_time TIMESTAMP WITH TIME ZONE,
    lab_name    TEXT,
    teachers_id BIGINT REFERENCES teachers (id)
);

INSERT INTO teachers_lab_access (
    access_time, lab_name, teachers_id
)
VALUES (
    '2022-11-30 08:59:00-05', 'Science A', 2
), (
    '2022-12-01 08:58:00-05', 'Chemistry B', 2
), (
    '2022-12-21 09:01:00-05', 'Chemistry A', 2
), (
    '2022-12-02 11:01:00-05', 'Science B', 6
), (
    '2022-12-07 10:02:00-05', 'Science A', 6
), (
    '2022-12-17 16:00:00-05', 'Science B', 6
);

SELECT
    t.first_name,
    t.last_name,
    a.access_time,
    a.lab_name
FROM
    teachers t
    LEFT JOIN LATERAL ( SELECT * FROM teachers_lab_access WHERE teachers_id = t.id ORDER BY access_time DESC LIMIT 2) a
              ON TRUE
ORDER BY
    id;

COMMIT;