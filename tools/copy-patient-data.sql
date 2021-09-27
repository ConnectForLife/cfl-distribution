-- WARNING: This script can only be run once per patient, it doesn't solve any conflicts or prevent data duplication!
-- CAUTION: The dest-patient must have message_patient_template already created and keep an eye on start of messages date-time!
-- Copy patient-related data from one patient to another with a small randomization.
-- Example:
-- ID Patient: Jan:7 Ramesh:12, Musa:13
-- ID Location: Hooglede Clinic:2, Mumbai Clinic:3, Dopemu Clinic:4

use openmrs;

SET @srcPatientId := 7;

SET @destPatientId := 13;
SET @destLocationId := 4;

-- [-2, 2] 
SELECT FLOOR(RAND() * 10 MOD 5) - 2 INTO @random22;

-- START Copy Visit and related entities
ALTER TABLE visit ADD COLUMN copy_of_id INT(11) NULL;
ALTER TABLE encounter ADD COLUMN copy_of_id INT(11) NULL;
ALTER TABLE obs ADD COLUMN copy_of_id INT(11) NULL;
ALTER TABLE messages_scheduled_service_group ADD COLUMN copy_of_id INT(11) NULL;
ALTER TABLE messages_scheduled_service ADD COLUMN copy_of_id INT(11) NULL;

-- Visits
INSERT INTO visit (
	patient_id, 
	visit_type_id, 
	date_started, 
	date_stopped,
	location_id,
	creator,
	date_created,
	uuid,
	copy_of_id
)
SELECT 
	@destPatientId,
	v.visit_type_id,
	TIMESTAMP(DATE_ADD(DATE(v.date_started), INTERVAL @random22 DAY), TIME(v.date_started)),
	CASE WHEN v.date_stopped IS NULL THEN null ELSE TIMESTAMP(DATE_ADD(v.date_stopped, INTERVAL @random22 DAY), TIME(v.date_stopped)) END,
	@destLocationId,
	v.creator,
	v.date_created,
	UUID(),
	v.visit_id
FROM 
	visit v 
WHERE 
	v.voided = 0
	AND v.patient_id = @srcPatientId;

-- Visit attributes
INSERT INTO visit_attribute (
	visit_id,
	attribute_type_id,
	value_reference,
	uuid,
	creator,
	date_created
)
SELECT
	v_copy.visit_id,
	va.attribute_type_id,
	va.value_reference,
	UUID(),
	va.creator,
	va.date_created
FROM
	visit_attribute va 
INNER JOIN 
	visit v_copy ON v_copy.copy_of_id = va.visit_id
WHERE 
	va.voided = 0;

-- Encounters (Visit-only)
INSERT INTO encounter (
	encounter_type,
	patient_id,
	location_id,
	form_id,
	encounter_datetime,
	creator,
	date_created,
	visit_id,
	uuid,
	copy_of_id
)
SELECT
	e.encounter_type,
	@destPatientId,
	@destLocationId,
	e.form_id,
	TIMESTAMP(DATE_ADD(DATE(e.encounter_datetime), INTERVAL @random22 DAY), TIME(e.encounter_datetime )),
	e.creator,
	e.date_created,
	(SELECT dest_v.visit_id FROM visit dest_v WHERE dest_v.copy_of_id = e.visit_id),
	UUID(),
	e.encounter_id
FROM
	encounter e 
WHERE 
	e.voided = 0
	AND e.patient_id = @srcPatientId
	AND e.visit_id IS NOT NULL;

-- Encounter Provider
INSERT INTO encounter_provider (
	encounter_id,
	provider_id,
	encounter_role_id,
	creator,
	date_created,
	uuid
)
SELECT
	e_copy.encounter_id,
	ep.provider_id,
	ep.encounter_role_id,
	ep.creator,
	ep.date_created,
	UUID() 
FROM
	encounter_provider ep
INNER JOIN
	encounter e_copy ON e_copy.copy_of_id = ep.encounter_id;

-- Observation - first pass with obs_group_id is null
INSERT INTO obs (
	person_id,
	concept_id,
	encounter_id,
	obs_datetime,
	location_id,
	obs_group_id,
	value_coded,
	value_coded_name_id,
	value_drug,
	value_datetime,
	value_numeric,
	value_modifier,
	value_text,
	value_complex,
	comments,
	creator,
	date_created,
	uuid,
	status,
	copy_of_id
)
SELECT
	@destPatientId,
	o.concept_id,
	e_copy.encounter_id,
	e_copy.encounter_datetime,
	@destLocationId,
	NULL,
	o.value_coded,
	o.value_coded_name_id,
	o.value_drug,
	CASE WHEN o.value_datetime IS NULL THEN NULL ELSE TIMESTAMP(DATE_ADD(DATE(o.value_datetime), INTERVAL @random22 DAY), TIME(o.value_datetime)) END,
	o.value_numeric,
	o.value_modifier,
	o.value_text,
	o.value_complex,
	o.comments,
	o.creator,
	o.date_created,
	UUID(),
	o.status,
	o.obs_id
