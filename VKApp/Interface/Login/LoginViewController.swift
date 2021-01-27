//
//  ViewController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 23.08.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var handle: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Жест нажатия
        let tapKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        //Присваиваем жест UIScrollView
        scrollView.addGestureRecognizer(tapKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.handle = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "FirebaseLogin", sender: nil)
                self.loginTextField.text = nil
                self.passwordTextField.text = nil
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    @objc
    func keyboardWillShow(notification: Notification) {
        guard
            let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            else { return }
        
        scrollView.contentInset.bottom = keyboardRect.height
    }
    
    @objc
    func keyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
    }
    
    //Скрывать клавиатуру при клике по пустому месту на экране
    @objc
    func hideKeyboard() {
        scrollView.endEditing(true)
    }
    
    @IBAction func unwind (_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func LoginAction(_ sender: Any) {
        guard
            let email = loginTextField.text,
            let password = passwordTextField.text,
            email.count > 0,
            password.count > 5
        else {
            let alert = UIAlertController(title: "Ошибка", message: "Логин и пароль введены не верно", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                
                self?.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func SignupAction(_ sender: Any) {
        let alert = UIAlertController(title: "Регистрация", message: "Регистрация", preferredStyle: .alert)
        
        alert.addTextField{ textEmail in
            textEmail.placeholder = "Введите свой e-mail"
        }
        alert.addTextField{ textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Введите пароль"
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        let saveAction = UIAlertAction(title: "Зарегистрироватсья", style: .default) { _ in
            guard let emailField = alert.textFields?[0],
                  let passwordField = alert.textFields?[1],
                  let password = passwordField.text,
                  let email = emailField.text else { return }
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
                if let error = error {
                    let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                    
                    self?.present(alert, animated: true)
                } else {
                    Auth.auth().signIn(withEmail: email, password: password)
                }
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

