/* VISIT TYPES - add new ones */
INSERT INTO openmrs.visit_type (name,description,creator, date_created, uuid) VALUES 
('DOSE 1 VISIT','The first vaccination visit, scheduled right after patient registration', 2, NOW(), 'd08bb6a8-9dc4-4e76-a54f-d3a8ae69cfef'),
('DOSE 1 & 2 VISIT','The second vaccination visit, scheduled after changing previous visit’s status to “OCCURRED”, according to the program', 2, NOW(), 'f0748991-bbc5-47b2-8dee-d8db819f8a59'),
('DOSE 1, 2 & 3 VISIT','The third vaccination visit, scheduled after changing previous visit’s status to “OCCURRED”, according to the program', 2, NOW(), '4c85292a-be85-4ece-8d92-b5c52aa046db'),
('DOSE 1, 2, 3 & 4 VISIT','The fourth vaccination visit, scheduled after changing previous visit’s status to “OCCURRED”, according to the program', 2, NOW(), '6fa920f3-3150-4927-85d1-90a934fbd1df'),
('OTHER','Control visit scheduledafter every vaccination visit if its status is changed to “OCCURRED”', 2, NOW(), '9c49a491-fd53-4242-9197-4da04257e397'),
('FOLLOW UP','It’s used for all of the other, unidentified visit types', 2, NOW(), '1c8409d8-c238-40b5-bc6c-4776d6a81aaf');

/* PERSON ATTRIBUTE TYPES - add new ones */
INSERT INTO openmrs.person_attribute_type (name,description,format,creator,date_created,uuid) VALUES 
('Vaccination program', 'Attribute used to store information about patient vaccination program from ZETES', 'java.lang.String', 2, NOW(), '4c81f667-788e-4023-bac5-e259636d5e42'),
('Refresh Date', 'Refresh Date of row from ZETES', 'java.lang.String', 2, NOW(), 'ec052662-265c-47f3-b76d-ae092612eef5');

/* VISIT ATTRIBUTE TYPES - add new ones */
INSERT INTO openmrs.visit_attribute_type (name,description,datatype, min_occurs,creator,date_created,uuid) VALUES 
('Refresh Date','Refresh Date of row from ZETES','org.openmrs.customdatatype.datatype.FreeTextDatatype', 0, 2, NOW(), '374943c6-cf23-40db-ad7b-f17a80270bf1'),
('Up Window','Up Window of row from ZETES','org.openmrs.customdatatype.datatype.FreeTextDatatype', 0, 2, NOW(), 'd6b8705c-34aa-4373-a7e5-fe87cd41fef5'),
('Low Window','Low Window of row from ZETES','org.openmrs.customdatatype.datatype.FreeTextDatatype', 0, 2, NOW(), 'c5b7d8ba-d75d-463f-ad79-bb2d6565e4ee'),
('Dose Number','Dose Number of row from ZETES','org.openmrs.customdatatype.datatype.FreeTextDatatype', 0, 2, NOW(),'f196375c-f067-4269-afdb-f62c182aeb33');

/* LOCATION ATTRIBUTE TYPES - add new ones */
INSERT INTO openmrs.location_attribute_type (name,description,datatype,min_occurs,creator,date_created,uuid) VALUES 
('Site code','','org.openmrs.customdatatype.datatype.FreeTextDatatype', 0, 2, NOW(), '36ed01f3-be89-45c9-ab72-0ecb53a81169'),
('Country code','','org.openmrs.customdatatype.datatype.FreeTextDatatype', 0, 2, NOW(), '6ee35e9b-4f72-4d36-81b5-b50ccd2dc676'),
('Country decoded','','org.openmrs.customdatatype.datatype.FreeTextDatatype', 0, 2, NOW(), 'e4b56d4e-adff-4342-94bf-909f830624a7'),
('City','','org.openmrs.customdatatype.datatype.FreeTextDatatype', 0, 2, NOW(), '76e83af0-a852-4b7d-ad41-cb0dfdd3b035'),
('Who region decoded','','org.openmrs.customdatatype.datatype.FreeTextDatatype', 0, 2, NOW(), '0d6a85ad-312e-44a8-8207-17f6cbcb3206'),
('Time zone','','org.openmrs.customdatatype.datatype.FreeTextDatatype', 0, 2, NOW(), 'edaa7fed-1d35-4d22-90b9-61393cbde487'),
('Site decoded','','org.openmrs.customdatatype.datatype.FreeTextDatatype', 0, 2, NOW(), '10bb7a9d-709e-4a99-9bad-107dbf43f929'),
('Emergency phone','','org.openmrs.customdatatype.datatype.FreeTextDatatype', 0, 2, NOW(), '34e9edf0-3fd9-4195-ad24-e164bfd4e19f');

/* PATEINT IDNTIFIERS - set non unique and no validation for OpenMRS ID */
UPDATE openmrs.patient_identifier_type SET 
uniqueness_behavior = 'NON_UNIQUE', date_changed = NOW(), changed_by = 2, validator = NULL
WHERE uuid = '05a29f94-c0ed-11e2-94be-8c13b969e334';

