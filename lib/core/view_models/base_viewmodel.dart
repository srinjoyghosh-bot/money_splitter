import 'package:flutter/foundation.dart';
import 'package:money_manager/core/constants/enum/view_state.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  String _errorMessage = ' ';

  String get errorMessage => _errorMessage;

  void setErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
  }
}
