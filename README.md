# Bank Database Analysis

This repository outlines SQL-based solutions for comprehensive business challenges, particularly in the banking sector, focusing on customer relationship management, transaction monitoring, and risk assessment.

## Project Overview

The initiative began with the identification of key business areas where SQL can drive impactful insights. An Entity-Relationship [ER](https://github.com/Sanjukta2212/bankdb-analysis-and-mgmt/blob/main/ER.pdf) diagram was constructed to visualize the database schema tailored for these business needs. Adherence to Boyce-Codd Normal Form (BCNF) ensured data integrity by eliminating redundancy.

## [Data Curation](https://github.com/Sanjukta2212/bankdb-analysis-and-mgmt/blob/main/data_generation.ipynb)

A hybrid method was employed to curate the data:
- **Synthetic Data Generation**: Leveraged the Faker library to simulate realistic customer profiles.
- **Skewed Distribution Implementation**: Ensured dataframes like `df_transaction` and `df_card` reflect real-world financial behavior.
- **Authentic Statewise Data Integration**: Combined real-world demographic and financial indicators into `df_statewise` to enrich analysis.

## [Analytical Insights](https://github.com/Sanjukta2212/bankdb-analysis-and-mgmt/blob/main/queries_to%20solve_business_prob.sql)

The SQL queries developed facilitate a deep dive into:
- **Customer Relationship Management**: Analyzing the correlation between occupations and bank balances to customize services.
- **Transaction Management**: Monitoring transactions to flag anomalies and potential fraudulent activity.
- **Bank Performance**: Assessing branch efficiency and market penetration for strategic decision-making.
- **Strategic Planning and Analysis**: Utilizing demographic data for network expansion and service optimization.
- **Compliance Reporting**: Ensuring transactions adhere to regulatory standards.
- **Risk Assessment and Management**: Proactively managing loan terms for demographics at financial risk.

## SQL Implementation Learnings

- **Database-Specific Functions**: Adaptation to various SQL functions based on database platforms like PostgreSQL.
- **Syntax Compatibility**: Attention to query construction and syntax for seamless execution.
- **Project Execution**: A structured workflow was key to addressing the comprehensive business proposals.

## Contribution

Feel free to fork this repository and contribute towards enhancing the SQL queries and analytical frameworks. Your insights and improvements are welcome.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details.
