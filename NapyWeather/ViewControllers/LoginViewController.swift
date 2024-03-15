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
    
    let alert = AlertController.showAlert
    let dataMeneger = DataManager.shared
    
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
            present(alert("Login field is empty"), animated: true)
            return }
        guard let passwordText = passwordTextField.text, passwordText != ""  else {
            present(alert("Password field is empty"), animated: true)
            return }
        Auth.auth().signIn(withEmail: loginText, password: passwordText) { user, error in
            if let error = error {
                self.present(self.alert("\(error.localizedDescription)"), animated: true)
            } else {
                self.switchStackViews()
                self.welcomeLable.text = "\(user?.user.email ?? "")"
                }
            }
        }
    
    @IBAction func syncButtonPressed(_ sender: UIButton) {
        dataMeneger.fetchFromDB()
        present(alert("Завершено"), animated: true)
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        if repeatPaswordTextField.isHidden != false {
            repeatPaswordTextField.isHidden = false
        } else {
            guard let loginText = loginTextField.text, loginText != "" else {
                present(alert("Login field is empty"), animated: true)
                return
            }
            guard let passwordText = passwordTextField.text, passwordText != "" else {
                present(alert("Password field is empty"), animated: true)
                return
            }
            guard let repeatPasswordText = repeatPaswordTextField.text, repeatPasswordText != "" else {
                present(alert("Please comfirm password"), animated: true)
                return
            }
            guard passwordText == repeatPasswordText else {
                present(alert("Password 1 and 2 are not equal"), animated: true)
                return
            }
            Auth.auth().createUser(withEmail: loginText, password: passwordText) { user, error in
                if let error = error {
                    self.present(self.alert("\(error.localizedDescription)"), animated: true)
                } else {
                    self.switchStackViews()
                    self.welcomeLable.text = "\(user?.user.email ?? "")"
                    self.dataMeneger.saveIntoDB()
                }
            }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
            switchStackViews()
            try! Auth.auth().signOut()
    }
    
    func switchStackViews() {
        welcomeStackView.isHidden.toggle()
        loginStackView.isHidden.toggle()
    }
}
