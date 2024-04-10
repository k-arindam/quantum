from flask import Flask, request
import torch

server = Flask(__name__)
model = torch.load('models/mistral-7B-v0.1/consolidated.00.pth')

def start_ai_server():
    server.run(port=8081, debug=True)

@server.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    return {'output': data}



if __name__ == '__main__':
    start_ai_server()