FROM
	obs o
INNER JOIN
	encounter e_copy ON e_copy.copy_of_id = o.encounter_id
WHERE
	o.voided = 0
	AND o.obs_group_id IS NULL
	AND o.person_id = @srcPatientId;

-- Observation (Visit-only) - first pass with obs_group_id is not null
INSERT INTO obs (
	person_id,
	concept_id,
	encounter_id,
	obs_datetime,
	location_id,
	obs_group_id,
	value_coded,
	value_coded_name_id,
	value_drug,
	value_datetime,
	value_numeric,
	value_modifier,
	value_text,
	value_complex,
	comments,
	creator,
	date_created,
	uuid,
	status,
	copy_of_id
)
SELECT
	@destPatientId,
	o.concept_id,
	e_copy.encounter_id,
	e_copy.encounter_datetime,
	@destLocationId,
	(SELECT g_obs.obs_id FROM obs g_obs WHERE g_obs.voided = 0 AND g_obs.copy_of_id = o.obs_group_id),
	o.value_coded,
	o.value_coded_name_id,
	o.value_drug,
	CASE WHEN o.value_datetime IS NULL THEN NULL ELSE TIMESTAMP(DATE_ADD(DATE(o.value_datetime), INTERVAL @random22 DAY), TIME(o.value_datetime)) END,
	o.value_numeric,
	o.value_modifier,
	o.value_text,
	o.value_complex,
	o.comments,
	o.creator,
	o.date_created,
	UUID(),
	o.status,
	o.obs_id
FROM
	obs o
INNER JOIN
	encounter e_copy ON e_copy.copy_of_id = o.encounter_id
WHERE
	o.voided = 0
	AND o.obs_group_id IS NOT NULL
	AND o.person_id = @srcPatientId;

-- Program enrollment
INSERT INTO patient_program (
	patient_id,
	program_id,
	date_enrolled,
	date_completed,
	location_id,
	outcome_concept_id,
	creator,
	date_created,
	uuid
)
SELECT 
	@destPatientId,
	pp.program_id,
	pp.date_enrolled,
	pp.date_completed,
	@destLocationId,
	pp.outcome_concept_id,
	pp.creator,
	pp.date_created,
	UUID()
FROM 
	patient_program pp
WHERE
	pp.voided = 0
	AND pp.patient_id = @srcPatientId;

INSERT INTO messages_scheduled_service_group (
	msg_send_time,
	patient_id,
	status,
	uuid,
	creator,
	date_created,
	actor_id,
	channel_type,
	copy_of_id
)
SELECT
	TIMESTAMP(DATE_ADD(DATE(mssg.msg_send_time), INTERVAL @random22 DAY),
		CASE WHEN 
			(SELECT COUNT(*) FROM person_attribute pa WHERE pa.voided = 0 AND pa.person_attribute_type_id = 15 AND pa.person_id = @destPatientId) = 0 
		THEN 
			(SELECT JSON_UNQUOTE(JSON_EXTRACT(gp.property_value, "$.global")) FROM global_property gp WHERE gp.property = 'message.bestContactTime.default')
		ELSE
			(SELECT pa.value FROM person_attribute pa WHERE pa.voided = 0 AND pa.person_attribute_type_id = 15 AND pa.person_id = @destPatientId)
		END
	) as 'msg_send_time',
	@destPatientId,
	mssg.status,
	UUID(),
	mssg.creator,
	mssg.date_created,
	@destPatientId,
	mssg.channel_type,
	mssg.messages_scheduled_service_group_id
FROM 
	messages_scheduled_service_group mssg
WHERE
	mssg.voided = 0
	AND mssg.patient_id = @srcPatientId;

INSERT INTO messages_scheduled_service (
	group_id,
	patient_template_id,
	status,
	uuid,
	creator,
	date_created,
	service,
	copy_of_id
)
SELECT
	(SELECT mssg.messages_scheduled_service_group_id FROM messages_scheduled_service_group mssg WHERE mssg.copy_of_id = mss.group_id) as 'group_id',
	(
		SELECT 
			mpt.messages_patient_template_id 
		FROM
			messages_patient_template mpt
		INNER JOIN
			messages_template mt ON mt.messages_template_id = mpt.template_id 
		WHERE
			mpt.patient_id = @destPatientId
			AND mpt.actor_id = @destPatientId
			AND mt.name = mss.service 
	) as 'patient_template_id',
	mss.status,
	UUID(),
	mss.creator,
	mss.date_created,
	mss.service,
	mss.messages_scheduled_service_id 
FROM
	messages_scheduled_service mss 
INNER JOIN
	messages_patient_template mpt ON mpt.messages_patient_template_id  = mss.patient_template_id 
WHERE
	mss.voided = 0
	AND mpt.voided = 0
	AND mpt.patient_id = @srcPatientId;

