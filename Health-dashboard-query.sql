/* Goals
 Implement a flu shots dashboard for 2022
 - Showing total % of patients recieving flu shots stratified by
 	1.) Age
	2.) Race
	3.) Location (County)
	4.) Overall
 - RunningTotal of flu shots over 2022
 - Total number of flu shots given in 2022
 - A list of patients patients that have recieved a flu shot and have not
 */

WITH active_clients as 
(
	SELECT distinct patient as client
	FROM encounters as e
	JOIN patients as p
		on e.patient = p.id
	WHERE start BETWEEN '2022-01-01 00:00' AND '2022-12-31 23:59'
	 AND p.deathdate is NULL
	 AND EXTRACT(EPOCH FROM age('2022-12-31',p.birthdate)) / 2592000 >= 6
),
flu_shot_2022 as
(
 /* Patients wiith relevent immunization*/
	SELECT patient as client, min(date) as earliest_flu_shot
	from immunizations
	WHERE code = '5302'
 		AND date BETWEEN '2022-01-01 00:00' AND '2022-12-31 23:59' 
	GROUP BY patient
 )
/* Relevent columnns from patients table*/
SELECT pat.birthdate
	,EXTRACT(YEAR FROM age('12-31-2022', birthdate)) as age
 	,pat.race
	,pat.county
	,pat.id
	,pat.first
	,pat.last
	,f.client
	,f.earliest_flu_shot
	,CASE WHEN f.client IS NOT NULL THEN 1
		ELSE 0
		END as flu_immunized
FROM patients as pat
LEFT JOIN flu_shot_2022 as f
	ON pat.id = f.client
WHERE pat.id in (SELECT client from Active_clients )



