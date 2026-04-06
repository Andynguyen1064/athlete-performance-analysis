SELECT *
FROM athlete_readiness;

RENAME TABLE athlete_training_recovery_tracker_dataset TO athlete_readiness;
ALTER TABLE athlete_readiness RENAME COLUMN Athlete_ID TO athlete_id;
ALTER TABLE athlete_readiness RENAME COLUMN Sport_Type TO sport_type;
ALTER TABLE athlete_readiness RENAME COLUMN Training_Hours TO training_hours;
ALTER TABLE athlete_readiness RENAME COLUMN Training_Intensity TO training_intensity;
ALTER TABLE athlete_readiness RENAME COLUMN Sleep_Hours TO sleep_hours;
ALTER TABLE athlete_readiness RENAME COLUMN Nutrition_Score TO nutrition_score;
ALTER TABLE athlete_readiness RENAME COLUMN Fatigue_Level TO fatigue_level;
ALTER TABLE athlete_readiness RENAME COLUMN Recovery_Index TO recovery_index;
ALTER TABLE athlete_readiness RENAME COLUMN Performance_Score TO performance_score;
ALTER TABLE athlete_readiness RENAME COLUMN Injury_Risk TO injury_risk;
ALTER TABLE athlete_readiness RENAME COLUMN Date TO record_date;



SELECT COUNT(*) AS total_rows
FROM athlete_readiness;

SELECT sport_type, COUNT(athlete_id) AS athlete_count
FROM athlete_readiness
GROUP BY sport_type
ORDER BY athlete_count DESC;



SELECT sport_type, injury_risk, COUNT(athlete_id) AS athlete_count
FROM athlete_readiness
GROUP BY sport_type, injury_risk
ORDER BY athlete_count DESC;


-- Baseline Averages
SELECT 
	ROUND(AVG(training_hours),2) AS avg_training_hours,
    ROUND(AVG(training_intensity),2) AS avg_training_intensity,
	ROUND(AVG(sleep_hours),2) AS avg_sleep_hours,
	ROUND(AVG(nutrition_score),2) AS avg_nutrition_score,
	ROUND(AVG(fatigue_level),2) AS avg_fatigue_level,
	ROUND(AVG(recovery_index),2) AS avg_recovery_index,
	ROUND(AVG(performance_score),2) AS avg_performance_score

FROM athlete_readiness;


-- Tennis has highest average performance score
SELECT sport_type, ROUND(AVG(performance_score),2) AS avg_performance_score
FROM athlete_readiness
GROUP BY sport_type
ORDER BY avg_performance_score DESC;


-- Athletics has highest avg_recovery
SELECT sport_type, ROUND(AVG(recovery_index),2) AS avg_recovery
FROM athlete_readiness
GROUP BY sport_type
ORDER BY avg_recovery DESC;


-- average fatigue is higher at intesnity 1?
SELECT training_intensity, 
	ROUND(AVG(fatigue_level),2) AS avg_fatigue
FROM athlete_readiness
GROUP BY training_intensity
ORDER BY training_intensity;


SELECT sleep_hours, ROUND(AVG(performance_score),2) AS avg_performance
FROM athlete_readiness
GROUP BY sleep_hours
ORDER BY avg_performance DESC;


-- Athlete performance correlating with specific sleep groups
SELECT
CASE
	WHEN sleep_hours <6 THEN "Under 6 Hours"
    WHEN sleep_hours BETWEEN 6 AND 7.9 THEN "6 to 7.9 Hours"
    ELSE "8+ Hours"
END AS sleep_group,

COUNT(athlete_id) AS athlete_count,
ROUND(AVG(fatigue_level),2) AS avg_fatigue,
ROUND(AVG(recovery_index),2) AS avg_recovery,
ROUND(AVG(performance_score),2) AS avg_performance

FROM athlete_readiness
GROUP BY sleep_group
ORDER BY avg_performance DESC;

-- Injury risk
SELECT
    injury_risk,
    ROUND(AVG(training_hours), 2) AS avg_training_hours,
    ROUND(AVG(training_intensity), 2) AS avg_training_intensity,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep,
    ROUND(AVG(nutrition_score), 2) AS avg_nutrition,
    ROUND(AVG(fatigue_level), 2) AS avg_fatigue,
    ROUND(AVG(recovery_index), 2) AS avg_recovery,
    ROUND(AVG(performance_score), 2) AS avg_performance
FROM athlete_readiness
GROUP BY injury_risk
ORDER BY avg_fatigue DESC;


-- High peformers VS Low performers
SELECT 
CASE
	WHEN performance_score <=65 THEN "Low Performer"
    WHEN performance_score >=85 THEN "High Performer"
    ELSE "Mid Performer"
END AS performance_group,
	COUNT(athlete_id) AS athlete_count,
	ROUND(AVG(training_hours), 2) AS avg_training_hours,
	ROUND(AVG(training_intensity), 2) AS avg_training_intensity,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep,
    ROUND(AVG(nutrition_score), 2) AS avg_nutrition,
    ROUND(AVG(fatigue_level), 2) AS avg_fatigue,
    ROUND(AVG(recovery_index), 2) AS avg_recovery
FROM athlete_readiness
GROUP BY performance_group
ORDER BY avg_recovery DESC;


-- Flagging athlete risk
SELECT
    COUNT(*) AS flagged_athletes,
    ROUND(AVG(performance_score), 2) AS avg_performance,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep,
    ROUND(AVG(fatigue_level), 2) AS avg_fatigue,
    ROUND(AVG(recovery_index), 2) AS avg_recovery
FROM athlete_readiness
WHERE sleep_hours < 6
  AND fatigue_level >= 7
  AND recovery_index < 70;
  