/* MESSAGES SERVICE TYPES - disable other than visit reminder */
UPDATE openmrs.messages_template SET voided = 1, voided_by = 2, date_voided = NOW() WHERE uuid = '9556482a-20b2-11ea-ac12-0242c0a82002';
UPDATE openmrs.messages_template SET voided = 1, voided_by = 2, date_voided = NOW() WHERE uuid = '96d93c15-3884-11ea-b1e9-0242ac160002';
UPDATE openmrs.messages_template SET voided = 1, voided_by = 2, date_voided = NOW() WHERE uuid = '9556f9ab-20b2-11ea-ac12-0242c0a82002';
UPDATE openmrs.messages_template SET voided = 1, voided_by = 2, date_voided = NOW() WHERE uuid = '9556a62d-20b2-11ea-ac12-0242c0a82002';

/* GLOBAL PROPERTIES */
INSERT INTO openmrs.global_property (property,property_value,uuid,date_changed,changed_by) VALUES 
('iris.followUpVisitDelay','7','17c071d4-30c1-427c-916a-19f3505e3247', NOW(), 2);
UPDATE openmrs.global_property SET property_value = '86400', date_changed = NOW(), changed_by = 2 WHERE property = 'messages.messageDeliveryJobInterval';
UPDATE openmrs.global_property SET property_value = '1,2', date_changed = NOW(), changed_by = 2 WHERE property = 'message.daysToCallBeforeVisit.default';
UPDATE openmrs.global_property SET property_value = '{"acec590b-825e-45d2-876a-0028f174903d":"07:20","global":"14:30"}', date_changed = NOW(), changed_by = 2 WHERE property = 'message.bestContactTime.default';
UPDATE openmrs.global_property SET property_value = 'false', date_changed = NOW(), changed_by = 2 WHERE property = 'message.consent.validation';
UPDATE openmrs.global_property SET property_value = 'MainFlow', date_changed = NOW(), changed_by = 2 WHERE property = 'cfl.patientRegistrationCallFlowName';
UPDATE openmrs.global_property SET property_value = 'Thank you for participating in the Solidarity Vaccine Trial.  We will remind you about upcoming appointments.  Please call 12345 if you have any questions.', date_changed = NOW(), changed_by = 2 WHERE property = 'cfl.smsMessageAfterRegistration';
UPDATE openmrs.global_property SET property_value = '#set ($integerClazz = $openmrsContext.loadClass("java.lang.Integer"))#set ($stringClazz = $openmrsContext.loadClass("java.lang.String"))#set ($simpleDateFormat = $openmrsContext.loadClass("java.text.SimpleDateFormat").getDeclaredConstructor($stringClazz).newInstance("yyyy-MM-dd"))#set ($visitTypeIdInteger = $integerClazz.parseInt($visitTypeId))#set ($visitPurpose = $openmrsContext.getVisitService().getVisitType($visitTypeIdInteger).getName())#set($textToRead1 = "Hello $patient.getPersonName().toString(), You have a")#set($textToRead2 = "visit scheduled for $simpleDateFormat.format($simpleDateFormat.parse($dateStarted)) for the purpose of $visitPurpose.")$textToRead1 $textToRead2', date_changed = NOW(), changed_by = 2 WHERE property = 'messages.notificationTemplate.visit-reminder';
UPDATE openmrs.global_property SET property_value = 'voxeo', date_changed = NOW(), changed_by = 2 WHERE property = 'messages.callConfig';
UPDATE openmrs.global_property SET property_value = 'Europe/Brussels', date_changed = NOW(), changed_by = 2 WHERE property = 'messages.defaultUserTimezone';
UPDATE openmrs.global_property SET property_value = 'true', date_changed = NOW(), changed_by = 2 WHERE property = 'cfl.sendSmsOnPatientRegistration';
UPDATE openmrs.global_property SET property_value = 'true', date_changed = NOW(), changed_by = 2 WHERE property = 'cfl.performCallOnPatientRegistration';
UPDATE openmrs.global_property SET property_value = 'true', date_changed = NOW(), changed_by = 2 WHERE property = 'cfl.shouldSendReminderViaSms';
UPDATE openmrs.global_property SET property_value = 'true', date_changed = NOW(), changed_by = 2 WHERE property = 'cfl.shouldSendReminderViaCall';
UPDATE openmrs.global_property SET property_value = 'true', date_changed = NOW(), changed_by = 2 WHERE property = 'cfl.vaccinationInformationEnabled';
UPDATE openmrs.global_property SET property_value = 'en', date_changed = NOW(), changed_by = 2 WHERE property = 'default_locale';

/* SCHEDULED TASKS CONFIG */
UPDATE openmrs.scheduler_task_config SET start_on_startup = 0, started = 0, date_changed = NOW(), changed_by = 2 WHERE name = 'Missed Visits Status Changer';

