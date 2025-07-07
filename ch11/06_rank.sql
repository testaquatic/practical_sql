BEGIN;


CREATE TABLE widget_companies(id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
                                                               company TEXT NOT NULL,
                                                                            widget_output INTEGER NOT NULL);


INSERT INTO widget_companies (company, widget_output)
VALUES ('Dom Widgets', 125000),
       ('Ariadne Widget Masters', 143000),
       ('Saito Widget Co.', 201000),
       ('Mal Inc.', 133000),
       ('Dream Widget Inc.', 196000),
       ('Miles Amalgamated', 620000),
       ('Arthur Industries', 244000),
       ('Fischer Worldwide', 201000);


SELECT company,
       widget_output,
       rank() OVER (
                    ORDER BY widget_output DESC),
       dense_rank() OVER (
                          ORDER BY widget_output DESC)
FROM widget_companies
ORDER BY widget_output DESC;


COMMIT;