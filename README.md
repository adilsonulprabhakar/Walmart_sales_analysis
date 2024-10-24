
# Walmart Sales Data Analysis -- SQL Project

### About

This project focuses on analyzing Walmart’s sales data to extract key insights about product performance, customer behavior, and branch efficiency. The data is analyzed to help inform strategic decisions regarding sales optimization and resource management.

### Purposes of the Project

The main goal is to understand the factors influencing sales across different branches of Walmart and improve overall sales strategies based on customer behavior and product analysis.

### About the Data

The dataset used in this project contains sales transactions from Walmart branches located in Mandalay, Yangon, and Naypyitaw. It consists of 17 columns and 1000 rows, capturing various details such as sales, customer information, and product line performance.

#### Columns
- **Invoice_ID**: Unique invoice identifier
- **Branch**: Branch where the sale occurred
- **City**: City of the branch
- **Customer_type**: Type of customer (e.g., Member or Normal)
- **Gender**: Gender of the customer
- **Product_line**: Product category being sold
- **Unit_price**: Price per unit of the product
- **Quantity**: Number of units sold
- **VAT**: Value Added Tax on the purchase
- **Total**: Total cost of the purchase
- **Date**: Transaction date
- **Time**: Transaction time
- **Payment**: Payment amount
- **COGS**: Cost Of Goods Sold
- **Gross_margin_pct**: Gross margin percentage
- **Gross_income**: Gross income from the transaction
- **Rating**: Customer rating for the transaction

### Approach Used

#### 1. Data Wrangling
- Reformatted the `Date` and `Time` columns to ensure proper data types.
- Checked for any missing values across all columns, confirming that there are no missing entries.

#### 2. Feature Engineering
To enhance the dataset and enable more detailed analysis, the following additional columns were created:
- **Time_of_Day**: Categorizes transactions into Morning, Afternoon, and Evening.
- **Day_Name**: Extracted the day of the week from the transaction date.
- **Month_Name**: Extracted the month from the transaction date.

### Business Questions to Answer

The analysis in this project focuses on answering key questions related to product performance, sales trends, and customer behavior.

#### Generic Questions:
1. How many distinct cities are present in the dataset?
2. In which city is each branch situated?

#### Product Analysis:
1. How many distinct product lines are there in the dataset?
2. What is the most common payment method?
3. What is the most selling product line?
4. What is the total revenue by month?
5. Which month recorded the highest Cost of Goods Sold (COGS)?
6. Which product line generated the highest revenue?
7. Which city has the highest revenue?
8. Which product line incurred the highest VAT?
9. Retrieve each product line and add a column **product_category** indicating 'Good' or 'Bad' based on whether its sales are above the average.
10. Which branch sold more products than the average product sold?
11. What is the most common product line by gender?
12. What is the average rating of each product line?

#### Sales Analysis:
1. Number of sales made in each time of the day per weekday.
2. Identify the customer type that generates the highest revenue.
3. Which city has the largest tax percent/VAT (Value Added Tax)?
4. Which customer type pays the most VAT?

#### Customer Analysis:
1. How many unique customer types does the data have?
2. How many unique payment methods does the data have?
3. Which is the most common customer type?
4. Which customer type buys the most?
5. What is the gender of most of the customers?
6. What is the gender distribution per branch?
7. Which time of the day do customers give most ratings?
8. Which time of the day do customers give most ratings per branch?
9. Which day of the week has the best average ratings?
10. Which day of the week has the best average ratings per branch?

---

### Conclusion

The analysis reveals valuable insights into customer behavior, branch performance, and product line sales. By understanding sales patterns and customer preferences, Walmart can optimize its strategies to improve profitability and customer satisfaction.

---