/* MESSAGE TEMPLATES */
UPDATE openmrs.messages_template SET service_query ='SELECT EXECUTION_DATE,
        MESSAGE_ID,
        CHANNEL_ID,
        null AS STATUS_ID,
        visitTypeId,
        locationId,
        dateStarted,
        visitId,
        timeStarted

    FROM
    (
        SELECT TIMESTAMP(selected_date, :bestContactTime ) AS EXECUTION_DATE,
         1 AS MESSAGE_ID,
         :Service_type AS CHANNEL_ID,
         visitTypeId,
         locationId,
         dateStarted,
         visitId,
         visitTime AS timeStarted
        FROM
        DATES_LIST

            JOIN (
                SELECT
                    v.date_started AS visit_dates,
                    v.visit_type_id AS visitTypeId,
                    v.location_id AS locationId,
                    v.visit_id AS visitId,
                    v.date_started AS dateStarted,
                    visit_times.visit_time AS visitTime,
					visit_type.name as visitTypeName
                FROM
                    visit v
                    LEFT JOIN (
                        SELECT
                            visit_id,
                            value_reference as visit_time
                        FROM
                            visit_attribute va
                            JOIN visit_attribute_type vat ON va.attribute_type_id = vat.visit_attribute_type_id
                        WHERE
                            vat.name = "Visit Time"
                    ) AS visit_times ON v.visit_id = visit_times.visit_id
                    LEFT JOIN (
                        SELECT
                            visit_id,
                            value_reference as visit_status
                        FROM
                            visit_attribute va
                            JOIN visit_attribute_type vat ON va.attribute_type_id = vat.visit_attribute_type_id
                        WHERE
                            vat.name = "Visit Status"
                            AND va.voided = 0
                    ) AS visit_statuses ON v.visit_id = visit_statuses.visit_id
					LEFT JOIN visit_type ON v.visit_type_id = visit_type.visit_type_id
                WHERE
                    v.patient_id = :patientId
                    AND v.voided = 0
                    AND visit_statuses.visit_status = "SCHEDULED"
            ) dates_of_visit
        WHERE ((concat(",",(
            SELECT property_value
            FROM global_property
            WHERE property = "message.daysToCallBeforeVisit.default"), ",")
                LIKE concat("%,",datediff(visit_dates, selected_date),",%")
                AND visitTypeName in ("DOSE 1 VISIT", "DOSE 1 & 2 VISIT", "DOSE 1, 2 & 3 VISIT", "DOSE 1, 2, 3 & 4 VISIT", "FOLLOW UP"))
                OR(datediff(visit_dates, selected_date) = 1 AND visitTypeName not in ("DOSE 1 VISIT", "DOSE 1 & 2 VISIT", "DOSE 1, 2 & 3 VISIT", "DOSE 1, 2, 3 & 4 VISIT", "FOLLOW UP"))) 
                AND date(visit_dates) !=  selected_date
    )dates_before_visit
    WHERE EXECUTION_DATE <= :endDateTime
        AND EXECUTION_DATE >= :startDateTime
        AND EXECUTION_DATE > GET_PREDICTION_START_DATE_FOR_VISIT(:patientId, :actorId, :executionStartDateTime)
        AND CHANNEL_ID != "Deactivate service"
    UNION
        SELECT mssg.msg_send_time AS EXECUTION_DATE,
            1 AS MESSAGE_ID,
            mss.channel_type AS CHANNEL_ID,
            mss.status AS STATUS_ID,
            null AS visitTypeId,
            null AS locationId,
            null AS dateStarted,
            null AS visitId,
            null AS timeStarted
        FROM messages_scheduled_service mss
            JOIN messages_patient_template mpt ON mpt.messages_patient_template_id = mss.patient_template_id
            JOIN messages_template mt ON mt.messages_template_id = mpt.template_id
            JOIN messages_scheduled_service_group mssg ON mssg.messages_scheduled_service_group_id = mss.group_id
        WHERE mt.name = "Visit reminder"
            AND mpt.patient_id = :patientId
            AND mpt.actor_id = :actorId
            AND mssg.patient_id = :patientId
            AND mssg.msg_send_time >= :startDateTime
            AND mssg.msg_send_time <= :endDateTime
        ORDER BY 1 desc;', date_changed = NOW(), changed_by = 2 WHERE name = 'Visit reminder';
		
