# weather-flight-analysis
# Analysis of Weather Impact on Flight Delays and Cancellations

# Executive Summary

The objective of this project is to analyze the impact of various weather variables on U.S. flight delays and cancellations, using the 2022 US Airlines Domestic Departure data set. This data set, sourced from Kaggle, contains detailed records of flight operations, weather conditions, and instances of delays and cancellations due to different factors including adverse weather. By understanding how specific weather conditions contribute to flight delays and cancellations, we aim to provide insights that could help airlines and airport authorities better anticipate disruptions, thereby improving operational efficiency.

To achieve these insights, this project focuses on major northern U.S. airports, where weather impacts on flights are typically more severe and varied due to seasonal factors, such as significant winter conditions. This comprehensive data set compiles US domestic flight takeoff information, airport details, aircraft specifications, and weather data, providing a rich basis for analyzing the role of weather in flight disruptions. The analysis employs two advanced machine learning models, **Random Forest and XGBoost**, to predict delays and cancellations. These models are chosen for their robustness in handling complex data with non-linear relationships and their ability to capture the interactions among multiple weather variables.

The analysis pipeline includes data cleaning, exploratory data analysis (EDA), and feature selection to prepare the data for model training and evaluation. Our data set was sourced from Kaggle under the title "2022 US Airlines Domestic Departure Data" (<https://www.kaggle.com/datasets/jl8771/2022-us-airlines-domestic-departure-data>). This project demonstrated that specific weather variables, have a significant impact on flight delays and flight cancellations. Random Forest and XGBoost models both successfully predicted flight delays and flight cancellations with respect to weather conditions.

# 1. Introduction

The 2022 US Airlines Domestic Departure data set offers a comprehensive view of U.S. flights, including a range of variables related to flight schedules, delays, cancellations, and detailed weather conditions at departure. This data set contains **6,921,847** observations. However, given the significant impact of regional weather variations, our analysis is focused on **top 20 northern U.S. airports** with **highest observations** out of total 375 airports throughout the U.S, which often experience more extreme weather, such as snowstorms, lower temperatures, and strong winds, leading to a higher likelihood of delays and cancellations.

The decision to filter and focus on the top 20 northern airports was based on the observed differences in weather patterns across regions. By concentrating on airports in regions with high data availability and consistent weather-driven impacts, we aim to provide actionable insights that could improve planning, resource allocation, increase the reliability and to provide more accurate insights into how adverse weather specifically affects flight operations in northern U.S. airports.

# 2. Methods & Analysis

The data preparation step involves checking if a pre-processed version of the original data set (**flight_weather_data.csv**) is already available. The pre-processed version has been created for this project only. This approach helps streamline the analysis process by saving a cleaned version of the data for future use. If not, the original raw data is then downloaded from Kaggle, cleaned, and processed. 

Data pre-processing involves cleaning and filtering of data set to ensure it meets analysis requirements. We first check for the number of records per airport to identify airports with sufficient data. Given the extensive data set covering multiple airports, focusing on a subset (specifically northern U.S. airports) helps reduce variability and improves the interpretability of our findings. This regional focus on top 20 northern airports by highest observation counts is motivated by the fact that these areas experience more severe weather disruptions. By limiting the analysis to this subset, it will help us to develop models that are more accurate for regions frequently impacted by adverse weather.

The EDA focuses on visualizing patterns and relationships in flight cancellations due to weather, as well as the conditions under which delays are likely. This includes analyzing distributions of weather variables like wind speed, gusts, visibility, temperature, and humidity to understand their impact on cancellations. This initial analysis identifies weather factors that correlate with cancellations, helping us prioritize features for modeling. Insights such as high cancellations in low visibility or high wind speed or gust conditions help frame the subsequent modeling phase.

To model the impact of weather on flight delays and cancellations, we use two machine learning models:
1. **Random Forest**: A powerful, non-linear model that handles complex relationships and can rank the importance of different variables.
2. **XGBoost**: Known for its speed and performance, especially with large data sets. XGBoost can capture non-linear relationships and interactions between variables.

These models are suitable for our analysis as they can manage a large number of observations and handle complex, non-linear relationships inherent in weather data. Both models have also been selected to provide feature importance metrics, which will help us understand which weather factors most influence delays and cancellations.

# 3. Results

This section presents a comprehensive analysis of the results from both the Random Forest and XGBoost models used to predict flight delays and cancellations due to weather conditions. We evaluated these models on accuracy, sensitivity, specificity, and balanced accuracy, which helps in assessing each model’s strengths and weaknesses.

# 4. Conclusion
This project demonstrates that specific weather variables, including **Relative Humidity, Temperature, visibility and Lowest Cloud Layer**, have a significant impact on flight delays and cancellations. Random Forest and XGBoost models successfully predicted both delays and cancellations, with each model displaying unique strengths.
**For Flight Cancellation Model:** The XGBoost model achieves a strong performance in predicting flight cancellations, with enhanced specificity over Random Forest, making it more balanced for real-world application.
**For Flight Delay Model:** The XGBoost model demonstrates comparable sensitivity and specificity, providing a more equitable detection of delays and non-delays compared to Random Forest.

These insights can be used by airlines and airport authorities to anticipate disruptions and manage flight schedules proactively. By identifying critical weather factors, stakeholders can make more informed decisions regarding flight operations during adverse weather.
