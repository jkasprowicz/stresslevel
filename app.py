from flask import Flask, request, jsonify
import joblib
import numpy as np

app = Flask(__name__)
model = joblib.load("/Users/joaokasprowicz/documents/stress_level_model.joblib")

@app.route('/predict', methods=['POST'])
def predict():
    # Get input data from the request
    data = request.get_json()
    mean_hr = data.get('mean_hr')
    mean_hrv_sdnn = data.get('mean_hrv_sdnn')
    mean_rhr = data.get('mean_rhr')
    total_sleep_hours = data.get('total_sleep_hours')

    # Create feature vector for prediction
    features = [[mean_hr, mean_hrv_sdnn, mean_rhr, total_sleep_hours]]

    print(features)
    
    # Predict stress level (model output)
    prediction = model.predict(features)

    # Map numeric prediction to stress level category
    if prediction == 0:
        stress_level = "Nivel Baixo de Estresse"
    elif prediction == 1:
        stress_level = "Nivel Medio de Estresse"
    elif prediction == 2:
        stress_level = "Nivel Alto de Estresse"
    else:
        stress_level = "Não é possível predizer o nível de estresse!"  # In case the model returns an unexpected value

    # Return the result in JSON format
    return jsonify({"stress_level": stress_level})

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=5001)