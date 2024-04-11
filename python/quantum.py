from flask import Flask, request
from transformers import AutoModelForCausalLM, AutoTokenizer

server = Flask(__name__)

model = AutoModelForCausalLM.from_pretrained("models/Mistral-7B-Instruct-v0.2", device_map="auto")
tokenizer = AutoTokenizer.from_pretrained("models/Mistral-7B-Instruct-v0.2")

messages = [
    {"role": "user", "content": "What is your favourite condiment?"},
    {"role": "assistant", "content": "Well, I'm quite partial to a good squeeze of fresh lemon juice. It adds just the right amount of zesty flavour to whatever I'm cooking up in the kitchen!"},
    {"role": "user", "content": "Do you have mayonnaise recipes?"}
]

def start_ai_server():
    server.run(port=8081, debug=True)

# @server.route('/predict', methods=['POST'])
def predict():
    model_inputs = tokenizer.apply_chat_template(messages, return_tensors="pt").to('mps')
    # model.to(device)

    generated_ids = model.generate(model_inputs, max_new_tokens=100, do_sample=True)
    print("Model Response ----->>> ", tokenizer.batch_decode(generated_ids)[0])



if __name__ == '__main__':
    # start_ai_server()
    predict()