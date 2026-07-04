# 📱 SmartSpec Analytics
### Smartphone Market Analysis & Price Prediction

An end-to-end data analytics project that scrapes, analyzes, and predicts smartphone prices using real-world marketplace data from Flipkart. This project integrates web scraping, SQL business analytics, statistical hypothesis testing, machine learning, and interactive dashboards into a single, complete analytics pipeline.

![Python](https://img.shields.io/badge/Python-3.x-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-336791)
![XGBoost](https://img.shields.io/badge/XGBoost-ML%20Model-orange)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow)
![Streamlit](https://img.shields.io/badge/Streamlit-Web%20App-red)

---

## 📌 Overview

SmartSpec Analytics analyzes **5,627 smartphone listings** across **16 brands**, collected directly from Flipkart through automated web scraping. The project answers key business questions — which brands dominate which price segments, what hardware configurations define the market standard, and whether smartphone prices can be accurately predicted from specifications alone.

The final deliverable includes:
- A cleaned, analysis-ready dataset
- 50+ SQL business queries
- 30+ EDA visualizations
- 5 hypothesis tests
- 3 machine learning models (best: **XGBoost, R² = 0.9709**)
- An interactive **Power BI dashboard**
- A live **Streamlit price-prediction app**

---

## 🎯 Objectives

- Analyze smartphone pricing, specifications, ratings, and brand distribution
- Clean and engineer features from unstructured, real-world scraped data
- Perform SQL-based business analysis and statistical hypothesis testing
- Build and compare regression models to predict smartphone prices
- Deploy insights through an interactive dashboard and a prediction web app

---

## 🗂️ Dataset

| Attribute | Value |
|---|---|
| Source | Flipkart |
| Collection Method | Automated web scraping (Selenium) |
| Collection Period | June 2026 |
| Total Records | 5,627 |
| Total Features | 16 |
| Unique Brands | 16 |
| Price Range | ₹5,299 – ₹2,20,000 |
| Missing Values | None (post-cleaning) |
| Target Variable | Price |

**Key features:** Brand, Price, MRP, Rating, Rating_Count, Discount, RAM, Storage, Battery, Reviews, Display, Camera, Processor.

---

## 🛠️ Tech Stack

| Category | Tools |
|---|---|
| Language | Python |
| Web Scraping | Selenium, ChromeDriver |
| Data Manipulation | Pandas, NumPy |
| Database | PostgreSQL |
| Statistical Analysis | SciPy |
| Machine Learning | Scikit-learn, XGBoost |
| Visualization | Matplotlib, Plotly |
| Business Intelligence | Power BI |
| Web Application | Streamlit |
| Dev Tools | Jupyter Notebook, VS Code, Git, GitHub |

---

## 🔄 Project Workflow

```
Flipkart Data → Selenium Web Scraping → Data Cleaning → Feature Engineering
→ PostgreSQL Database → SQL Business Analysis → Exploratory Data Analysis
→ Statistical Analysis → Machine Learning (Scikit-learn & XGBoost)
→ Power BI Dashboard → Streamlit Web Application
```

---

## 🧹 Data Cleaning & Feature Engineering

Raw scraped data required extensive preprocessing:
- Converted price/MRP strings (₹, commas) into numeric values
- Extracted RAM, Storage, and Battery from unstructured text using Regex
- Standardized inconsistent processor and brand names
- Handled missing values via median/mode imputation and Regex extraction
- Removed duplicate listings

**Engineered features:**
- `Price_Segment` — Budget / Mid Range / Premium / Ultra Premium
- `Performance_Score` — weighted composite of RAM, Storage, Battery, Rating
- `Value_Score` — performance relative to price (log-scaled)
- `Price_per_GB`, `Battery_to_Price_Ratio`
- `Display_Size`, `Display_Type`, `Rear_Main_MP`, `Front_MP`, `Rear_Camera_Count`

---

## 📊 Exploratory Data Analysis

- Smartphone prices are strongly right-skewed (median ₹19,999, mean ₹32,931)
- 8 GB RAM, 128 GB storage, and 5000 mAh battery are the market-standard configuration
- Samsung leads in listing volume; Apple and Google command the highest median prices
- Storage and RAM show strong positive correlation with price (0.65 and 0.40); battery shows weak correlation (-0.29)

Full visualizations (histograms, boxplots, correlation heatmap, brand comparisons) are available in the [`/notebooks`](./notebooks) folder.

---

## 📈 Statistical Analysis

Five hypothesis tests were conducted at a 95% confidence level:

| Test | Result |
|---|---|
| Premium vs Budget ratings (Welch's t-test) | Premium phones rated significantly higher (p < 0.001) |
| Price vs Rating (Pearson) | Moderate positive correlation (r = 0.48) |
| Discount vs Reviews (Pearson) | Weak negative correlation (r = -0.11) |
| 4GB vs 8GB RAM ratings (Welch's t-test) | Statistically significant, small practical difference |
| Rating vs Reviews (Spearman) | Weak positive monotonic relationship (ρ = 0.22) |

---

## 🗃️ SQL Business Analysis

50+ analytical SQL queries were written in PostgreSQL covering:
- Market overview & pricing analysis
- Brand performance benchmarking
- Price segment analysis
- Hardware specification distribution
- Customer rating analysis
- Advanced queries using **CTEs, subqueries, and window functions** (`RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`, `OVER()`)

SQL scripts are available in [`/sql`](./sql).

---

## 🤖 Machine Learning

**Problem:** Predict smartphone price (regression) from specifications.

**Models compared:**

| Model | MAE | RMSE | R² Score |
|---|---|---|---|
| Linear Regression | 8,703.15 | 13,291.44 | 0.8516 |
| Random Forest (tuned) | 3,177.75 | 6,544.45 | 0.9640 |
| **XGBoost (tuned)** | **3,156.94** | **5,889.91** | **0.9709** |

**Top predictive features:** Processor, Brand, Rating, Display Type

The final tuned **XGBoost Regressor** was selected for deployment, explaining ~97% of price variation.

---

## 📊 Power BI Dashboard

An interactive dashboard with 7 KPI cards and 6 charts, enabling users to explore:
- Brand-wise smartphone count and pricing
- Storage, RAM, and battery distribution
- Cross-filtering and interactive tooltips across all visuals

📁 File: [`SmartSpec_Dashboard.pbix`](./dashboard)

---

## 🌐 Streamlit Web Application

A live web app that lets users input smartphone specifications (Brand, Processor, RAM, Storage, Battery, Discount, Display) and instantly receive a predicted price using the trained XGBoost model.

**Run locally:**
```bash
git clone https://github.com/Karankukadiya/SmartSpec-Analytics.git
cd smartspec-analytics
pip install -r requirements.txt
streamlit run app.py
```

**Model performance in-app:**
- R² Score: 97.09%
- MAE: ₹2,946
- RMSE: ₹5,580

---

## 💡 Key Insights

- The market is dominated by budget and mid-range devices (₹10,000–₹30,000)
- Processor and Brand influence price more than RAM or Battery
- 8 GB RAM / 128 GB storage / 5000 mAh battery is the current industry standard configuration
- Premium smartphones receive statistically significant higher customer ratings
- XGBoost can predict smartphone prices with ~97% accuracy using specifications alone

---

## 🚀 Future Enhancements

- Automated daily scraping for real-time market tracking
- Time-series price forecasting
- Personalized smartphone recommendation engine
- NLP-based customer review sentiment analysis
- Multi-platform data integration (Amazon, Croma, Reliance Digital)
- Cloud deployment for scalable, real-time analytics

---

## 👤 Author

**Karan Kukadiya**

If you found this project useful, consider giving it a ⭐ on GitHub!

---

## 📄 License

This project is for educational and portfolio purposes. Data was collected via web scraping for non-commercial analytical use.
