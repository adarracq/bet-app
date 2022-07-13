// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  final String 
  _rpcUrl = 'http://127.0.0.1:7545',
  _wsUrl = 'ws://127.0.0.1:7545/',
  _privateKey ='e647f00279317247f0795ae1c582c7a8fde72c5779e2d917815d2d01787682f9';

  late Web3Client _client;
  late String _abiCode;

  late EthereumAddress _contractAddress;
  late Credentials _credentials;

  late DeployedContract _contract;
  late ContractFunction _getTotalBalance;
  late ContractFunction _getBalance;
  late ContractFunction _withdraw;
  late ContractFunction _bet;
  late ContractFunction _getReward;
  late ContractFunction _send;

  bool isLoading = true;
  late String contractOwner;
  late String myBalance;
  late String totalBalance;

  ContractLinking() {
    initialSetup();
  }

  initialSetup() async {
    // establish a connection to the ethereum rpc node. The socketConnector
    // property allows more efficient event streams over websocket instead of
    // http-polls. However, the socketConnector property is experimental.
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    },);

    await getAbi();
    await getCredentials();
    await getDeployedContract();
    await getBalance();
  }

  Future<void> getAbi() async {
    // Reading the contract abi
    final abiStringFile =
        await rootBundle.loadString('artifacts/MyAppName.json');
    final jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi['abi']);
    //print(_abiCode);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi['networks']['5777']['address']);
    //print(_contractAddress);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
    //print(_credentials);
  }

  Future<void> getDeployedContract() async {
    // Telling Web3dart where our contract is declared.
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, 'MyAppName'), _contractAddress,);
    // print(_contract.address);
    // Extracting the functions, declared in contract.
    _getTotalBalance = _contract.function('getTotalBalance');
    _getBalance = _contract.function('getBalance');
    _withdraw = _contract.function('withdraw');
    _bet = _contract.function('bet');
    _getReward = _contract.function('getReward');
    _send = _contract.function('send');

    //await getOwner();
  }


  Future<String> getTotalBalance() async {
    isLoading = true;
    final _balance = await _client
        .call(contract: _contract, function: _getTotalBalance, params: []);

    isLoading = false;
    notifyListeners();
    totalBalance = await _balance[0];
    return _balance[0].toString();
  }

  Future<String> getBalance() async {
    isLoading = true;
    
    final _balance = await _client
      .call(
        contract: _contract, 
        function: _getBalance, 
        params: [],
      );

    isLoading = false;
    notifyListeners();
    myBalance = _balance[0].toString();   
    return _balance[0].toString();
  }

  Future<void> withdraw(int amount) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _withdraw,
          parameters: [_credentials, amount],
        ),);
  }

  Future<void> bet(int amount) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _bet,
          parameters: [amount],
        ),);
  }

  Future<void> getReward(int amount) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _getReward,
          parameters: [amount],
        ),);
  }

  Future<void> send(int amount) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _send,
          parameters: [],
          // gasPrice: EtherAmount.inWei(BigInt.one),
          // maxGas: 100000,
          value: EtherAmount.fromUnitAndValue(EtherUnit.ether, amount),
        ),);
  }

}
