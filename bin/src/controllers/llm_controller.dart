import '../interfaces/quantum_llm.dart';
import '../services/network_service.dart';

class LLMController with NetworkService implements QuantumLLM {
  LLMController._();
  static final LLMController _shared = LLMController._();

  factory LLMController() => _shared;

  Future<void> _requestLLM() async {}

  @override
  Future<dynamic> predict(String query, {List<String>? context}) async {
    final input =
        "<s>[INST] What is your favourite condiment? [/INST] Well, I'm quite partial to a good squeeze of fresh lemon juice. It adds just the right amount of zesty flavour to whatever I'm cooking up in the kitchen!</s>[INST] Do you have mayonnaise recipes? [/INST]";
  }
}
