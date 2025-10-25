# 🦄 Unicorn Company Analysis

## 📍 Project Overview

The **Unicorn Company Analysis** project explores and analyzes the global landscape of **unicorn startups** — privately held companies valued at over **$1 billion**.
Using **MySQL** for data exploration and **Power BI** for visualization, the project provides data-driven insights into the growth, valuation, funding, and distribution of unicorns worldwide.

The main objectives include:

* Analyzing **historical growth** and trends of unicorns over time.
* Identifying the **top countries and industries** producing unicorns.
* Understanding **funding vs. valuation** relationships.
* Exploring **investor influence** and funding patterns.
* Creating **interactive dashboards** to visualize insights.

This project is ideal for **data analysts, investors, and startup enthusiasts** who want to understand the evolving global startup ecosystem through data.

---

## 📦 Dataset Information

The project integrates multiple dimensions such as company details, industry, funding, and founding dates.
These datasets together enable comprehensive exploration of valuation growth, funding efficiency, and regional trends.

| Table             | Description                                                        |
| ----------------- | ------------------------------------------------------------------ |
| 🏢 **Companies**  | Contains company name, location (city, country, continent).        |
| 💰 **Funding**    | Includes valuation, total funding amount, and selective investors. |
| 🧾 **Dates**      | Tracks year founded and date joined unicorn list.                  |
| 🏭 **Industries** | Classifies each company by its industry sector.                    |

All four tables are linked by a common key — `company_id`.

---

---

## 🧠 Solution Workflow

1. **Data Cleaning:**
   Imported and cleaned the raw CSV files in Excel. Ensured date consistency and removed nulls.

2. **Database Design:**
   Created relational tables in MySQL with primary–foreign key relationships.

3. **SQL Analysis:**
   Executed multiple queries to answer key business questions.

4. **Visualization:**
   Connected Power BI to MySQL and visualized results using KPIs, bar charts, line graphs, and maps.

5. **Dashboard Creation:**
   Designed an interactive dashboard summarizing unicorn growth, valuation, funding ratios, and industry insights.

---

## 💡 Key SQL Queries & Insights

### 🔹 1. Total Unicorn Companies

```sql
SELECT COUNT(DISTINCT company_id) AS Total_Companies
FROM companies;
```

### 🔹 2. Top 5 Most Valuable Companies

```sql
SELECT c.company, SUM(f.valuation) AS valuation
FROM companies c
JOIN funding f ON c.company_id = f.company_id
GROUP BY c.company
ORDER BY valuation DESC
LIMIT 5;
```

### 🔹 3. Number of Unicorns per Continent

```sql
SELECT continent, COUNT(company_id) AS no_of_companies
FROM companies
GROUP BY continent
ORDER BY no_of_companies DESC;
```

### 🔹 4. Average Valuation by Industry

```sql
SELECT i.industry, AVG(f.valuation) AS avg_valuation
FROM industries i
JOIN funding f ON i.company_id = f.company_id
GROUP BY i.industry
ORDER BY avg_valuation DESC;
```

### 🔹 5. Companies with the Most Selective Investors

```sql
SELECT c.company,
       LENGTH(f.select_investors) - LENGTH(REPLACE(f.select_investors, ',', '')) + 1 AS investor_count
FROM funding f
JOIN companies c ON f.company_id = c.company_id
ORDER BY investor_count DESC
LIMIT 15;
```

### 🔹 6. Top 5 Companies by Valuation-to-Funding Ratio

```sql
SELECT c.company,
       ROUND(SUM(f.valuation) / SUM(f.funding), 2) AS valuation_to_funding_ratio
FROM companies c
JOIN funding f ON f.company_id = c.company_id
GROUP BY c.company
ORDER BY valuation_to_funding_ratio DESC
LIMIT 5;
```

---

## 📊 Visual Insights in Power BI

| Insight                         | Visualization Type |
| ------------------------------- | ------------------ |
| Top 10 Unicorns by Valuation    | Bar Chart          |
| Unicorn Growth Over Time        | Line Chart         |
| Unicorns by Continent           | Bar Chart          |
| Average Valuation by Industry   | Column Chart       |
| Funding vs Valuation Comparison | Column Chart       |
| Top Investors                   | Bar Chart          |

### 📈 Key Highlights

* **USA** and **China** together contribute ~80% of global unicorns.
* **Fintech** and **E-Commerce** are the top performing industries.
* **Average years to become a unicorn:** 6–8 years post-founding.
* **Tiger Global** and **Sequoia Capital** appear among the most frequent investors.

---

## 🧰 Tools Used

| Tool            | Purpose                                |
| --------------- | -------------------------------------- |
| 🐬 **MySQL**    | Data storage, querying, and analysis   |
| 📊 **Power BI** | Visualization and dashboard creation   |
| 🧮 **Excel**    | Data cleaning and initial exploration  |

---

---

## 🎯 Key Takeaways

* The **Fintech** sector dominates in both funding and valuation.
* **USA** and **Asia** are the global hubs for unicorn formation.
* Majority of unicorns achieved their status **after 2015**, showing exponential growth.
* Companies with **diverse investor networks** tend to achieve unicorn status faster.

📌 **Business Tip:**
Investors and entrepreneurs should target emerging markets and tech-driven sectors while focusing on post-Series-A funding stages for faster valuation growth.

---

---

## 🤝 Contact

**Kaliraj R**  
Data Analyst  
📧 kalirajkarthi3@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/kaliraj-r-3s)

Feel free to fork, enhance queries, or create your own visualizations! 🚀

---
