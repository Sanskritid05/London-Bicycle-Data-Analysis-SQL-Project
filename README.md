# London Bike Data Analysis (BigQuery)

## Project Intention

The primary goal of this project is to simulate how a data analyst would approach a real-world urban mobility problem using large-scale data.

This project focuses on understanding how a public bicycle-sharing system is used across a major city by analyzing ride patterns, demand trends, and station-level performance. The intention is not just to write SQL queries, but to extract meaningful, business-relevant insights that could help improve operational efficiency and user experience.

---

## Problem Statement

Urban transportation systems often struggle with:

* Uneven demand across locations
* Peak-hour congestion
* Inefficient bike distribution
* Lack of visibility into user behavior

This project aims to address these challenges by analyzing:

* When bikes are used (time-based demand)
* Where bikes are used (station-level insights)
* How bikes are used (ride patterns and duration)

---

## Objectives

* Clean and prepare raw ride data for analysis
* Identify peak demand hours and high-traffic days
* Analyze ride duration patterns and user behavior
* Evaluate station performance (inflow, variability, demand spikes)
* Detect anomalies and inefficiencies in usage
* Provide actionable recommendations based on insights

---

## Dataset

* Source: Google BigQuery Public Dataset
* Table: `bigquery-public-data.london_bicycles.cycle_hire`
* Scale: Millions of ride records

The dataset includes:

* Ride duration
* Start and end stations
* Timestamps of rides

---

## Approach

The project follows a structured analytical workflow:

1. **Data Cleaning**

   * Removed invalid durations
   * Filtered missing station data
   * Created derived fields (hour, day, duration in minutes)

2. **Exploratory Analysis**

   * Demand patterns across time
   * Usage distribution across stations
   * Ride duration segmentation

3. **Operational Insights**

   * Identified high-demand stations
   * Measured inflow and variability
   * Evaluated station-level performance

4. **Advanced Analysis**

   * Peak demand spikes detection
   * Weekday vs weekend behavior
   * Identification of outliers and anomalies

---

## Key Insights (Summary)

* Bike usage is heavily concentrated during commuting hours
* Weekday demand significantly exceeds weekend usage
* Majority of rides are short-duration, indicating last-mile usage
* Certain stations act as high-demand hubs requiring redistribution
* Some routes show extreme durations, highlighting data anomalies

---

## Business Impact

The insights from this analysis can help:

* Optimize bike redistribution strategies
* Improve service availability during peak hours
* Enhance infrastructure planning in high-demand zones
* Better understand commuter vs leisure usage patterns
* Identify and correct data inconsistencies

---

## Tools & Technologies

* SQL (Google BigQuery)
* Data Cleaning and Feature Engineering
* Exploratory Data Analysis

---

## Project Structure

* `queries.sql` → All SQL queries used in analysis
* `analysis.md` → Questions, screenshots, and insights
* `README.md` → Project overview and explanation

---

## Conclusion

This project demonstrates how structured SQL analysis can be used to transform raw data into actionable insights. It reflects a real-world analytical mindset, combining technical skills with business understanding to solve practical problems in urban mobility systems.

---

## Author

Sanskriti Dutta
27-04-2026
