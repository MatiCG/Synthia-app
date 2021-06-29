import 'package:synthiapp/Models/Authentification/register.dart';
import 'package:synthiapp/config/config.dart';

class RegisterController {
  RegisterModel model = RegisterModel();

  void submit() {
    if (model.formKey.currentState!.validate()) {
      user.register(data: model.fields);
    }
  }
}
