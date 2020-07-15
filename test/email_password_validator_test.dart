import 'package:synthiaapp/login_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('empty email returns error string', () {
    var result = EmailFieldValidator.validate('');
    expect(result, 'Email can\'t be empty');
  });

  test('non-empty email return null', () {
    var result = EmailFieldValidator.validate('email');
    expect(result, null);
  });

  test('empty password returns error string', () {
    var result = PasswordFieldValidator.validate('');
    expect(result, 'Password can\'t be empty');
  });

  test('non-empty password return null', () {
    var result = PasswordFieldValidator.validate('password');
    expect(result, null);
  });
}