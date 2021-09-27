USE openmrs;

SET @today := CURRENT_DATE();

-- Create table for @lastExecution
CREATE TABLE IF NOT EXISTS DEMO_DATA_GEN (LAST_EXECUTION_DATE date);

-- Read @lastExecution or use @today
SELECT 
	CASE WHEN max_ddg.LAST_DATE IS NULL THEN @today ELSE max_ddg.LAST_DATE END 
INTO 
	@lastExecution
FROM (
	SELECT 
		MAX(ddg.LAST_EXECUTION_DATE) as 'LAST_DATE'
	FROM 
		DEMO_DATA_GEN ddg
) max_ddg;

-- @today and @lastExecution are used to determine how much to move date times (by full days)

-- Update visit's date
UPDATE visit v
SET v.date_started := DATE_ADD(@today, INTERVAL DATEDIFF(v.date_started, @lastExecution) DAY);

-- Update encounter's date-time
UPDATE encounter e
SET e.encounter_datetime := TIMESTAMP(DATE_ADD(@today, INTERVAL DATEDIFF(e.encounter_datetime , @lastExecution) DAY), TIME(e.encounter_datetime));

-- Update observation date-time (makes the same as encounter date-time)
UPDATE obs o
SET o.obs_datetime := (SELECT e.encounter_datetime FROM encounter e WHERE e.voided = 0 AND o.encounter_id = e.encounter_id);

-- Update delivery attempt date-time
UPDATE messages_delivery_attempt mda
SET mda.`timestamp` := TIMESTAMP(DATE_ADD(@today, INTERVAL DATEDIFF(mda.`timestamp` , @lastExecution) DAY), TIME(mda.`timestamp`));

-- Update scheduled service group
UPDATE messages_scheduled_service_group mssg
SET mssg.msg_send_time := TIMESTAMP(DATE_ADD(@today, INTERVAL DATEDIFF(mssg.msg_send_time , @lastExecution) DAY), TIME(mssg.msg_send_time));

-- Update scheduled service parameter with a date of a visit
UPDATE messages_schedule_service_parameter mssp_d
INNER JOIN messages_schedule_service_parameter mssp_v 
	ON mssp_v.scheduled_message = mssp_d.scheduled_message AND mssp_v.parameter_type = 'visitId'
INNER JOIN visit v ON v.visit_id = mssp_v.parameter_value
SET mssp_d.parameter_value := DATE_FORMAT(v.date_started, "%Y-%m-%d %H:%i:%s.0")
WHERE mssp_d.parameter_type = 'dateStarted';

-- Update patient program enrolled date
UPDATE patient_program pp 
SET pp.date_enrolled := DATE_ADD(@today, INTERVAL DATEDIFF(pp.date_enrolled, @lastExecution) DAY);

-- Update conditions date-times
UPDATE conditions c
SET c.onset_date := DATE_ADD(@today, INTERVAL DATEDIFF(c.onset_date, @lastExecution) DAY), 
	c.end_date := DATE_ADD(@today, INTERVAL DATEDIFF(c.end_date, @lastExecution) DAY);

-- Persist @lastExecution for this run
INSERT INTO DEMO_DATA_GEN VALUES (@today);
-- Clan old @lastExecution values
DELETE FROM DEMO_DATA_GEN WHERE LAST_EXECUTION_DATE < @today;

