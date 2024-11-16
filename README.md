# weather-flight-analysis
Analysis of Weather Impact on Flight Delays and Cancellations

Executive Summary

The objective of this project is to analyze the impact of various weather variables on U.S. flight delays and cancellations, using the 2022 US Airlines Domestic Departure data set. This data set, sourced from Kaggle, contains detailed records of flight operations, weather conditions, and instances of delays and cancellations due to different factors including adverse weather. By understanding how specific weather conditions contribute to flight delays and cancellations, we aim to provide insights that could help airlines and airport authorities better anticipate disruptions, thereby improving operational efficiency.

To achieve these insights, this project focuses on major northern U.S. airports, where weather impacts on flights are typically more severe and varied due to seasonal factors, such as significant winter conditions. This comprehensive data set compiles US domestic flight takeoff information, airport details, aircraft specifications, and weather data, providing a rich basis for analyzing the role of weather in flight disruptions. The analysis employs two advanced machine learning models, **Random Forest and XGBoost**, to predict delays and cancellations. These models are chosen for their robustness in handling complex data with non-linear relationships and their ability to capture the interactions among multiple weather variables.

The analysis pipeline includes data cleaning, exploratory data analysis (EDA), and feature selection to prepare the data for model training and evaluation. Our data set was sourced from Kaggle under the title "2022 US Airlines Domestic Departure Data" (<https://www.kaggle.com/datasets/jl8771/2022-us-airlines-domestic-departure-data>). This project demonstrated that specific weather variables, have a significant impact on flight delays and flight cancellations. Random Forest and XGBoost models both successfully predicted flight delays and flight cancellations with respect to weather conditions.

1. Introduction

The 2022 US Airlines Domestic Departure data set offers a comprehensive view of U.S. flights, including a range of variables related to flight schedules, delays, cancellations, and detailed weather conditions at departure. This data set contains **6,921,847** observations. However, given the significant impact of regional weather variations, our analysis is focused on **top 20 northern U.S. airports** with **highest observations** out of total 375 airports throughout the U.S, which often experience more extreme weather, such as snowstorms, lower temperatures, and strong winds, leading to a higher likelihood of delays and cancellations.

The decision to filter and focus on the top 20 northern airports was based on the observed differences in weather patterns across regions. By concentrating on airports in regions with high data availability and consistent weather-driven impacts, we aim to provide actionable insights that could improve planning, resource allocation, increase the reliability and to provide more accurate insights into how adverse weather specifically affects flight operations in northern U.S. airports.

2. Methods & Analysis

The data preparation step involves checking if a pre-processed version of the original data set (**flight_weather_data.csv**) is already available. The pre-processed version has been created for this project only. This approach helps streamline the analysis process by saving a cleaned version of the data for future use. If not, the original raw data is then downloaded from Kaggle, cleaned, and processed. 

Data pre-processing involves cleaning and filtering of data set to ensure it meets analysis requirements. We first check for the number of records per airport to identify airports with sufficient data. Given the extensive data set covering multiple airports, focusing on a subset (specifically northern U.S. airports) helps reduce variability and improves the interpretability of our findings. This regional focus on top 20 northern airports by highest observation counts is motivated by the fact that these areas experience more severe weather disruptions. By limiting the analysis to this subset, it will help us to develop models that are more accurate for regions frequently impacted by adverse weather.

Exploratory Data Analysis (EDA)

The EDA focuses on visualizing patterns and relationships in flight cancellations due to weather, as well as the conditions under which delays are likely. This includes analyzing distributions of weather variables like wind speed, gusts, visibility, temperature, and humidity to understand their impact on cancellations. This initial analysis identifies weather factors that correlate with cancellations, helping us prioritize features for modeling. Insights such as high cancellations in low visibility or high wind speed or gust conditions help frame the subsequent modeling phase.

Model Selection

To model the impact of weather on flight delays and cancellations, we use two machine learning models:
1. **Random Forest**: A powerful, non-linear model that handles complex relationships and can rank the importance of different variables.
2. **XGBoost**: Known for its speed and performance, especially with large data sets. XGBoost can capture non-linear relationships and interactions between variables.

These models are suitable for our analysis as they can manage a large number of observations and handle complex, non-linear relationships inherent in weather data. Both models have also been selected to provide feature importance metrics, which will help us understand which weather factors most influence delays and cancellations.

Random Forest Model

The Random Forest algorithm is an ensemble learning method that builds multiple decision trees and merges them to get a more accurate and stable prediction. We trained separate Random Forest models for flight cancellations and flight delays. Explanation of parameters used in this model are as follows:
ntree = 100: We used 100 trees to balance between computational efficiency and model performance. More trees can improve performance but increase computation time.
importance = TRUE: Setting this parameter to TRUE allows us to extract variable importance measures, which are useful for interpreting the model.

XGBoost Model

XGBoost (Extreme Gradient Boosting) is a scalable and efficient implementation of gradient boosting machines. It is highly regarded for its speed and performance, especially on large data sets. We trained separate XGBoost models for flight cancellations and delays. Explanation of parameters used in this model are as follows:
objective = "binary:logistic": Specifies that we are performing binary classification.
eval_metric = "error": Uses classification error as the evaluation metric.
max_depth = 6: Limits the depth of each tree to prevent overfitting.
eta = 0.3: The learning rate, a lower value slows down learning but can improve performance.
gamma = 1: Controls the minimum loss reduction required to make a split; helps with regularization.
scale_pos_weight: Addresses class imbalance by weighting the positive class inversely proportional to its frequency.

3. Results

This section presents a comprehensive analysis of the results from both the Random Forest and XGBoost models used to predict flight delays and cancellations due to weather conditions. We evaluated these models on accuracy, sensitivity, specificity, and balanced accuracy, which helps in assessing each model’s strengths and weaknesses.

# 1. Random Forest Model Analysis on Flight Cancellations

**Accuracy: 99.28%**, which is exceptionally high, indicating the model is effective in overall prediction.
**Sensitivity: 99.82%**, an excellent ability to correctly identify non-cancelled flights.
**Specificity: 57.01%**, indicates the model still struggles moderately in accurately identifying actual cancellations.
**Balanced Accuracy: 78.42%**, reflects a strong overall performance in handling both cancellations and non-cancellations.
**Kappa statistic: 0.6637**, highlights stronger agreement between the model's predictions and actual outcomes
**Feature Importance:** The Random Forest model ranks **Relative Humidity, Lowest Cloud Layer, and Wind Speed and Visibility** as the top predictors for flight cancellations.
This finding aligns with the hypothesis that these weather variables are **influential** in cancellation decisions.

# 2. Random Forest Model Analysis on Flight Delays

**Accuracy: 68.89%**,  which is moderate, indicating that while the model can reasonably predict delays, there is room for improvement.
**Sensitivity: 87.76%**, showing the model’s high ability to correctly identify delayed flights.
**Specificity: 39.21%**, indicating a limitation in accurately predicting non-delayed flights. This low specificity suggests the model is biased toward predicting delays.
**Balanced Accuracy: 63.54%**, reflecting an overall moderate performance when considering both delayed and non-delayed classes.
**Kappa Statistic: 0.2929**, shows slight agreement beyond chance, highlighting room for improvement.
**Feature Importance:** The Random Forest model identifies **Relative Humidity, Lowest Cloud Layer, and Temperature** as the most significant predictors for flight delays. This aligns with the expected influence of these variables **contribute** to delays.

# 3. XGBoost Model Analysis on Flight Cancellations

**Accuracy: 89.89%**, slightly lower than Random Forest, but high accuracy overall.
**Sensitivity: 89.97%**, showing good performance in detecting non-cancellations.
**Specificity: 83.88%**, significantly higher than Random Forest in identifying actual cancellations, making it a more balanced model for cancellation prediction.
**Balanced Accuracy: 86.92%**, reflecting a strong ability to classify both cancellations and non-cancellations correctly.
**Feature Importance:** XGBoost highlights **Relative Humidity, Lowest Cloud Layer and Temperature** as crucial factors for cancellations, confirming the Random Forest results.

# 4. XGBoost Model Analysis on Flight Delays

**Accuracy: 59.92%**, which is moderate, indicating that the model’s overall ability to predict delays accurately is limited but acceptable, but is lower compared to the Random Forest model
**Sensitivity: 61.46%**, suggesting a fair capability to detect delayed flights, although not as high as the Random Forest model's sensitivity.
**Specificity: 57.51%**, indicating balanced ability to detect delayed flights, though still moderate in effectiveness. This specificity is notably higher than the Random Forest model, showing that XGBoost achieves a more balanced detection of both delayed and non-delayed flights.
**Balanced Accuracy: 59.49%**, reflecting an overall fair balance in distinguishing between delayed and non-delayed flights. It is slightly lower than Random Forest.
**Feature Importance:** XGBoost identifies **Lowest Cloud Layer, Temperature and Relative Humidity** as key contributors to flight delays, similar to the findings from the Random Forest model, and these variables play a significant role in causing flight delays.

4. Conclusion
This project demonstrates that specific weather variables, including **Relative Humidity, Temperature, visibility and Lowest Cloud Layer**, have a significant impact on flight delays and cancellations. Random Forest and XGBoost models successfully predicted both delays and cancellations, with each model displaying unique strengths.
**For Flight Cancellation Model:** The XGBoost model achieves a strong performance in predicting flight cancellations, with enhanced specificity over Random Forest, making it more balanced for real-world application.
**For Flight Delay Model:** The XGBoost model demonstrates comparable sensitivity and specificity, providing a more equitable detection of delays and non-delays compared to Random Forest.

These insights can be used by airlines and airport authorities to anticipate disruptions and manage flight schedules proactively. By identifying critical weather factors, stakeholders can make more informed decisions regarding flight operations during adverse weather.
