import 'package:flutter_networking/network_layer/json_parser.dart';
import 'package:flutter_networking/network_layer/model/network_error_type.dart';

class NetworkResponse<T> {
  final bool _isSuccess;
  final JsonParser _jsonParser;
  final T? _dataOnSuccess;
  final dynamic rawData;
  final NetworkErrorType? _errorType;
  final int? statusCode;

  NetworkResponse(
    this._isSuccess,
    this._jsonParser,
    this.statusCode, [
    this._dataOnSuccess,
    this.rawData,
    this._errorType,
  ]);

  factory NetworkResponse.success({
    required JsonParser jsonParser,
    required int? statusCode,
    required T? dataOnSuccess,
    required dynamic rawData,
  }) {
    return NetworkResponse<T>(true, jsonParser, statusCode, dataOnSuccess, rawData);
  }

  factory NetworkResponse.failure({
    required JsonParser jsonParser,
    required int? statusCode,
    required dynamic rawData,
    required NetworkErrorType errorType,
  }) {
    return NetworkResponse(false, jsonParser, statusCode, null, rawData, errorType);
  }

  K? getDataOnError<K>({required K Function(Map<String, dynamic>) fromJson}) {
    if (!_isSuccess) {
      return _jsonParser.parse(rawData, fromJson);
    }else{
      return null;
    }
  }

  R when<R>({
    required R Function(T data) success,
    required R Function(NetworkErrorType error) failure,
  }) {
    if (_isSuccess) {
      if (_dataOnSuccess != null) {
        return success(_dataOnSuccess);
      } else {
        return success(true as T);
      }
    } else {
      return failure(_errorType!);
    }
  }
}
