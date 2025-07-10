from flask import Flask, request, jsonify
import joblib
import numpy as np
import firebase_admin
from firebase_admin import credentials, firestore
import os
import pywt

app = Flask(__name__)

# Firebase Initialization
FIREBASE_CREDENTIALS = "C:/Users/Marian/Downloads/gp-account-firebase-adminsdk-40c0j-e187a202fc.json"
cred = credentials.Certificate(FIREBASE_CREDENTIALS)
firebase_admin.initialize_app(cred)

# Firestore Initialization
db = firestore.client()
#"C:\Users\ayawa\Downloads\EMG_Model_Random_Forest.joblib"
#"C:/Users/ayawa/Downloads/EMG_Model_Gradient_Boosting.joblib"
# Paths to models and datasets
MODELS = {
    "Gradient_Boosting":"C:/Users/Marian/Downloads/EMG_Model_Gradient_Boosting.joblib",
}
NORMAL_SIGNALS_PATH = "C:/Users/Marian/Downloads/N_TXT-20250124T230152Z-001/N_TXT"
ABNORMAL_SIGNALS_PATH = "C:/Users/Marian/Downloads/A_TXT-20250124T230154Z-001/A_TXT"

# Load models
loaded_models = {}
for model_name, model_path in MODELS.items():
    try:
        loaded_models[model_name] = joblib.load(model_path)
        print(f"Model '{model_name}' loaded successfully.")
    except FileNotFoundError:
        raise Exception(f"Model '{model_name}' not found at {model_path}")

# Function to load signals from a folder
def load_signals_from_folder(folder_path):
    """Load all signal files (.txt) from the specified folder."""
    signals = []
    for filename in os.listdir(folder_path):
        if filename.endswith(".txt"):
            file_path = os.path.join(folder_path, filename)
            try:
                signals.append(np.loadtxt(file_path))
            except Exception as e:
                print(f"Error loading file {filename}: {e}")
    return signals

# Load datasets
normal_signals = load_signals_from_folder(NORMAL_SIGNALS_PATH)
abnormal_signals = load_signals_from_folder(ABNORMAL_SIGNALS_PATH)
print(f"Loaded {len(normal_signals)} normal signals and {len(abnormal_signals)} abnormal signals.")

# Wavelet denoising function
def wavelet_denoise(signal, wavelet="db9", level=1):
    """Denoise a signal using wavelet transform."""
    coeffs = pywt.wavedec(signal, wavelet, level=level)
    threshold = np.sqrt(2 * np.log(len(signal)))
    denoised_coeffs = [pywt.threshold(c, threshold, mode='soft') if i > 0 else c for i, c in enumerate(coeffs)]
    return pywt.waverec(denoised_coeffs, wavelet)

# Unified endpoint for predictions and data retrieval
@app.route('/predictions', methods=['GET', 'POST'])
def predictions():
    try:
        if request.method == 'POST':
            # Parse input data
            input_data = request.json.get("data")
            model_name = request.json.get("model", "extra_trees")  # Default model
            if not input_data or not isinstance(input_data, list):
                return jsonify({"error": "Input data must be a list of numerical values"}), 400
            if model_name not in loaded_models:
                return jsonify({"error": f"Model '{model_name}' not found"}), 400

            # Convert input data to numpy array
            input_array = np.array(input_data).reshape(1, -1)

            # Model prediction
            model = loaded_models[model_name]
            prediction = model.predict(input_array)[0]
            probability = model.predict_proba(input_array)[0].tolist()

            # Map prediction to label
            prediction_label = "Normal" if prediction == 0 else "Abnormal"

            # Generate a unique patient ID
            patient_id = f"patient_id_{np.random.randint(1000, 9999)}"

            # Save prediction to Firestore
            prediction_data = {
                "input": [float(x) for x in input_data],  # Convert to Python floats
                "model": model_name,
                "prediction": int(prediction),           # Convert to Python int
                "prediction_label": prediction_label,
                "probability": [float(x) for x in probability]  # Convert to Python floats
            }
            db.collection("predictions").document(patient_id).set(prediction_data)

            return jsonify({
                "id": patient_id,
                "model": model_name,
                "input": input_data,
                "prediction": f"{prediction} = {prediction_label}",
                "probability": probability,
                "message": "Prediction saved to Firestore"
            }), 201

        elif request.method == 'GET':
            # Retrieve predictions from Firestore
            docs = db.collection("predictions").stream()
            predictions = [{"id": doc.id, **doc.to_dict()} for doc in docs]
            return jsonify(predictions), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Entry point
if __name__ == '__main__':
    app.run(debug=True)
