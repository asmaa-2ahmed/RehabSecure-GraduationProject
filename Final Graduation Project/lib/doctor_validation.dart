//import 'dart:convert';
//import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';


class DoctorValidation {
  final String rpcUrl = "https://sepolia.infura.io/v3/259997fba92249bc95cc476e07511684";
  final String contractAddress = "0x3c00568F69D17a0d8CFe526BFEed6b9494a3C2A8";
  final String abi = '''[{"inputs":[{"internalType":"string","name":"universityName","type":"string"}],"name":"isValidUniversity","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"}]''';

  Future<bool> validateUniversity(String universityName) async {
    final client = Web3Client(rpcUrl, Client());

    final contract = DeployedContract(
      ContractAbi.fromJson(abi, "DoctorValidation"),
      EthereumAddress.fromHex(contractAddress),
    );

    final function = contract.function("isValidUniversity");

    final result = await client.call(
      contract: contract,
      function: function,
      params: [universityName],
    );

    return result.first as bool;
  }
}