//
//  ViewController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 23.08.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var firebaseAuthService = FirebaseAuthService()
    
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
        
        firebaseAuthService.setListener(triggered: { [weak self] str in
            if let flag = str, flag == "success" {
                self?.performSegue(withIdentifier: "FirebaseLogin", sender: nil)
                self?.loginTextField.text = nil
                self?.passwordTextField.text = nil
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        firebaseAuthService.removeListener()
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
            let password = passwordTextField.text
        else { return }
        
        firebaseAuthService.signIn(email: email, password: password, completion: { [weak self] str in
            if let errStr = str {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Ошибка", message: errStr, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                
                    self?.present(alert, animated: false, completion: nil)
                }
            }
        })
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
        let saveAction = UIAlertAction(title: "Зарегистрироватсья", style: .default) { [weak self] _ in
            guard let emailField = alert.textFields?[0],
                  let passwordField = alert.textFields?[1],
                  let password = passwordField.text,
                  let email = emailField.text else { return }
            
            self?.firebaseAuthService.signUp(email: email, password: password, completion: { str in
                if let errStr = str {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Ошибка", message: errStr, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                        
                        self?.present(alert, animated: true)
                    }
                }
            })
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

