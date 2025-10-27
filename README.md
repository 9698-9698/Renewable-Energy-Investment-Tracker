# 🌍 Renewable Energy Market & Investment Tracker

An interactive **Power BI dashboard** integrating **Excel** and **SQL** workflows to analyze global **renewable energy investments**, **consumption patterns**, and **electricity generation trends** from **2015–2024**.  

This project showcases **data cleaning, integration, and visualization** skills using real-world renewable energy market data.

---

## 🎯 Project Motivation

As a Market Research Analyst transitioning toward **Data Analytics**, I designed this project to strengthen my **Power BI, SQL, and data storytelling skills** while exploring the **global shift toward renewable energy**.  
It demonstrates my ability to translate complex data into meaningful insights for decision-making and investment evaluation.

---

## 📊 Project Overview

This project tracks the global transition toward clean energy by analyzing how **investments, consumption, and generation trends** have evolved across regions and energy sources.

It answers key questions such as:

- How are global energy investments distributed among fossil, renewable, and nuclear sources?  
- Which regions are leading the transition toward renewable energy?  
- What is the relationship between GDP, energy consumption, and investment intensity?  
- How does energy investment evolve relative to GDP and renewable adoption rates?

---

## ⚙️ Tools & Technologies

| Tool | Purpose |
|------|----------|
| **SQL** | Data cleaning, transformation, integration, and performance optimization |
| **Excel / Power Query** | Initial data preparation, unpivoting, and reshaping |
| **Power BI (DAX)** | Dashboard development, measure creation, interactivity, and storytelling |
| **Data Sources** | IEA, World Bank, Our World in Data (Region-level aggregates, 2015–2024) |

---

## 🧹 Data Preparation Summary

### 🔸 Excel
- Removed unnecessary rows/columns; standardized headers  
- Filtered for 2015–2024  
- Aggregated countries into six key regions: *North America, Europe, Asia Pacific, Latin America, Middle East & Africa, and World*  
- Unpivoted data (wide → long format) using **Power Query**  
- Ensured consistency in region naming and formatting  

### 🔸 SQL
- Standardized schema and fixed inconsistent column names  
- Created indexes `(region_code, year)` for efficiency  
- Cleaned and casted data types for accurate aggregations  
- Aggregated into domain-specific tables: `agg_gdp`, `agg_population`, `agg_renewable`, `agg_energy`, `agg_investment`  
- Joined all aggregates into a unified view: `energy_investment_combined`  

---

## 🧠 Dashboard Overview (Power BI)

The dashboard consists of **4 interactive pages** answering strategic questions on energy transition and investment behavior.

| Page | Title | Key Focus | Example Visuals |
|------|--------|------------|----------------|
| 🏠 **Page 1** | Executive Summary | Global KPIs, GDP vs Energy Use, Top Regions | KPI Cards, Combo Line-Bar Charts |
| ⚡ **Page 2** | Energy Source & Consumption Trends | Renewable vs Fossil Use, Mix by Region | 100% Stacked Columns, Donut Charts |
| 🔋 **Page 3** | Electricity Generation & Demand | Power Generation, Forecast, Supply–Demand Gap | Line Forecasts, KPIs |
| 💰 **Page 4** | Investment Insights | Energy Investment Intensity & Mix | Line + Bar Combo, Region Ranking |

---

## 🧭 How to View / Use

You can explore this project in two ways:

1. **📁 Download & Open Locally**  
   - Clone or download the repository  
   - Open the `.pbix` file in **Power BI Desktop (2023 or later)**  
   - Ensure the Excel/SQL data paths are correctly set if prompted  

2. **📸 View Screenshots / Demo Video**  
   - Navigate to the `/images/` folder for page-wise dashboard visuals  
   - (Optional) Watch short demo clips uploaded alongside the repository

---

## 💡 Key Insights

- **Asia Pacific** leads in both **total and clean energy investment**, driven by policy support and demand growth.  
- **Europe and Latin America** show the **highest renewable shares** in total consumption and generation, reflecting mature transition policies.  
- **GDP and energy consumption** exhibit a strong positive correlation — but growth stabilizes in developed regions due to efficiency gains.  
- **Investment as % of GDP** indicates how effectively regions prioritize long-term energy security.  
- Despite rising renewable capacity, **fossil fuels remain dominant** due to cost, infrastructure, and reliability factors.

---

## 📈 Example DAX Measures

```DAX
Renewable_Share = 
DIVIDE([Renewable Energy Consumption], [Total Energy Consumption])

Energy_Investment_Intensity = 
DIVIDE([Total Energy Investment], [GDP])

Electricity_Supply_Demand_Gap = 
[Electricity Generation] - [Electricity Demand]

Previous Year GDP = 
VAR currYear = MAX('renewable_energy energy_investment_combined'[year])
RETURN
CALCULATE(
    [Total GDP],
    FILTER(
        ALL('renewable_energy energy_investment_combined'),
        'renewable_energy energy_investment_combined'[year] = currYear - 1 &&
        'renewable_energy energy_investment_combined'[region] IN VALUES('renewable_energy energy_investment_combined'[region])
    )
)

YoY % GDP Change = 
DIVIDE([Total GDP] - [Previous Year GDP], [Previous Year GDP])

📂 Repository Structure
Renewable_Energy_Investment_Tracker/
│
├── data/
│   ├── raw_data.xlsx
│   ├── cleaned_data.xlsx
│   └── sql_scripts.sql
│
├── powerbi_dashboard/
│   └── Renewable_Energy_Market_&_Investment_Tracker.pbix
│
├── documentation/
│   ├── project_briefing.docx
│   └── renewable_energy_analysis_report.md
│
├── dashboard preview/
│   ├── page1_energy_overview.png
│   ├── page2_consumption_trends.png
│   ├── page3_generation.png
│   └── page4_investment.png
│   └── project_demo
│
└── README.md

🧠 Learnings & Challenges

Strengthened understanding of data modeling, DAX formulas, and visual storytelling in Power BI.

Applied SQL joins and aggregations for efficient multi-source data integration.

Improved skills in data cleaning and unpivoting for complex Excel datasets.

Enhanced ability to derive business insights from macroeconomic and energy datasets.

.

👩‍💻 Author

Vishakha Jain
📊 Market Research & Data Analyst | Power BI | SQL | Excel
🔗 LinkedIn Profile: https://www.linkedin.com/in/vishakha-jain-a8943312b/

⭐ If you found this project insightful, feel free to star the repository and connect with me on LinkedIn!
🖤 Your feedback is always welcome!