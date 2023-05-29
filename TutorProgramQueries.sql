USE TutorProgramDB

/*1. How many students participated in the program over the five-year time period?*/
 
 SELECT
	prog_status,
	--grad_status,
	COUNT(*) AS total_students
 FROM Outcomes
 GROUP BY prog_status;


/*2. Create a table to calculate the completion rates (percentage of students who completed the program) and 
success rates (percentage of students who completed the program and graduated high school) by learning method. */

WITH counts AS (
    SELECT
        learn_method,
        COUNT(*) AS num_of_students,
        COUNT(CASE WHEN prog_status = 'Completed' AND grad_status = 'Graduated' THEN 1 END) AS success,
        COUNT(CASE WHEN prog_status = 'Completed' THEN 1 END) AS completion
    FROM Outcomes
    GROUP BY learn_method
)
SELECT
    c.learn_method,
    c.num_of_students,
	c.completion,
    FORMAT(1.0 * c.completion / c.num_of_students, 'P1') AS completion_rate,
	c.success,
    FORMAT(1.0 * c.success / c.num_of_students, 'P1') AS success_rate
FROM counts AS c
ORDER BY success_rate DESC;

/*3. Which learning method (in-person, hybrid, remote) is the most popular? */

SELECT
	--YEAR(enroll_date) AS enroll_year,
	learn_method,
	COUNT(*) AS total_students
FROM Outcomes
GROUP BY 
	--YEAR(enroll_date),
	learn_method
ORDER BY COUNT(*) DESC;

/* 4. For students who completed the program, which method has the best academic outcomes? */

SELECT
	learn_method,
	prog_status,
	COUNT(*) AS num_of_students,
	ROUND((AVG(end_GPA) - AVG(enroll_GPA)),2) AS avg_GPA_difference,
	ROUND(AVG(SAT_comp),0) AS avg_SAT,
	ROUND(AVG(ACT_comp),0) AS avg_ACT,
	FORMAT(ROUND(AVG(post_assess),2),'P') AS avg_post_assess,
	ROUND(AVG(post_self),2) AS avg_post_self
FROM Outcomes
WHERE prog_status = 'Completed'
GROUP BY 
	learn_method
	,prog_status

/*5. How do the academic results post_program differ among students who completed the tutoring program and graduated and 
those students who withdrew from the program and graduated? */

SELECT
	prog_status,
	FORMAT(ROUND(AVG(end_GPA),2),'#.##') AS avg_end_GPA,
	ROUND(AVG(SAT_comp),0) AS avg_SAT,
	ROUND(AVG(ACT_comp),0) AS avg_ACT,
	FORMAT(ROUND(AVG(post_assess),2),'P') AS avg_post_assess,
	ROUND(AVG(post_self),2) AS avg_post_self
FROM Outcomes
WHERE grad_status = 'Graduated'
GROUP BY prog_status

/*6. What was the average number of tutoring sessions attended for graduates compared to those who did not graduate? */

SELECT
	grad_status,
	AVG(tot_sessions) AS avg_num_sessions
FROM Outcomes
WHERE prog_status = 'Completed'
GROUP BY grad_status

/*7. How soon are students dropping out of the program after enrolling? */

SELECT
	AVG(days_between) AS days_enrolled,
	AVG(tot_sessions) AS avg_num_sessions
FROM Outcomes
WHERE prog_status = 'Withdrawn'


/*8. What were the top five reasons for withdrawal from the tutoring program? How did the frequency of withdrawal reasons 
differ based on graduation status? */

SELECT TOP 5
	prog_status,
	o.feedback_id,
	reason,
	COUNT(o.feedback_id) AS tot_withdrawal_reason,
	COUNT(CASE WHEN grad_status = 'Graduated' THEN o.feedback_id END) AS grads,
	COUNT(CASE WHEN grad_status = 'Did Not Graduate' THEN o.feedback_id END) AS non_grads
FROM Outcomes AS o
INNER JOIN Feedback AS f
	ON o.feedback_id = f.feedback_id
WHERE prog_status = 'Withdrawn' 
GROUP BY 
	prog_status,
	o.feedback_id,
	reason
ORDER BY 4 DESC;


/*9. How do academic outcomes differ by tutor?*/

WITH counts AS (
    SELECT
        tutor_name,
        COUNT(*) AS num_of_students,
        COUNT(CASE WHEN prog_status = 'Completed' AND grad_status = 'Graduated' THEN 1 END) AS success,
        COUNT(CASE WHEN prog_status = 'Completed' THEN 1 END) AS completion
    FROM Outcomes
    GROUP BY tutor_name
)
SELECT
    c.tutor_name,
    c.num_of_students,
	c.completion,
    FORMAT(1.0 * c.completion / c.num_of_students, 'P1') AS completion_rate,
	c.success,
    FORMAT(1.0 * c.success / c.num_of_students, 'P1') AS success_rate,
	FORMAT(ROUND((AVG(end_GPA) - AVG(enroll_GPA)),2), '#.##') AS avg_GPA_difference,
	ROUND(AVG(SAT_comp),0) AS avg_SAT,
	ROUND(AVG(ACT_comp),0) AS avg_ACT,
	FORMAT(ROUND(AVG(post_assess),2),'P') AS avg_post_assess,
	ROUND(AVG(post_self),2) AS avg_post_self
FROM counts AS c
INNER JOIN Outcomes AS o
	ON c.tutor_name = o.tutor_name
GROUP BY
	c.tutor_name,
    c.num_of_students,
	c.completion,
	FORMAT(1.0 * c.completion / c.num_of_students, 'P1'),
	c.success,
    FORMAT(1.0 * c.success / c.num_of_students, 'P1')
ORDER BY success_rate DESC;

/*10. How many students that completed the program would be able to apply for each college or university based on their GPA and SAT or ACT scores? */

SELECT
	college_name,
	req_GPA,
	req_SAT,
	req_ACT,
	COUNT(*) AS total_eligible
FROM 
	colleges AS c,
	outcomes AS o
WHERE
	prog_status = 'Completed'
	AND grad_status = 'Graduated'
	AND (o.end_GPA >= c.req_GPA)
	AND ((o.SAT_comp >= c.req_SAT) OR (o.ACT_comp >= c.req_ACT))
GROUP BY 
	college_name,
	req_GPA,
	req_SAT,
	req_ACT
ORDER BY COUNT(*)

/*11. A student wants to attend a college with a Top 5 ranked Health Professions Program. She has a 3.6 GPA and an 1250 SAT score.
Which schools should she apply to?*/

SELECT 
	college_name,
	college_prog,
	prog_rank,
	req_GPA,
	req_SAT
FROM colleges as c
INNER JOIN CollegePrograms AS cp
	ON c.college_abbrev = cp.college_abbrev
WHERE 
	req_GPA <= 3.6
	AND req_SAT <= 1250
	AND college_prog = 'Health Professions'
	AND prog_rank <= 5
ORDER BY 3

/*12. A student wants to attend a college with a Top 3 ranked Social Sciences Program. What GPA and SAT or ACT score would he need to obtain? */

SELECT 
	college_name,
	college_prog,
	prog_rank,
	req_GPA,
	req_SAT
FROM colleges as c
INNER JOIN CollegePrograms AS cp
	ON c.college_abbrev = cp.college_abbrev
WHERE 
	college_prog = 'Social Sciences'
	AND prog_rank <= 3
ORDER BY 3