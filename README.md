# MisMaOstisn

MisMaOstisn is a web application that helps users make more prudent consumption choices by visualizing data extracted from grocery receipts. The app provides insights into spending habits and helps users analyze their purchases for better decision-making.

## Features
- **Receipt Data Extraction:** Extracts relevant information from grocery receipts using AWS Textract.
- **Data Visualization:** Displays insights on spending patterns through an intuitive front-end.
- **User Authentication:** Secure login via AWS Cognito integrated with ReactJS using AWS Amplify.
- **Prudent Consumption Insights:** Helps users make informed decisions by analyzing their grocery spending.

## Architecture

The system is designed with a serverless architecture and uses the following AWS services:

- **AWS Lambda:** Used to process the data extracted from receipts via AWS Textract.
- **Amazon Textract:** Extracts text and data from uploaded receipt images.
- **Amazon RDS (PostgreSQL):** Stores structured data (receipt details and consumption insights).
- **Amazon S3:** Stores uploaded receipt images.
- **Amazon EC2:** Runs DBT (Data Build Tool) to create views and transform the data stored in PostgreSQL.
- **AWS CloudFormation:** Automates the creation of the entire infrastructure (Lambda functions, RDS instance, S3 buckets, etc.).
- **ReactJS & AWS Amplify:** Front-end for displaying the data with user authentication via Cognito.

## Views Created by DBT /planned views/

To provide meaningful insights into consumption patterns, the following types of views are created in PostgreSQL via DBT, based on the `raw_shopping_details` table:

1. **Total Spending Per User View:**  
   This view aggregates total spending for each user:
   - Total amount spent
   - Number of purchases
   - Average spending per purchase
   - Insights into user-level spending behavior

2. **Category Spending Breakdown View:**  
   Groups purchases by name to break down spending per category:
   - Total amount spent per good
   - Frequency of purchase per item
   - Helps identify top items based on amount spent and purchase frequency

3. **Monthly Spending Trends View:**  
   Aggregates spending data on a monthly basis to identify trends:
   - Total spending per month
   - Month-over-month spending change
   - Insights into seasonal spending habits (e.g., more spending in certain months)

4. **Top Purchased Items View:**  
   Lists the most frequently purchased items across all users:
   - Top N items based on frequency
   - Insights into product demand and consumer preferences
   - Helps identify staple items in users' purchases

5. **Average Price per Product View:**  
   Calculates the average price of each product over time:
   - Price fluctuations per product
   - Identify products that have seen price increases or decreases
   - Helps users understand price trends across different purchases

6. **Total Quantity Purchased View:**  
   Sums up the total quantity of each good purchased:
   - Total units bought for each product
   - Helps track product popularity and bulk purchases
   - Allows for inventory management and purchasing trends

7. **Spending by Time of Day/Week Views:**  
   Groups purchases by the time of day/week they were made:
   - Total spending in different timeslots (e.g., morning, afternoon, evening, weekend, weekstart)
   - Identifies if there are time-based patterns in spending behavior (e.g., higher spending at certain times)

## Technologies Used

- **AWS Lambda**
- **AWS Textract**
- **Amazon RDS (PostgreSQL)**
- **Amazon S3**
- **Amazon EC2**
- **AWS CloudFormation**
- **ReactJS**
- **AWS Amplify**
- **DBT**
