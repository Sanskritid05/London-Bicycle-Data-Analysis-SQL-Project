/* =========================================================
   LONDON BICYCLE DATA ANALYSIS PROJECT (BIGQUERY)
   ========================================================= */


/* =========================================================
   BASIC DATA CLEANING & FEATURE ENGINEERING
   ========================================================= */

-- Preview cleaned dataset with derived columns
SELECT
    rental_id,
    bike_id,
    duration / 60 AS duration_minutes,
    start_station_name,
    end_station_name,
    start_date,
    EXTRACT(HOUR FROM start_date) AS start_hour,
    EXTRACT(DAYOFWEEK FROM start_date) AS day_of_week
FROM `bigquery-public-data.london_bicycles.cycle_hire`
WHERE
    duration > 0
    AND duration < 86400
    AND start_station_name IS NOT NULL
    AND end_station_name IS NOT NULL
LIMIT 100;



/* =========================================================
   DEMAND OVERVIEW
   ========================================================= */

-- Which start stations have the highest number of bike rides?
SELECT 
    start_station_name, 
    COUNT(*) AS bike_ride_count
FROM `bigquery-public-data.london_bicycles.cycle_hire`
WHERE
    duration > 0
    AND duration < 86400
    AND start_station_name IS NOT NULL
    AND end_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY bike_ride_count DESC 
LIMIT 1;


-- At what hour of the day are bike rides most frequent (top 3)?
SELECT 
    EXTRACT(HOUR FROM start_date) AS peak_riding_hours, 
    COUNT(*) AS ride_count
FROM `bigquery-public-data.london_bicycles.cycle_hire`
WHERE
    duration > 0
    AND duration < 86400
    AND start_station_name IS NOT NULL
    AND end_station_name IS NOT NULL
GROUP BY peak_riding_hours
ORDER BY ride_count DESC 
LIMIT 3;


-- Which days of the week have the highest bike usage?
SELECT 
    CASE EXTRACT(DAYOFWEEK FROM start_date)
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END AS day_name,
    COUNT(*) AS bike_usage
FROM `bigquery-public-data.london_bicycles.cycle_hire`
WHERE
    duration > 0
    AND duration < 86400
    AND start_station_name IS NOT NULL
    AND end_station_name IS NOT NULL
GROUP BY day_name
ORDER BY bike_usage DESC;



/* =========================================================
   TIME-BASED DEMAND
   ========================================================= */

-- How does bike usage differ between weekdays and weekends?
SELECT 
    CASE 
        WHEN EXTRACT(DAYOFWEEK FROM start_date) BETWEEN 2 AND 6 THEN 'Weekday'
        ELSE 'Weekend'
    END AS day_type,
    COUNT(*) AS ride_count
FROM `bigquery-public-data.london_bicycles.cycle_hire`
WHERE
    duration > 0
    AND duration < 86400
    AND start_station_name IS NOT NULL
    AND end_station_name IS NOT NULL
GROUP BY day_type
ORDER BY ride_count DESC;



/* =========================================================
   RIDE CHARACTERISTICS (USAGE PATTERNS)
   ========================================================= */

-- What is the distribution of ride durations?
SELECT 
    CASE 
        WHEN duration/60 < 5 THEN '0-5 mins'
        WHEN duration/60 < 15 THEN '5-15 mins'
        WHEN duration/60 < 30 THEN '15-30 mins'
        ELSE '30+ mins'
    END AS duration_bucket,
    COUNT(*) AS ride_count
FROM `bigquery-public-data.london_bicycles.cycle_hire`
WHERE
    duration > 0
    AND duration < 86400
    AND start_station_name IS NOT NULL
    AND end_station_name IS NOT NULL
GROUP BY duration_bucket
ORDER BY ride_count DESC;


-- What are the most popular routes (start to end)?
SELECT
    start_station_name,
    end_station_name,
    COUNT(*) AS total_rides
FROM `bigquery-public-data.london_bicycles.cycle_hire`
WHERE
    duration > 0
    AND duration < 86400
    AND start_station_name IS NOT NULL
    AND end_station_name IS NOT NULL
GROUP BY start_station_name, end_station_name
ORDER BY total_rides DESC
LIMIT 10;


-- What percentage of rides are short trips (under 10 minutes)?
SELECT
    ROUND(
        100 * SUM(CASE WHEN duration/60 < 10 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS short_ride_percentage
FROM `bigquery-public-data.london_bicycles.cycle_hire`
WHERE
    duration BETWEEN 1 AND 86400
    AND start_station_name IS NOT NULL
    AND end_station_name IS NOT NULL;



/* =========================================================
   STATION PERFORMANCE (OPERATIONAL INSIGHTS)
   ========================================================= */

-- Which stations experience the highest ride inflow (arrivals)?
SELECT
    end_station_name,
    COUNT(*) AS total_arrivals
FROM `bigquery-public-data.london_bicycles.cycle_hire`
WHERE
    duration BETWEEN 1 AND 86400
    AND end_station_name IS NOT NULL
GROUP BY end_station_name
ORDER BY total_arrivals DESC
LIMIT 10;


-- Which stations have the highest average ride duration?
SELECT
    start_station_name,
    ROUND(AVG(duration)/60, 2) AS avg_duration_minutes
FROM `bigquery-public-data.london_bicycles.cycle_hire`
WHERE
    duration BETWEEN 1 AND 86400
    AND start_station_name IS NOT NULL
GROUP BY start_station_name
HAVING COUNT(*) > 500
ORDER BY avg_duration_minutes DESC
LIMIT 10;


-- Which stations show the highest variability in ride duration?
SELECT
    start_station_name,
    ROUND(STDDEV(duration)/60, 2) AS duration_variability
FROM `bigquery-public-data.london_bicycles.cycle_hire`
WHERE
    duration BETWEEN 1 AND 86400
    AND start_station_name IS NOT NULL
GROUP BY start_station_name
HAVING COUNT(*) > 500
ORDER BY duration_variability DESC
LIMIT 10;



/* =========================================================
   ADVANCED INSIGHTS
   ========================================================= */

-- Which stations experience peak demand spikes?
WITH hourly_usage AS (
    SELECT
        start_station_name,
        EXTRACT(HOUR FROM start_date) AS ride_hour,
        COUNT(*) AS hourly_rides
    FROM `bigquery-public-data.london_bicycles.cycle_hire`
    WHERE
        duration BETWEEN 1 AND 86400
        AND start_station_name IS NOT NULL
    GROUP BY start_station_name, ride_hour
),
avg_usage AS (
    SELECT
        start_station_name,
        AVG(hourly_rides) AS avg_hourly_rides
    FROM hourly_usage
    GROUP BY start_station_name
)
SELECT
    h.start_station_name,
    MAX(h.hourly_rides) AS peak_hour_rides,
    ROUND(a.avg_hourly_rides, 2) AS avg_hourly_rides
FROM hourly_usage h
JOIN avg_usage a
ON h.start_station_name = a.start_station_name
GROUP BY h.start_station_name, a.avg_hourly_rides
ORDER BY peak_hour_rides DESC
LIMIT 10;



/* =========================================================
   BUSINESS INSIGHTS & RECOMMENDATIONS
   ========================================================= */

-- Key findings:
-- Short-duration rides dominate, indicating strong last-mile connectivity
-- Peak-hour demand reflects commuting patterns
-- Certain stations experience high inflow and variability
-- Weekday usage dominates, indicating work-related travel

-- Recommendations:
-- Optimize bike redistribution at high-demand stations
-- Improve infrastructure in peak zones
-- Focus on short-ride user experience
-- Investigate long-duration routes
