-- Adds DATES_LIST_10_DAYS_TABLE which is DATES_LIST_10_DAYS Materialized View

DROP TABLE IF EXISTS DATES_LIST_10_DAYS_TABLE;

CREATE TABLE DATES_LIST_10_DAYS_TABLE (selected_date date DEFAULT NULL);

INSERT INTO DATES_LIST_10_DAYS_TABLE
select
    (curdate() + interval (((((`t4`.`t4` * 10000) + (`t3`.`t3` * 1000)) + (`t2`.`t2` * 100)) + (`t1`.`t1` * 10)) + `t0`.`t0`) day) AS `selected_date`
from
    ((((`openmrs`.`DIGITS_0` `t0`
join `openmrs`.`DIGITS_1` `t1`)
join `openmrs`.`DIGITS_2` `t2`)
join `openmrs`.`DIGITS_3` `t3`)
join `openmrs`.`DIGITS_4` `t4`)
where
    ((curdate() + interval (((((`t4`.`t4` * 10000) + (`t3`.`t3` * 1000)) + (`t2`.`t2` * 100)) + (`t1`.`t1` * 10)) + `t0`.`t0`) day) < (
    select
        (curdate() + interval 30 day)));