/* ETLS */
INSERT INTO openmrs.etl_mappings (name,source,query,transformTemplate,loadTemplate,cronExpression,fetchSize,testResultsSize,uuid,creator,changed_by,date_changed,date_created) VALUES 
('Randomization','','select * from reporting.randomization_solidarity;','#set($dosingMap = {1:"DOSE 1 VISIT",2:"DOSE 1 & 2 VISIT",3:"DOSE 1, 2 & 3 VISIT",4:"DOSE 1, 2, 3 & 4 VISIT"})
#set($vaccines = [])
#set($integerClass = $util.loadClass("java.lang.Integer"))
#set($followUpVisitDelay = $util.loadClass("org.openmrs.api.context.ServiceContext").getInstance().getApplicationContext().getBean("adminService").getGlobalProperty("iris.followUpVisitDelay"))
#set($parsedFollowUpDelay = $integerClass.parseInt($followUpVisitDelay))

#foreach( $row in $rows )    
	#set($out = {})
  #set($numberOfFutureVisit = 2)
  #if($row.DOSING_FREQ == $row.DOSE_NUMBER)
    #set($numberOfFutureVisit = 7)	
  #end	#set($doseVisit={"doseNumber":$row.DOSE_NUMBER,"midPointWindow":$row.MIDPOINT_WINDOW,"lowWindow":$row.LOW_WINDOW,"upWindow":$row.UP_WINDOW,"numberOfFutureVisit":$numberOfFutureVisit,"nameOfDose":$dosingMap.get($row.DOSE_NUMBER)})

	#set($followUpVisit={"doseNumber":$row.DOSE_NUMBER,"nameOfDose":"FOLLOW UP","midPointWindow":$parsedFollowUpDelay,"lowWindow":$row.LOW_WINDOW,"upWindow":$row.UP_WINDOW,"numberOfFutureVisit":0})



  #set($vacAdded = false)
  #foreach($vac in $vaccines)
  	#if($vac.name == $row.RANDOMIZATION)
    	#set($vacAdded = true)
      $vac.visits.add($doseVisit)
      $vac.visits.add($followUpVisit)
    #end
  #end
  #if(!$vacAdded)
  	#set($newVac = {"name": $row.RANDOMIZATION , "numberOfDose": $row.DOSING_FREQ, "visits": []})
  	$newVac.visits.add($doseVisit)
    $newVac.visits.add($followUpVisit)
  	$vaccines.add($newVac)
  #end
  	

  $out.put("vaccines",$vaccines)
#end
 #foreach($vac in $vaccines)
      #foreach($midPoint in [13, 27, 173, 237, 285, 336])
  	#set($visitType = "VIRTUAL FOLLOW UP")
  	#if($midPoint == 173)
  		#set($visitType = "ENGAGEMENT 1")
  	#elseif($midPoint == 285)
  		#set($visitType = "ENGAGEMENT 2")
  	#elseif($midPoint == 366)
  		#set($visitType = "GOODBYE")
  	#end
  	#set($VirtualFollowUpVisit={"doseNumber":$vac.numberOfDose,"nameOfDose":$visitType,"midPointWindow":$midPoint,"lowWindow":0,"upWindow":0,"numberOfFutureVisit":0})
$vac.visits.add($VirtualFollowUpVisit)
  #end
 #end
$vaccines
 ##$irisAdminService.setGlobalProperty("cfl.vaccines", $vaccines.toString())
$outs.add($out);','#if ($outs.size() > 0)
    #foreach($row in $outs)
         #set($objectMapperClass = "org.codehaus.jackson.map.ObjectMapper")
         #set( $objectMapper= $util.newObject($objectMapperClass))
         #set( $jsonObject =  $objectMapper.writeValueAsString($row.vaccines))
          $jsonObject
         $irisAdminService.setGlobalProperty("cfl.vaccines", $jsonObject)
    #end
#end
','',1000,10,'f7e65a28-8276-4432-bb63-e301bea83256',1,1,NOW(), NOW())
,('Patient registraiton','','#set($last_pulled = $util.loadClass("org.openmrs.api.context.ServiceContext").getInstance().getApplicationContext().getBean("adminService").getGlobalProperty("iris.lastPatientRefreshDate", "1"))	
SELECT * from demo_solidarity where refresh_date > FROM_UNIXTIME(($last_pulled + 1)/1000) order by REFRESH_DATE limit 1000;','#foreach( $row in $rows )
	#set($out = {})           
	#if ($row.PHONE && $row.PHONE.contains("+")) 
	  $out.put("phone",$row.PHONE.toString().substring(1, $row.PHONE.toString().length()))
	#else
	  $out.put("phone",$row.PHONE)
	#end
	$out.put("ad_profile",$profile)
	$out.put("language", $row.language);
	$out.put("vaccine",$row.RANDOMIZATION)
	$out.put("uuid",$row.UUID)
	$out.put("subject_id",$row.SUBJECT_ID)
	#if ($row.GENDER == "MALE")
		$out.put("gender", "M");
	#elseif ($row.GENDER == "FEMALE")
		$out.put("gender", "F");  
	#else    
		$out.put("gender", "O");
		## O - OTHER
	#end 
	$out.put("age", $row.AGE);    
	$out.put("registrationDate", $row.REFRESH_DATE);  
	$out.put("lat", $row.LATITUDE);  
	$out.put("lon", $row.LONGITUDE);  
	$out.put("location", $row.LOCATION);
    $out.put("siteCode", $row.SITE_CODE);
	$outs.add($out);
#end','#if ($outs.size() > 0)
    #set($patientClass = "org.openmrs.Patient")
    #set($personNameClass = "org.openmrs.PersonName")
    #set($patientIdentifierClass = "org.openmrs.PatientIdentifier")
	#set($personAttributeClass = "org.openmrs.PersonAttribute")
	#set($calendarClass = $util.loadClass("java.util.Calendar"))
	#set($personAddressClass = "org.openmrs.PersonAddress")
    #set($otherLocationUuid = "8d6c993e-c2cc-11de-8d13-0010c6dffd0f")
    #set($omrsIdentifierTypeUuid = "05a29f94-c0ed-11e2-94be-8c13b969e334")
    #set($vaccinationProgramAttributeTypeName = "Vaccination program")
    #set($personPhoneAttributeTypeName = "Telephone Number")
    #set($refreshDateAttributeTypeName = "Refresh Date")
    #set($personLanguageAttributeTypeName = "personLanguage")
	
	#set($otherLocation = $locationService.getLocationByUuid($otherLocationUuid))
	#set($omrsIdentifierType = $patientService.getPatientIdentifierTypeByUuid($omrsIdentifierTypeUuid))
	#set($vaccinationProgramAttributeType = $personService.getPersonAttributeTypeByName($vaccinationProgramAttributeTypeName))
	#set($personPhoneAttributeType = $personService.getPersonAttributeTypeByName($personPhoneAttributeTypeName))
	#set($refreshDateAttributeType = $personService.getPersonAttributeTypeByName($refreshDateAttributeTypeName))
	#set($personLanguageAttributeType = $personService.getPersonAttributeTypeByName($personLanguageAttributeTypeName))

    #foreach( $row in $outs )
   		#set($patient = $util.newObject($patientClass))
   		#set($patient.gender = $row.gender)
   		#set($patient.uuid = $row.uuid)
   		#set($sourceKey = "patientUuid");
        #set($sourceValue = $row.uuid);
		#set($patient.birthdateEstimated = true)
		#set($cal = $calendarClass.getInstance())
		#set($zero = 0)
		#set($age_inverted = $zero - $row.age.intValue())
		## 1 is Calendar.YEAR
		$cal.add(1, $age_inverted)
		#set($patient.birthdate = $cal.getTime())
		
		#set($patientIdentifier = $util.newObject($patientIdentifierClass))
		#set($patientIdentifier.patientIdentifierId = $row.subject_id)
		#set($patientIdentifier.preffered = true)
		#set($patientIdentifier.identifier = $row.subject_id)
		#set($patientIdentifier.identifierType = $omrsIdentifierType)
		#set($patientIdentifier.location = $otherLocation)
		#foreach( $location in $locationService.getAllLocations() )
			#if ($location.name == $row.siteCode)
				#set($patientIdentifier.location = $location)
			#end
		#end
		$patient.addIdentifier($patientIdentifier)

		#set($patientName = $util.newObject($personNameClass))
		#set($patientName.personNameId = $row.subject_id)
		#set($patientName.preffered = true)
		#set($patientName.givenName = $row.subject_id)
        $patient.addName($patientName)
		
		#set($vaccinationProgramAttribute = $util.newObject($personAttributeClass))
		#set($vaccinationProgramAttribute.attributeType = $vaccinationProgramAttributeType)
		#set($vaccinationProgramAttribute.value = $row.vaccine)
		$patient.addAttribute($vaccinationProgramAttribute)
		
		#set($personPhoneAttribute = $util.newObject($personAttributeClass))
		#set($personPhoneAttribute.attributeType = $personPhoneAttributeType)
		#if(!$row.phone || $row.phone == "")
			#set($personPhoneAttribute.value = "-")
		#else
			#set($personPhoneAttribute.value = $row.phone)
		#end
		$patient.addAttribute($personPhoneAttribute)
		
		#set($refreshDateAttribute = $util.newObject($personAttributeClass))
		#set($refreshDateAttribute.attributeType = $refreshDateAttributeType)
		#set($refreshDateAttribute.value = $row.registrationDate.getTime().toString())
		$patient.addAttribute($refreshDateAttribute)
		
		#set($personLanguageAttribute = $util.newObject($personAttributeClass))
		#set($personLanguageAttribute.attributeType = $personLanguageAttributeType)
		#set($personLanguageAttribute.value = $row.language)
		$patient.addAttribute($personLanguageAttribute)
		
		#set($personAddress = $util.newObject($personAddressClass))
		#set($personAddress.preffered = true)
		#set($personAddress.address1 = $row.location)
		#set($personAddress.latitude = $row.lat)
		#set($personAddress.longitude = $row.lon)
		$patient.addAddress($personAddress)

                $irisAdminService.setGlobalProperty("iris.lastPatientRefreshDate", $row.registrationDate.getTime().toString())
                $irisPatientService.savePatient($patient)
       #end
 #end','',1000,10,'df8c411d-2f22-4227-ac23-65a43cd232fe',1,1,NOW(), NOW())
,('Visit schedule','','#set($last_pulled = $util.loadClass("org.openmrs.api.context.ServiceContext").getInstance().getApplicationContext().getBean("adminService").getGlobalProperty("iris.lastVisitRefreshDate", "1"))
SELECT * from dosing_solidarity where refresh_date > FROM_UNIXTIME(($last_pulled + 1)/1000) order by REFRESH_DATE limit 100;
','##transform
#foreach($row in $rows)
		$outs.add($row);
#end','#if ($rows.size() > 0)
   	#set($visitClass = "org.openmrs.Visit")
	#set($otherLocationUuid = "8d6c993e-c2cc-11de-8d13-0010c6dffd0f")
	#set($today = $util.today())
	#set($visitAttributeClass = "org.openmrs.VisitAttribute")
	#set($otherVisitTypeUuid = "5247a295-4528-4f7e-aec7-5febd4566dc1")

	#set($visitStatusAttributeTypeName = "Visit Status")
	#set($refreshDateAttributeTypeName = "Refresh Date")
	#set($statusOfOccuredVisit = $adminService.getGlobalProperty("visits.statusOfOccurredVisit"))
	#set($otherLocation = $locationService.getLocationByUuid($otherLocationUuid))
	#set($otherVisitTypeName = "Other")

	#foreach($visitAttributeType in $visitService.getAllVisitAttributeTypes())
		#if($visitAttributeType.getName() == $visitStatusAttributeTypeName)
			#set($visitStatusAttributeType = $visitAttributeType)
		#elseif($visitAttributeType.getName() == $refreshDateAttributeTypeName)
			#set($visitRefreshDateAttributeType = $visitAttributeType)
		#end
	#end
	
	#foreach($visitType in $visitService.getAllVisitTypes())
		#if($visitType.getName().toLowerCase() == $otherVisitTypeName.toLowerCase())
			#set($otherVisitType = $visitType)
		#end
	#end
			
    #foreach($row in $rows)
		#set($previousVisits = $visitService.getVisitsByPatient($patientService.getPatientByUuid($row.uuid)))
		#set($isNewVisit = true)
		#foreach($visit in $previousVisits)
			#set($isVisitScheduled = false)
			#foreach($attribute in $visit.getActiveAttributes())
				#if($attribute.getAttributeType().getName() == $visitStatusAttributeTypeName && $attribute.getValue() == "SCHEDULED")
					#set($isVisitScheduled = true)
				#end
			#end
			#if($visit.visitType.name.toString().toLowerCase() == $row.VISIT_PURPOSE.toString().toLowerCase() && $isVisitScheduled == true)
				#set($occurredVisitStatusVisitAttribute = $util.newObject($visitAttributeClass))
				#set($occurredVisitStatusVisitAttribute.attributeType = $visitStatusAttributeType)
				$occurredVisitStatusVisitAttribute.setValueReferenceInternal($statusOfOccuredVisit)
				$visit.setAttribute($occurredVisitStatusVisitAttribute)
				
				#set($refreshDateVisitAttribute = $util.newObject($visitAttributeClass))
				#set($refreshDateVisitAttribute.attributeType = $visitRefreshDateAttributeType)
				$refreshDateVisitAttribute.setValueReferenceInternal($row.REFRESH_DATE.getTime().toString())
				$visit.setAttribute($refreshDateVisitAttribute)
				
				#set($visit.startDatetime = $util.stringToDate($row.DATE_DOSING, "dd-MMM-yy"))
				#set($visit.stopDatetime = $util.stringToDate($row.DATE_DOSING, "dd-MMM-yy"))
				#set($sourceKey = "uuid_visitPurpose_dateDosing")
		        #set($sourceValue = $row.uuid + "~" + $row.visit_purpose + "~" + $row.date_dosing)
		        $irisAdminService.setGlobalProperty("iris.lastVisitRefreshDate", $row.REFRESH_DATE.getTime().toString())
				$irisVisitService.saveVisit($visit)
				#set($isNewVisit = false)
			#end
		#end
		#if($isNewVisit == true)
			#set($visit = $util.newObject($visitClass))
			#set($visit.patient = $patientService.getPatientByUuid($row.uuid))
			#set($visit.startDatetime = $util.stringToDate($row.DATE_DOSING, "dd-MMM-yy"))
			#set($visit.stopDatetime = $util.stringToDate($row.DATE_DOSING, "dd-MMM-yy"))
			#set($visit.location = $otherLocation)
			
			#set($occurredVisitStatusVisitAttribute = $util.newObject($visitAttributeClass))
			#set($occurredVisitStatusVisitAttribute.attributeType = $visitStatusAttributeType)
			$occurredVisitStatusVisitAttribute.setValueReferenceInternal($statusOfOccuredVisit)
			$visit.setAttribute($occurredVisitStatusVisitAttribute)
			
			#set($refreshDateVisitAttribute = $util.newObject($visitAttributeClass))
			#set($refreshDateVisitAttribute.attributeType = $visitRefreshDateAttributeType)
			$refreshDateVisitAttribute.setValueReferenceInternal($row.REFRESH_DATE.getTime().toString())
			$visit.setAttribute($refreshDateVisitAttribute)

			#set($visit.visitType = $otherVisitType)
		   	#foreach($visitType in $visitService.getAllVisitTypes())
		   		#if($visitType.getName().toLowerCase() == $row.VISIT_PURPOSE.toString().toLowerCase())
		   			#set($visit.visitType = $visitType)
		   		#end
		   	#end

			#set($sourceKey = "uuid_visitPurpose_dateDosing")
			#set($sourceValue = $row.uuid + "~" + $row.visit_purpose + "~" + $row.date_dosing)
			$irisAdminService.setGlobalProperty("iris.lastVisitRefreshDate", $row.REFRESH_DATE.getTime().toString())
			$irisVisitService.saveVisit($visit)
		#end
    #end
#end','',1000,10,'8b7113fe-427c-4b1c-981a-c45d8078f843',1,1,NOW(), NOW()),
('Creating locations','','select * from reporting.site_country_region_solidarity;','#foreach($row in $rows)
	$outs.add($row);
#end','#set($locationClass = "org.openmrs.Location")
#set($locationAttributeTypeClass = "org.openmrs.LocationAttributeType")
#set($locationAttributeClass = "org.openmrs.LocationAttribute")
#set($siteCodeAttrName = "Site code")
#set($countryCodeAttrName = "Country code")
#set($countryDecodedAttrName = "Country decoded")
#set($cityAttrName = "City")
#set($whoRegionDecodedAttrName = "Who region decoded")
#set($timeZoneAttrName = "Time zone")
#set($siteDecodedAttrName = "Site decoded")
#set($siteEmergencyPhoneAttrName = "Emergency phone")

#set($siteCodeAttributeType = $locationService.getLocationAttributeTypeByName($siteCodeAttrName))
#set($countryCodeAttributeType = $locationService.getLocationAttributeTypeByName($countryCodeAttrName))
#set($countryDecodedAttributeType = $locationService.getLocationAttributeTypeByName($countryDecodedAttrName))
#set($cityAttributeType = $locationService.getLocationAttributeTypeByName($cityAttrName))
#set($whoRegionDecodedAttributeType = $locationService.getLocationAttributeTypeByName($whoRegionDecodedAttrName))
#set($timeZoneAttributeType = $locationService.getLocationAttributeTypeByName($timeZoneAttrName))
#set($siteDecodedAttributeType = $locationService.getLocationAttributeTypeByName($siteDecodedAttrName))
#set($siteEmergencyPhoneType = $locationService.getLocationAttributeTypeByName($siteEmergencyPhoneAttrName))

#set($locationTag  = $locationService.getLocationTagByName("Login Location"))
#set($tags = $util.newSet())
$tags.add($locationTag)

#foreach ($row in $outs)
	#if($row.SITE_CODE)	
		#set($location = $util.newObject($locationClass))
		#set($location.tags = $tags)
		#set($location.name = $row.SITE_CODE)
		#set($location.country = $row.COUNTRY_DECODED)
		#set($location.cityVillage = $row.CITY)

		#set($siteCodeAttr = $util.newObject($locationAttributeClass))
		#set($siteCodeAttr.attributeType = $siteCodeAttributeType)
		$siteCodeAttr.setValueReferenceInternal($row.SITE_CODE)
		$location.setAttribute($siteCodeAttr)

		#if($row.SITE_DECODED)
			#set($siteDecodedAttr = $util.newObject($locationAttributeClass))
			#set($siteDecodedAttr.attributeType = $siteDecodedAttributeType)
			$siteDecodedAttr.setValueReferenceInternal($row.SITE_DECODED)
			$location.setAttribute($siteDecodedAttr)
		#end
		#if($row.COUNTRY_CODE)
			#set($countryCodeAttr = $util.newObject($locationAttributeClass))
			#set($countryCodeAttr.attributeType = $countryCodeAttributeType)
			$countryCodeAttr.setValueReferenceInternal($row.COUNTRY_CODE)
			$location.setAttribute($countryCodeAttr)
		#end
		#if($row.WHO_REGION_DECODED)
			#set($whoRegionDecodedAttr = $util.newObject($locationAttributeClass))
			#set($whoRegionDecodedAttr.attributeType = $whoRegionDecodedAttributeType)
			$whoRegionDecodedAttr.setValueReferenceInternal($row.WHO_REGION_DECODED)
			$location.setAttribute($whoRegionDecodedAttr)
		#end
		#if($row.SITE_TIMEZONE)
			#set($timeZoneAttr = $util.newObject($locationAttributeClass))
			#set($timeZoneAttr.attributeType = $timeZoneAttributeType)
			$timeZoneAttr.setValueReferenceInternal($row.SITE_TIMEZONE)
			$location.setAttribute($timeZoneAttr)
		#end
		#if($row.EMERGENCY_PHONE)
			#set($emergencyPhone = $util.newObject($locationAttributeClass))
			#set($emergencyPhone.attributeType = $siteEmergencyPhoneType)
			$emergencyPhone.setValueReferenceInternal($row.EMERGENCY_PHONE)
			$location.setAttribute($emergencyPhone)
		#end
		#if($row.COUNTRY_DECODED)
			#set($countryDecodedAttr = $util.newObject($locationAttributeClass))
			#set($countryDecodedAttr.attributeType = $countryDecodedAttributeType)
			$countryDecodedAttr.setValueReferenceInternal($row.COUNTRY_DECODED)
			$location.setAttribute($countryDecodedAttr)
		#end
		#if($row.CITY)
			#set($cityAttr = $util.newObject($locationAttributeClass))
			#set($cityAttr.attributeType = $cityAttributeType)
			$cityAttr.setValueReferenceInternal($row.CITY)
			$location.setAttribute($cityAttr)
		#end

		#set($sourceKey = "siteCode_city")
		#set($sourceValue = $row.site_code + "~" + $row.city)
		#if ($locationService.getLocation($row.SITE_CODE))
			$irisLocationService.updateLocation($location)
		#else 
			$irisLocationService.saveLocation($location)
		#end
	#end
#end','',1000,10,'d88a11d2-d9ed-4d38-85ad-675b1d478789',1,1,NOW(), NOW()),
('Failed Visits','','SELECT * from dosing_solidarity where refresh_date > NOW() - INTERVAL 1 DAY;
','#foreach($row in $rows)
	$outs.add($row);
#end','##________ QUERY _________##
SELECT * from dosing_solidarity where refresh_date > NOW() - INTERVAL 1 DAY;

##________ TRANSFORM _________##
##transform
#foreach($row in $rows)
		$outs.add($row);
#end

##________ LOAD _________##
#set($calendarClass = $util.loadClass("java.util.Calendar"))
#set($cal = $calendarClass.getInstance())
## 5 is Calendar.DATE
$cal.add(5, -1)
#set($notSavedVisits = $etlErrorService.getVisitErrorLogs("MariaDB", "Visit schedule", $cal.getTime(), $util.today()))

#if ($rows.size() > 0 && $notSavedVisits.size() > 0)

   	#set($visitClass = "org.openmrs.Visit")
	#set($otherLocationUuid = "8d6c993e-c2cc-11de-8d13-0010c6dffd0f")
	#set($today = $util.today())
	#set($visitAttributeClass = "org.openmrs.VisitAttribute")
	#set($otherVisitTypeUuid = "5247a295-4528-4f7e-aec7-5febd4566dc1")

	#set($visitStatusAttributeTypeName = "Visit Status")
	#set($refreshDateAttributeTypeName = "Refresh Date")
	#set($statusOfOccuredVisit = $adminService.getGlobalProperty("visits.statusOfOccurredVisit"))
	#set($otherLocation = $locationService.getLocationByUuid($otherLocationUuid))
	#set($otherVisitTypeName = "Other")

	#foreach($visitAttributeType in $visitService.getAllVisitAttributeTypes())
		#if($visitAttributeType.getName() == $visitStatusAttributeTypeName)
			#set($visitStatusAttributeType = $visitAttributeType)
		#elseif($visitAttributeType.getName() == $refreshDateAttributeTypeName)
			#set($visitRefreshDateAttributeType = $visitAttributeType)
		#end
	#end
	
	#foreach($visitType in $visitService.getAllVisitTypes())
		#if($visitType.getName().toLowerCase() == $otherVisitTypeName.toLowerCase())
			#set($otherVisitType = $visitType)
		#end
	#end
	
	##for every previously failed in last 24h visit save
    #foreach($notSavedVisit in $notSavedVisits)
		#foreach($row in $rows)
			#if($row.uuid == $notSavedVisit.uuid && $row.visit_purpose == $notSavedVisit.visitPurpose && $row.date_dosing == $notSavedVisit.dosingDate)
			##save it once again, below same save logic as in visit etl, skip updateing last save GP though
				#set($previousVisits = $visitService.getVisitsByPatient($patientService.getPatientByUuid($row.uuid)))
				#set($isNewVisit = true)
				#foreach($visit in $previousVisits)
					#set($isVisitScheduled = false)
					#foreach($attribute in $visit.getActiveAttributes())
						#if($attribute.getAttributeType().getName() == $visitStatusAttributeTypeName && $attribute.getValue() == "SCHEDULED")
							#set($isVisitScheduled = true)
						#end
					#end
					#if($visit.visitType.name.toString().toLowerCase() == $row.VISIT_PURPOSE.toString().toLowerCase() && $isVisitScheduled == true)
						#set($occurredVisitStatusVisitAttribute = $util.newObject($visitAttributeClass))
						#set($occurredVisitStatusVisitAttribute.attributeType = $visitStatusAttributeType)
						$occurredVisitStatusVisitAttribute.setValueReferenceInternal($statusOfOccuredVisit)
						$visit.setAttribute($occurredVisitStatusVisitAttribute)

						#set($refreshDateVisitAttribute = $util.newObject($visitAttributeClass))
						#set($refreshDateVisitAttribute.attributeType = $visitRefreshDateAttributeType)
						$refreshDateVisitAttribute.setValueReferenceInternal($row.REFRESH_DATE.getTime().toString())
						$visit.setAttribute($refreshDateVisitAttribute)

						#set($visit.startDatetime = $util.stringToDate($row.DATE_DOSING, "dd-MMM-yy"))
						#set($visit.stopDatetime = $util.stringToDate($row.DATE_DOSING, "dd-MMM-yy"))
						#set($sourceKey = "uuid_visitPurpose_dateDosing")
						#set($sourceValue = $row.uuid + "~" + $row.visit_purpose + "~" + $row.date_dosing)
						$irisVisitService.saveVisit($visit)
						#set($isNewVisit = false)
					#end
				#end
				#if($isNewVisit == true)
					#set($visit = $util.newObject($visitClass))
					#set($visit.patient = $patientService.getPatientByUuid($row.uuid))
					#set($visit.startDatetime = $util.stringToDate($row.DATE_DOSING, "dd-MMM-yy"))
					#set($visit.stopDatetime = $util.stringToDate($row.DATE_DOSING, "dd-MMM-yy"))
					#set($visit.location = $otherLocation)

					#set($occurredVisitStatusVisitAttribute = $util.newObject($visitAttributeClass))
					#set($occurredVisitStatusVisitAttribute.attributeType = $visitStatusAttributeType)
					$occurredVisitStatusVisitAttribute.setValueReferenceInternal($statusOfOccuredVisit)
					$visit.setAttribute($occurredVisitStatusVisitAttribute)

					#set($refreshDateVisitAttribute = $util.newObject($visitAttributeClass))
					#set($refreshDateVisitAttribute.attributeType = $visitRefreshDateAttributeType)
					$refreshDateVisitAttribute.setValueReferenceInternal($row.REFRESH_DATE.getTime().toString())
					$visit.setAttribute($refreshDateVisitAttribute)

					#set($visit.visitType = $otherVisitType)
					#foreach($visitType in $visitService.getAllVisitTypes())
						#if($visitType.getName().toLowerCase() == $row.VISIT_PURPOSE.toString().toLowerCase())
							#set($visit.visitType = $visitType)
						#end
					#end

					#set($sourceKey = "uuid_visitPurpose_dateDosing")
					#set($sourceValue = $row.uuid + "~" + $row.visit_purpose + "~" + $row.date_dosing)
					$irisVisitService.saveVisit($visit)
				#end
			#end
		#end
    #end
#end
','',1000,10,'98d43191-7395-449b-98d1-0eb5dc809160',1,1,NOW(), NOW());;
