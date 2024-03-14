//
//  LoginViewController.swift
//  NapyWeather
//
//  Created by Nur on 3/14/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var repeatPaswordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repeatPaswordTextField.isHidden = true
    }
    

    @IBAction func loginButtonPressed(_ sender: UIBarButtonItem) {
        guard let loginText = loginTextField.text, loginText != "" else {
            print("Login is empty")
            return }
        guard let passwirdText = passwordTextField.text, passwirdText != ""  else {
            print("Password is empty")
            return }
        print("GOOD")
    }
    
    @IBAction func signupButtonPressed(_ sender: UIBarButtonItem) {
        repeatPaswordTextField.isHidden = false
        guard let loginText = loginTextField.text, loginText != "" else {
            print("Login is empty")
            return
        }
        guard let passwirdText = passwordTextField.text, passwirdText != "" else {
            print("Password is empty")
            return
        }
        guard let repeatPasswirdText = repeatPaswordTextField.text, repeatPasswirdText != "" else {
            print("Password 2 is empty")
            return
        }
        guard passwirdText == repeatPasswirdText else {
            print("Password 1 and 2 not equal")
            return
        }
        print("GOOD")
    }

}
