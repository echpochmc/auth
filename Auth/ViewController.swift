//
//  ViewController.swift
//  Auth
//
//  Created by Азат Султанов on 11.09.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaultsData()
        if defaults.isDataExist {
            pushToProfile()     
        }
        loginButton.isEnabled = false
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        emailTextField.delegate = self
        emailTextField.layer.borderColor = UIColor.red.cgColor
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 2
        passwordTextField.delegate = self
        passwordTextField.layer.borderColor = UIColor.red.cgColor
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        var haveUser: Bool = false
        User.users.forEach({ user in
            if user.email == emailTextField.text && user.password == passwordTextField.text {
                let defaults = UserDefaultsData()
                defaults.saveUserData(email: user.email, password: user.password)
                haveUser = true
            }
        })
        
        if haveUser {
            pushToProfile()
        } else {
            showAlert()
        }
    }
    
    func pushToProfile() {
        self.performSegue(withIdentifier: "ProfileIdentifier", sender: self)
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    func validatePassword(enteredPassword: String) -> Bool {
        
        let passwordFormat = "(?=.*?[a-z])(?=.*?[0-9]).{6,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordFormat)
        
        return passwordPredicate.evaluate(with: enteredPassword)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Неправильный логин или пароль", preferredStyle: .actionSheet)
        let okAlertButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAlertButton)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.hasPrefix(" "){
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            if validateEmail(enteredEmail: textField.text ?? "") {
                textField.layer.borderWidth = 0
            } else {
                textField.layer.borderWidth = 1
            }
        } else if textField == passwordTextField {
            if validatePassword(enteredPassword: textField.text ?? "") {
                textField.layer.borderWidth = 0
            } else {
                textField.layer.borderWidth = 1
            }
        }
        loginButton.isEnabled = validateEmail(enteredEmail: emailTextField.text ?? "") && validatePassword(enteredPassword: passwordTextField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

struct User {
    
    let email: String
    let password: String
    let name: String
    let surname: String
    let image: UIImage
    
    static let users: [User] = [User(email: "HelloWorld@mail.ru", password: "HelloWorld1", name: "Hello", surname: "World", image: #imageLiteral(resourceName: "0*AotcC6GhXMHgyjmz")),
                                User(email: "azatSultanov@mail.ru", password: "azatSultanov1", name: "Azat", surname: "Sultanov", image: #imageLiteral(resourceName: "s1Pi-Hpvb5U-3")),
                                User(email: "arturBulgakov@mail.ru", password: "arturBulgakov1", name: "Artur", surname: "Bulgakov", image: #imageLiteral(resourceName: "x_YWHNiDmlk")),
                                User(email: "nikitaKas@mail.ru", password: "nikitaKas1", name: "Nikita", surname: "Kas", image: #imageLiteral(resourceName: "ou2xqLv-Kfo"))]
}

class UserDefaultsData {
    
    private let defaults = UserDefaults.standard
    
    var isDataExist: Bool {
        defaults.value(forKey: "email") != nil
    }
    
    func saveUserData(email: String, password: String) {
        defaults.setValue(email, forKey: "email")
        defaults.setValue(password, forKey: "password")
    }
    
    func deleteData() {
        
        defaults.setValue(nil, forKey: "email")
        defaults.setValue(nil, forKey: "password")
    }
    
    func getUserEmail() -> String {
        return defaults.value(forKey: "email") as! String
    }
}

