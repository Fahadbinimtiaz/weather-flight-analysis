# Install required packages (if not already installed)
if (!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if (!require(ggcorrplot)) install.packages("ggcorrplot", repos = "http://cran.us.r-project.org")
if (!require(caret)) install.packages("caret", repos = "http://cran.us.r-project.org")
if (!require(xgboost)) install.packages("xgboost", repos = "http://cran.us.r-project.org")
if (!require(randomForest)) install.packages("randomForest", repos = "http://cran.us.r-project.org")

library(tidyverse)       # For data manipulation and visualization
library(ggcorrplot)      # For correlation plot visualization
library(caret)           # For test and training of Models
library(xgboost)         # For XGBOOST advanced ML Model
library(randomForest)    # For RF advanced ML Model

# It will load and perform actions on the original data set if cleaned data set is not available
# Check if the merged and cleaned data set file already exists
if (file.exists("flight_weather_data.csv")) {
  # Load the existing prepared data set
  flight_weather_data <- read.csv("flight_weather_data.csv")
  } else {
    # Download and unzip the data if the pre processed file does not exist
    dl <- "archive.zip"         # Create a temporary zip file
    options(timeout = 3600)     # Timeout setting in case of slow download 
    if(!file.exists(dl))        
      download.file("https://www.kaggle.com/api/v1/datasets/download/jl8771/2022-us-airlines-domestic-departure-data", dl, mode = "wb")
    unzip("archive.zip")
  
    # Load data
    flight_weather_data <- read.csv("CompleteData.csv")
  
    # Data cleaning
    flight_weather_data <- flight_weather_data %>% 
      na.omit() %>% 
      select(-c(FL_DATE, DEP_HOUR, MKT_UNIQUE_CARRIER, MKT_CARRIER_FL_NUM,
                OP_UNIQUE_CARRIER, OP_CARRIER_FL_NUM, TAIL_NUM, DEST, DEP_TIME,
                CRS_DEP_TIME, TAXI_OUT, AIR_TIME, DISTANCE, LATITUDE, LONGITUDE,
                ELEVATION, MESONET_STATION, YEAR.OF.MANUFACTURE, MANUFACTURER,
                ICAO.TYPE, RANGE, WIDTH, WIND_DIR, ALTIMETER, N_CLOUD_LAYER, 
                LOW_LEVEL_CLOUD, MID_LEVEL_CLOUD, HIGH_LEVEL_CLOUD, CLOUD_COVER))
  
    # Create delay and cancel flags
    # Create a delay flag: 1 for delayed flights, 0 for on-time
    # Create a cancel flag: 1 for cancelled, 0 for on-time
    flight_weather_data <- flight_weather_data %>%
      mutate(delay_flag = ifelse(DEP_DELAY > 0, 1, 0), cancel_flag = ifelse(CANCELLED == 2, 1, 0))
  
    # Save the processed data to CSV for future use
    write.csv(flight_weather_data, "flight_weather_data.csv", row.names = FALSE)
    }

# Count the number of records per airport
airport_counts <- flight_weather_data %>%
  group_by(ORIGIN) %>%
  summarize(count = n()) %>%
  arrange(desc(count))

# View the top 50 airports with the most data
print(airport_counts %>% head(50))

# Define selected high-data airports within the Southeast/Southwest region
selected_airports <- c("ORD", "DEN", "LGA", "EWR", "JFK", "BOS", "DTW", "MSP",
                       "SLC", "PHL", "BWI", "MDW", "IAD", "STL", "PDX", "IND",
                       "PIT", "CMH", "CLE", "CVG")

# Filter the data to include only these airports
regional_data <- flight_weather_data %>%
  filter(ORIGIN %in% selected_airports)

# Verify the filtered data set
print(regional_data %>% group_by(ORIGIN) %>% summarize(count = n()))

rm(airport_counts, selected_airports)  #To clean up


# Check structure of the cleaned dataset
str(regional_data)

# View a summary of the dataset
summary(regional_data[c("DEP_DELAY", "WIND_SPD", "WIND_GUST","VISIBILITY","TEMPERATURE","DEW_POINT","REL_HUMIDITY")])
# Select weather cancellations flights only
weather_cancellations <- regional_data %>%
     filter(cancel_flag == 1) %>% filter(ACTIVE_WEATHER == 1 | ACTIVE_WEATHER == 2)

# Effect of Wind Speed on Weather Cancellations
weather_cancellations %>% filter (WIND_SPD > 0) %>% 
  ggplot(aes(x = WIND_SPD)) +
  geom_histogram(binwidth = 0.5, fill = "blue", alpha = 0.7) +
  labs(title = "Effect of Wind Speed on Weather Cancellations", 
       x = "Wind Speed (Knots)", y = "Count") +
  theme_minimal()

# Effect of Wind gust on Weather Cancellations
weather_cancellations %>% filter (WIND_GUST > 0) %>% 
  ggplot(aes(x = WIND_GUST)) +
  geom_histogram(binwidth = 0.5, fill = "blue", alpha = 0.7) +
  labs(title = "Effect of Wind gust on Weather Cancellations", 
       x = "Wind Gust (Knots)", y = "Count") +
  theme_minimal()

# Effects of Visibility on Weather Cancellations
ggplot(weather_cancellations, aes(x = VISIBILITY)) +
  geom_histogram(binwidth = 0.5, fill = "blue", alpha = 0.7) +
  labs(title = "Effects of Visibility on Weather Cancellations", 
     x = "Visibility (miles)", y = "Count") +
  theme_minimal()

# Effects of Temperature on Weather Cancellations
ggplot(weather_cancellations, aes(x = TEMPERATURE)) +
  geom_histogram(binwidth = 1, fill = "blue", alpha = 0.7) +
  labs(title = "Effects of Temperature on Weather Cancellations", 
       x = "Temperature (C)", y = "Count") +
  theme_minimal()

# Effects of Dew Point Temperature on Weather Cancellations
ggplot(weather_cancellations, aes(x = DEW_POINT)) +
  geom_histogram(binwidth = 1, fill = "blue", alpha = 0.7) +
  labs(title = "Effects of Dew Point Temperature on Weather Cancellations", 
       x = "Dew Point Temperature (C)", y = "Count") +
  theme_minimal()

# Effects of Humidity on Weather Cancellations
ggplot(weather_cancellations, aes(x = REL_HUMIDITY)) +
  geom_histogram(binwidth = 1, fill = "blue", alpha = 0.7) +
  labs(title = "Effects of Humidity on Weather Cancellations", 
       x = "Humidity (Percentage %)", y = "Count") +
  theme_minimal()

# Group cancellations by lowest cloud layer
cancellations_by_cloud <- weather_cancellations %>%
  group_by(LOWEST_CLOUD_LAYER) %>%
  summarize(count = n(), .groups = 'drop')

# Plot: Cancellations by Cloud Layer Height
ggplot(cancellations_by_cloud, aes(x = LOWEST_CLOUD_LAYER, y = count)) +
  geom_bar(stat = "identity", fill = "blue", alpha = 0.7) +
  labs(title = "Weather Cancellations by Lowest Cloud Layer Height", 
       x = "Lowest Cloud Layer (Feet)", y = "Number of Cancellations") +
  theme_minimal()

# Summary of active weather events contributing to cancellations
weather_event_cancellations <- weather_cancellations %>%
  group_by(ACTIVE_WEATHER) %>%
  summarize(count = n(), .groups = 'drop')

# Bar plot: Cancellations by Active Weather Event
ggplot(weather_event_cancellations, aes(x = factor(ACTIVE_WEATHER), y = count, fill = factor(ACTIVE_WEATHER))) +
  geom_bar(stat = "identity", alpha = 0.7) +
  scale_x_discrete(labels = c("Weather Present", "Significant Events")) +
  labs(title = "Weather Cancellations by Active Weather Event", 
       x = "Active Weather Event", y = "Number of Cancellations") +
  theme_minimal()

# Select weather variables and cancellation status
weather_vars_cancellation <- regional_data %>%
  filter(CANCELLED == 2) %>%  # Only consider cancellations due to weather
  select(WIND_SPD, WIND_GUST, VISIBILITY, TEMPERATURE, DEW_POINT, REL_HUMIDITY, LOWEST_CLOUD_LAYER)

# Compute correlation matrix for cancellations
  cor_matrix_cancellation <- cor(weather_vars_cancellation, use = "complete.obs")

# Plot correlation matrix for cancellations
  ggcorrplot(cor_matrix_cancellation, lab = TRUE, 
  title = "Correlation Between Weather Variables and Cancellations")


# Select delayed flights only
delayed_flights <- regional_data %>%
  filter(DEP_DELAY > 0 & DEP_DELAY < 2000)

# Select relevant weather variables
weather_vars <- delayed_flights %>%
  select(WIND_SPD, WIND_GUST, VISIBILITY, TEMPERATURE, DEW_POINT, REL_HUMIDITY, LOWEST_CLOUD_LAYER)

# Compute correlation matrix
cor_matrix <- cor(weather_vars, use = "complete.obs")

# Plot the correlation matrix
ggcorrplot(cor_matrix, lab = TRUE, title = "Correlation Between Weather Variables")

# Analyze average delays based on active weather events
delays_by_weather <- delayed_flights %>%
  group_by(ACTIVE_WEATHER) %>%
  summarize(avg_delay = mean(DEP_DELAY), .groups = 'drop')
print(delays_by_weather)

# Plot: Average Delay by Active Weather Event
ggplot(delays_by_weather, aes(x = factor(ACTIVE_WEATHER), y = avg_delay, fill = factor(ACTIVE_WEATHER))) +
  geom_bar(stat = "identity") +
  scale_x_discrete(labels = c("No Events", "Weather Present", "Significant Events")) +
  labs(title = "Average Delay by Weather Condition", 
       x = "Active Weather Condition", y = "Average Delay (Minutes)") +
  theme_minimal()

# Filter for delayed flights where weather effects are present (Active Weather 1 and 2)
weather_delays <- delayed_flights %>%
  filter(ACTIVE_WEATHER %in% c(1, 2))

weather_vars_plot <- weather_delays %>%
  select(DEP_DELAY, WIND_SPD, WIND_GUST, VISIBILITY, TEMPERATURE, DEW_POINT, REL_HUMIDITY, LOWEST_CLOUD_LAYER) %>%
  pivot_longer(cols = -DEP_DELAY, names_to = "Variable", values_to = "Value")

# Boxplot for delay distributions by Active Weather level
ggplot(weather_delays, aes(x = factor(ACTIVE_WEATHER), y = DEP_DELAY, fill = factor(ACTIVE_WEATHER))) +
   geom_boxplot() +
   scale_fill_manual(values = c("skyblue", "salmon")) +
   labs(title = "Distribution of Departure Delays by Weather Severity",
        x = "Weather Severity (1: Present, 2: Significant)", y = "Departure Delay (minutes)") +
   theme_minimal()

# Distribution of delays by cloud layer height
ggplot(weather_delays, aes(x = LOWEST_CLOUD_LAYER, y = DEP_DELAY)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Impact of Lowest Cloud Layer Height on Departure Delays",
       x = "Lowest Cloud Layer Height (feet)", y = "Departure Delay (minutes)") +
  theme_minimal()

# Plot delay against each weather variable
# This plot takes few minutes to compute
ggplot(weather_vars_plot, aes(x = Value, y = DEP_DELAY)) +
  geom_point(alpha = 0.3) +
  facet_wrap(~ Variable, scales = "free") +
  labs(title = "Impact of Weather Variables on Departure Delays",
       x = "Weather Variable Value", y = "Departure Delay (minutes)") +
  theme_minimal()
# Select relevant weather variables and the delay flag as the target variable
features <- c("WIND_SPD", "WIND_GUST", "VISIBILITY", "TEMPERATURE", "DEW_POINT", 
              "REL_HUMIDITY", "LOWEST_CLOUD_LAYER")
model_data <- regional_data %>% 
  select(all_of(features), delay_flag, cancel_flag)

# Split the data into training and testing sets
set.seed(123)  # For reproducibility
train_index <- createDataPartition(model_data$delay_flag, p = 0.8, list = FALSE)
train_data <- model_data[train_index, ]
test_data <- model_data[-train_index, ]

# This process may take couple of minutes and lots of memory
# Please ensure to have at least 24GB memory available before running this chunk
# Train the Random Forest model on the cancellation flag
set.seed(123)
rf_model_cancel <- randomForest(as.factor(cancel_flag) ~ ., 
                         data = train_data[, c(features, "cancel_flag")], 
                         ntree = 100, 
                         importance = TRUE)

# Train the Random Forest model on delay flag
rf_model_delay <- randomForest(as.factor(delay_flag) ~ ., 
                         data = train_data[, c(features, "delay_flag")], 
                         ntree = 100, 
                         importance = TRUE)

# Prepare data for XGBoost for cancel flag
dtrain_cancel <- xgb.DMatrix(data = as.matrix(train_data[, features]), label = train_data$cancel_flag)
dtest_cancel <- xgb.DMatrix(data = as.matrix(test_data[, features]), label = test_data$cancel_flag)

# Set parameters for binary classification
params_cancel <- list(
  objective = "binary:logistic",  # Binary classification
  eval_metric = "error",          # Evaluation metric: classification error
  max_depth = 6,                  # Maximum depth of a tree
  eta = 0.3,                      # Learning rate
  gamma = 1,                      # Minimum loss reduction required to make a further partition
  scale_pos_weight = sum(train_data$cancel_flag == 0) / sum(train_data$cancel_flag == 1)  # Handle class imbalance
)

# Train the XGBoost model for cancel flag
xgb_model_cancel <- xgboost(params = params_cancel, data = dtrain_cancel, nrounds = 100, verbose = 1)

# Prepare data for XGBoost for delay flag
dtrain_delay <- xgb.DMatrix(data = as.matrix(train_data[, features]), label = train_data$delay_flag)
dtest_delay <- xgb.DMatrix(data = as.matrix(test_data[, features]), label = test_data$delay_flag)

# Set parameters for binary classification
params_delay <- list(
  objective = "binary:logistic",
  eval_metric = "error",
  max_depth = 6,
  eta = 0.3,
  gamma = 1,
  scale_pos_weight = sum(train_data$delay_flag == 0) / sum(train_data$delay_flag == 1)
)

# Train the XGBoost model for delay flag
xgb_model_delay <- xgboost(params = params_delay, data = dtrain_delay, nrounds = 100, verbose = 1)

# Random Forest Model
# Predict on the test set for flight cancellations
rf_preds_cancel <- predict(rf_model_cancel, test_data, type = "class")

# Evaluate the model for flight cancellations
rf_confusion_cancel <- confusionMatrix(rf_preds_cancel, as.factor(test_data$cancel_flag))

# Predict on the test set for flight delays
rf_preds_delay <- predict(rf_model_delay, test_data, type = "class")

# Evaluate the model
rf_confusion_delay <- confusionMatrix(rf_preds_delay, as.factor(test_data$delay_flag))

# XGBoost Model
# Predict on the test set for cancellations
xgb_preds_cancel <- predict(xgb_model_cancel, dtest_cancel)
xgb_preds_class_cancel <- ifelse(xgb_preds_cancel > 0.5, 1, 0)

# Evaluate the XGBoost model for flight cancellations
xgb_confusion_cancel <- confusionMatrix(as.factor(xgb_preds_class_cancel), as.factor(test_data$cancel_flag))

# Predict on the test set for flight delays
xgb_preds_delay <- predict(xgb_model_delay, dtest_delay)
xgb_preds_class_delay <- ifelse(xgb_preds_delay > 0.5, 1, 0)

# Evaluate the model
xgb_confusion_delay <- confusionMatrix(as.factor(xgb_preds_class_delay), as.factor(test_data$delay_flag))

# Results of Model
print(rf_confusion_cancel)
print(rf_confusion_delay)
print(xgb_confusion_cancel)
print(xgb_confusion_delay)

# Feature importance for Random Forest
importance(rf_model_cancel)
varImpPlot(rf_model_cancel)
importance(rf_model_delay)
varImpPlot(rf_model_delay)

# Feature importance for XGBoost
xgb_importance_cancel <- xgb.importance(model = xgb_model_cancel)
xgb.plot.importance(xgb_importance_cancel)

xgb_importance_delay <- xgb.importance(model = xgb_model_delay)
xgb.plot.importance(xgb_importance_delay)