import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:email_validator/email_validator.dart';
import 'package:powerup/DBHelper.dart';
import 'package:powerup/entities/User.dart';

class LoginRegisterController{

/*
  static bool accountInDB(String email, String password){
    if(email == 'j' && password == 'a'){
      return true;
    }
    return false;
  }

--------------------------------------------------------------------------------
  /// Function to check if passwords match
  ------To move to UI------

  bool passwordMatch(String passwordU, String reenterPassword) {

  }
--------------------------------------------------------------------------------
  */
  
  /// Function to send email with verification code upon successful registration
  /// called by function in UI after checkDetails()
  Future<int> sendValidationEmail(String email) async {
    /// Generate pseudo-random 6-digit code
    Random random  = new Random();
    int codeGenerated = random.nextInt(900000) + 100000;
    /// Send code inside confirmation email
    String username = 'powerup_cz3003@gmail.com';
    String password = 'password';

    /// configure the SMTP server
    /// final SMTP server would be 'smtp.domain.com'
    final smtpServer = gmailSaslXoauth2(username, password);
    
    // Create message
    final message = Message()
      ..from = Address(username, 'PowerUp!')
      ..recipients.add(email)
      ..subject = 'PowerUp! Account Verification :: 😀 :: ${DateTime.now()}'
      ..text = '''Thank you for registering with PowerUp!.\n
      Please enter the code below witin 30 minutes to verify your account:\n'''
      ..html = "<h1>$codeGenerated</h1>\n";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    /// return code generated to calling function in UI
    return codeGenerated;
  }


  /// Function to check if email already exists in database
  Future<bool> isValidEmail(String email) async {
    /// check if email format is valid
    try {
      final bool isValid = EmailValidator.validate(email);
      if (isValid == true) {
        /// format is okay, check database for match
        var users = await DBHelper().getAllUsers();  /// Get list of User objects
        /// check if the id attribute matches
        for (int i = 0; i < users.length; i++) {
          if (users[i].emailAddress == email)
            return false;     /// return false if email matches in database (match --> email already in use)
        }
        return true;      /// return true if email does not already exist in database
      }
    } catch(e) {
      print(e);
      return false;
    }
  }

/*
  /// Function to verify code when user enters code received by email
  bool isValidCode(int codeEmailed, codeEntered) {
    /// return true if code matches one sent to email
    if (!(codeEmailed == codeEntered))
      return false;
    else
      return true;
  }

  /// Function to check DOB
  bool isValidDate(String dob) {
    final String formatStyle = "dd/MM/yy";

      try {
        DateFormat format = new DateFormat(formatStyle);
        format.parseStrict(dob);
      } catch (e) {
        return false;
      }
      return true;
  }
*/
  /// Function to check contactNum
  bool isValidContactNum(int contactNum) {
    String contactNumStr = contactNum.toString();
    final String pattern = '/\+65(6|8|9)\d{7}/g';
    RegExp regExp = new RegExp(pattern);

    if (!regExp.hasMatch(contactNumStr)) {
      return false;
    }
    else {
      return true;
    }
  }

  /// Function to hash password
  String generateHash(String passwordU) {
    /// return hashed password for storage
    try {
      var bytes = utf8.encode(passwordU);
      var digest = sha256.convert(bytes);
      String output = digest.toString();

      return output;

    } catch(e) {
      print(e);
    }
    /// print("Digest as bytes: ${digest1.bytes}");
    /// print("Digest as hex string: $digest1");
  }

  /// Function to process login for users with accounts in database
  /// return true if passwords match
  /// return false if username or password not found.
  Future<bool> login(String username, String password) async {
    /// Perform hashing for comparison with stored password later
    String hashedPassword = generateHash(password);
    try {
      var accounts = await DBHelper().getAllUsers();
      for (int i = 0; i < accounts.length; i++) {
          if (accounts[i].emailAddress == username){
            if (accounts[i].passwordU == hashedPassword)
              return true;
            else
              return false;     /// password does not match
          }
          else
            return false;       /// username does not match/does not exist
        }
    } catch (e) {
      print(e);
    }
  }

  /// Function to collect and check validity and formatting of details
  Future<String> checkDetails(String email, int contactNum, int nokContactNum) async {
    /// Check email
    try {
      bool emailValidation = await isValidEmail(email);
      if (!emailValidation)
        return "Email address is not valid. Please check and try again.";
    } catch (e) {
      print("Caught Error at email validation.");
      print(e);
      return "-1";
    }
    /// Check contact number and NOK contact number
    try {
      if (!isValidContactNum(contactNum))
        return "Contact Number is not valid, please check and try again";
      if (!isValidContactNum(nokContactNum))
        return "NOK Contact number is not valid, please check and try again";
    } catch (e) {
      print("Caught error at contact number validation.");
      print(e);
      return "-1";
    }
  }

  Future<String> createUser(String name, String dob, String email, int contactNum, String passwordU, String nokName, int nokContactNum) async {
    String hashedPassword = "";
    /// Hash password for storage
    try {
      hashedPassword = generateHash(passwordU);
    } catch (e) {
      print("Caught error at password hashing.");
      print(e);
      return "-1";
    }
    User user = new User(name, dob, email, contactNum, hashedPassword, nokName, nokContactNum);
    User saveResult;
    /// Format data in User object to pass to DB class so that DBHelper can write to DB under one single user
    try {
      User user = new User(name, dob, email, contactNum, hashedPassword, nokName, nokContactNum);
      User saveResult = await DBHelper().saveUser(user);
    } catch (e) {
      print(e);
      return "-1";
    }

    if (!(user == saveResult))
      return "Registration Unsuccessful";
    else
      return "Success!";
  }

/*In UI, run following functions: checkDetails, sendValidationEmail (returns codeGenerated) -
  which can be compared to code user enters in text field, and createUser (returns String)*/
}