INSERT INTO messages_schedule_service_parameter (
	scheduled_message,
	parameter_type,
	parameter_value,
	uuid,
	creator,
	date_created
)
SELECT 
	mss_copy.messages_scheduled_service_id,
	mssp.parameter_type,
	mssp.parameter_value,
	UUID(),
	mssp.creator,
	mssp.date_created
FROM 
	messages_schedule_service_parameter mssp
INNER JOIN
	messages_scheduled_service mss_copy ON mss_copy.copy_of_id = mssp.scheduled_message 
INNER JOIN
	messages_scheduled_service_group mssg_copy ON mssg_copy.messages_scheduled_service_group_id = mss_copy.group_id 
WHERE
	mssp.voided = 0
	AND mssg_copy.patient_id = @destPatientId
	AND mssg_copy.actor_id = @destPatientId;

-- Update scheduled service parameter with a copied visit ID
UPDATE
	messages_schedule_service_parameter mssp_v
INNER JOIN
	messages_scheduled_service mss ON mss.messages_scheduled_service_id = mssp_v.scheduled_message
INNER JOIN
	messages_patient_template mpt ON mpt.messages_patient_template_id = mss.patient_template_id 
SET mssp_v.parameter_value = (SELECT v.visit_id FROM visit v WHERE v.copy_of_id = CAST(mssp_v.parameter_value AS UNSIGNED))
WHERE 
	mssp_v.parameter_type = 'visitId'
	AND mpt.patient_id = @destPatientId
	AND mpt.actor_id = @destPatientId;
	
-- Update location service parameter
UPDATE
	messages_schedule_service_parameter mssp_v
INNER JOIN
	messages_scheduled_service mss ON mss.messages_scheduled_service_id = mssp_v.scheduled_message
INNER JOIN
	messages_patient_template mpt ON mpt.messages_patient_template_id = mss.patient_template_id 
SET mssp_v.parameter_value = @destLocationId
WHERE 
	mssp_v.parameter_type = 'locationId'
	AND mpt.patient_id = @destPatientId
	AND mpt.actor_id = @destPatientId;

-- Update scheduled service parameter with a date of a visit
UPDATE 
	messages_schedule_service_parameter mssp_d
INNER JOIN 
	messages_schedule_service_parameter mssp_v 
		ON mssp_v.scheduled_message = mssp_d.scheduled_message AND mssp_v.parameter_type = 'visitId'
INNER JOIN 
	visit v 
		ON v.visit_id = mssp_v.parameter_value
SET 
	mssp_d.parameter_value := DATE_FORMAT(v.date_started, "%Y-%m-%d %H:%i:%s.0")
WHERE 
	mssp_d.parameter_type = 'dateStarted'
	AND v.patient_id = @destPatientId;

INSERT INTO messages_delivery_attempt(
	scheduled_service_id,
	`timestamp`,
	new_status,
	attempt_number,
	uuid,
	creator,
	date_created
)
SELECT 
	mss_copy.messages_scheduled_service_id,
	TIMESTAMP(DATE_ADD(DATE(mda.`timestamp`), INTERVAL @random22 DAY)),
	mda.new_status,
	mda.attempt_number,
	UUID(),
	mda.creator,
	mda.date_created
FROM
	messages_delivery_attempt mda
INNER JOIN
	messages_scheduled_service mss_copy ON mss_copy.copy_of_id = mda.scheduled_service_id
INNER JOIN
	messages_scheduled_service_group mssg_copy ON mssg_copy.messages_scheduled_service_group_id  = mss_copy.group_id 
WHERE
	mda.voided = 0
	AND mssg_copy.patient_id = @destPatientId
	AND mssg_copy.actor_id = @destPatientId;

INSERT INTO conditions (
	additional_detail,
	condition_coded,
	condition_non_coded,
	condition_coded_name,
	clinical_status,
	verification_status,
	onset_date,
	date_created,
	creator,
	uuid,
	patient_id,
	end_date
)
SELECT 
	c.additional_detail,
	c.condition_coded,
	c.condition_non_coded,
	c.condition_coded_name,
	c.clinical_status,
	c.verification_status,
	TIMESTAMP(DATE_ADD(DATE(c.onset_date), INTERVAL @random22 DAY)),
	c.date_created,
	c.creator,
	UUID(),
	@destPatientId,
	TIMESTAMP(DATE_ADD(DATE(c.end_date), INTERVAL @random22 DAY))
FROM 
	conditions c
WHERE
	c.voided = 0
	AND c.patient_id = @srcPatientId;

ALTER TABLE visit DROP COLUMN copy_of_id;
ALTER TABLE encounter DROP COLUMN copy_of_id;
ALTER TABLE obs DROP COLUMN copy_of_id;
ALTER TABLE messages_scheduled_service_group DROP COLUMN copy_of_id;
ALTER TABLE messages_scheduled_service DROP COLUMN copy_of_id;
-- END Copy Visit and its attributes
