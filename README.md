Stress Level Monitoring App

Project Overview

The Stress Level Monitoring App is a Swift-based application that monitors an individual’s stress levels based on various health data, such as heart rate, heart rate variability (HRV), resting heart rate (RHR), and sleep hours. 

SwiftUI: Framework for building the user interface.
Core Data: Local storage for saving data, if needed.
REST API: Fetches predicted stress level from a remote server.
Timer: Periodically sends health data to the prediction model for real-time updates.

For purpose of testing, fake data was send it from SwiftUI code to the REST API, for inference of the model, the model was a random forest model trained with apple watch data, with 3 classes of classification, low, medium and high level of stress. 


