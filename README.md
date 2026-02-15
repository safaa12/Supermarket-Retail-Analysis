# Supermarket-Retail-Analysis

# Shefa Yissachar Retail Analytics | Data-Driven Performance Optimization

## Project Overview
This project provides an in-depth analysis of retail operations for the "Shefa Yissachar" supermarket chain. By merging geolocation data with sales logs, the analysis identifies operational bottlenecks, customer behavior patterns, and profitability drivers to provide actionable business recommendations.

## Key Business Questions
* **Profitability:** How can we maximize revenue at the Yavne branch?
* **Customer Experience:** Is there a positive correlation between dwell time and basket size?
* **Operational Efficiency:** Where are the peak-hour bottlenecks, and how can we optimize staffing?

## Methodology & Tools
* **SQL (BigQuery):** Extensive data processing, customer segmentation, and KPI calculation.
* **Exploratory Data Analysis (EDA):** Univariate and bivariate analysis of transaction distributions.
* **Statistical Modeling:** Linear regression to predict customer growth trends and revenue based on dwell time.
* **Visualization:** Dashboarding with Looker Studio and automated heatmaps to visualize branch traffic.

## Insights & Impact
* **Correlation Found:** Each additional minute in-store contributes an average of 7.5 NIS to the transaction.
* **Customer Segmentation:** Identified "Repeat Customers" vs. "One-time" visitors to refine loyalty strategies.
* **Technical Integrity:** Validated mobile app reception rates (41.79%) against industry benchmarks to ensure data reliability.
* **Supply Chain:** Detected missed deliveries by cross-referencing supplier presence with scheduled warehouse windows.

## Data Structure
The analysis is based on two primary datasets:
1. `log_sales`: Transactional data including sale IDs, totals, and payment methods.
2. `geolocation`: Real-time device pings including accuracy metrics and area classifications.
