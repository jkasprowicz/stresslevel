Stress Level Monitoring App

Project Overview

The Stress Level Monitoring App is a Swift-based application that monitors an individual’s stress levels based on various health data, such as heart rate, heart rate variability (HRV), resting heart rate (RHR), and sleep hours. The app retrieves health data from the device, sends it to a prediction model, and displays the predicted stress level in real-time. The project uses HealthKit for health data collection, Core Data for local storage, and a remote machine learning model to predict stress levels.

Features:
Real-Time Stress Level Prediction: Based on various health parameters like heart rate, HRV, RHR, and sleep hours.
Dynamic Stress Feedback: Visual and textual feedback is provided to the user based on their current stress level, with corresponding colors and messages (low, moderate, high stress).
Health Data Collection: The app retrieves heart rate, HRV, RHR, and sleep data from the HealthKit API.
Periodic Data Update: Every 30 seconds, the app sends updated health data and predicts stress levels.
User-Friendly Interface: Clean and simple user interface to display the stress levels with clear feedback.
Technologies Used

SwiftUI: Framework for building the user interface.
HealthKit: API used to fetch health data from the user's device.
Core Data: Local storage for saving data, if needed.
REST API: Fetches predicted stress level from a remote server.
Timer: Periodically sends health data to the prediction model for real-time updates.
