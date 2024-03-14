//
//  LoginViewController.swift
//  NapyWeather
//
//  Created by Nur on 3/14/24.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    
    @IBOutlet var welcomeLable: UILabel!
    @IBOutlet var welcomeStackView: UIStackView!
    @IBOutlet var loginStackView: UIStackView!
    
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var repeatPaswordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginStackView.isHidden = true
        welcomeStackView.isHidden = false
        
        repeatPaswordTextField.isHidden = true
        if Auth.auth().currentUser != nil {
            welcomeLable.text = "\(Auth.auth().currentUser?.email ?? "")"
        } else {
            loginStackView.isHidden = false
            welcomeStackView.isHidden = true
        }
    }
    

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let loginText = loginTextField.text, loginText != "" else {
            print("Login is empty")
            return }
        guard let passwordText = passwordTextField.text, passwordText != ""  else {
            print("Password is empty")
            return }
        Auth.auth().signIn(withEmail: loginText, password: passwordText) { user, error in
            if let error = error {
                print(error)
            } else {
                print(user?.user.email ?? "")
                self.welcomeStackView.isHidden = false
                self.loginStackView.isHidden = true
                self.welcomeLable.text = "\(user?.user.email ?? "")"
            }
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        repeatPaswordTextField.isHidden = false
        guard let loginText = loginTextField.text, loginText != "" else {
            print("Login is empty")
            return
        }
        guard let passwordText = passwordTextField.text, passwordText != "" else {
            print("Password is empty")
            return
        }
        guard let repeatPasswordText = repeatPaswordTextField.text, repeatPasswordText != "" else {
            print("Password 2 is empty")
            return
        }
        guard passwordText == repeatPasswordText else {
            print("Password 1 and 2 not equal")
            return
        }
        Auth.auth().createUser(withEmail: loginText, password: passwordText) { user, error in
            if let error = error {
                print(error)
            } else {
                self.welcomeStackView.isHidden = false
                self.loginStackView.isHidden = true
                self.welcomeLable.text = "\(user?.user.email ?? "")"
            }
        }
    }
    
        @IBAction func logoutButtonPressed(_ sender: UIButton) {
            welcomeStackView.isHidden = true
            loginStackView.isHidden = false
            try! Auth.auth().signOut()
        }
    

}
