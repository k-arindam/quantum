from flask import Flask, request
from ctransformers import AutoModelForCausalLM

server = Flask(__name__)

model = AutoModelForCausalLM.from_pretrained("models/mistral-7b-instruct-v0.1.Q5_K_M/mistral-7b-instruct-v0.1.Q5_K_M.gguf", model_type="mistral", gpu_layers=50)

def start_ai_server():
    server.run(port=8081, debug=True)

@server.route('/predict', methods=['POST'])
def predict():
    input_data = request.get_json()
    return {
        "prediction": model(input_data['input'])
    }


if __name__ == '__main__':
    start_ai_server()