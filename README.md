# Bank CRM Analysis: Customer Retention & Risk Analysis
A Data-Driven Story using SQL Analytics & Business Intelligence

# 📌 Project Overview

This project addresses the challenge of customer churn within a banking environment. By analyzing a dataset of 10,000 customers, the study identifies high-risk segments, evaluates product engagement, and provides actionable, data-driven strategies to improve customer retention and protect capital.

### 📂 Project Database
You can view the full Bank CRM Database here:

[Access Bank CRM Database (Excel)](https://drive.google.com/drive/folders/1oykFSe4CWfLZCrLzlKm5kiIZTEJkxHUR)

# 🎯 Business ObjectivesUnderstand 

- **Churn Patterns:** Analyze customer demographics and transaction behavior to identify why customers leave.
- **Segment Risk:** Identify high-risk regions and customer profiles (e.g., high-balance, mid-age customers).
- **Evaluate Product Effectiveness:** Measure how product engagement, such as credit card ownership and multi-product usage, impacts loyalty.
- **Strategic Recommendations:** Provide the marketing and risk-management teams with actionable triggers to reduce attrition.

# 🛠️ Tech Stack

- **SQL:** Used for deep-dive data extraction, complex joins, and statistical analysis (correlation, ranking, and segmentation).
- **Power BI:** Utilized for building a star-schema analytical model and creating interactive dashboards.
- **Statistical Analysis:** Conducted outlier detection and correlation analysis between variables like salary, credit score, and balance.

# 📊 Data Model & Schema

- **Schema:** The project uses a Star-Schema analytical model designed for scalability and consistent CRM analysis.
- **Fact Table:** Bank_Churn (Contains financial and behavioral metrics).
- **Dimension Tables:** Customer_Info, Geography, Gender, Credit Card Status, Active Status, and Exit Status.

# 🔍 Key Insights

🌍 Geographic & Demographic Risk

- **Germany:** Represents a high-value but high-risk segment with the highest average balances (~$119.7K) and elevated churn rates.
- **France:** The largest market by volume (5,014 customers) with the strongest long-term retention.
- **Gender:** Female customers exhibit a significantly higher churn rate (~25%) compared to males (~15%), suggesting a need for targeted engagement.

💳 Product Engagement

- **Single-Product Risk:** 69% of churned customers used only one product. Churn drops sharply when customers utilize two or more products.
- **Credit Card Impact:** Having a credit card alone does not significantly influence churn behavior (20.18% for holders vs 20.81% for non-holders).

📈 Behavioral Trends

- **Engagement over Income:** Churn is primarily driven by activity and engagement rather than salary or credit score. Estimated salary and credit score showed - almost no correlation with churn propensity.
- **Retention Window:** The period between Years 2–4 is identified as a critical loyalty window for long-term value.

# 💡 Strategic Recommendations

- **Retention Triggers:** Introduce automated retention triggers at Year 4 of the customer tenure.
- **Aggressive Cross-Selling:** Focus on converting single-product users into multi-product customers to build a "sticky" relationship.
- **Regional Focus:** Launch specialized loyalty programs in Germany to protect high-value balances.
- **Premium Services:** Design premium service tiers specifically for high-balance, mid-aged customers who represent the highest capital loss risk.

