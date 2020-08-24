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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(notification: Notification) {
        guard
            let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            else { return }
        
        scrollView.contentInset.bottom = keyboardRect.height
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //Проверяем данные
        let checkResult = checkUserData()
        
        //Если данные не верны, показываем ошибку
        if !checkResult {
            showLoginError()
        }
        
        //Вернем результат
        return checkResult
    }
    
    func checkUserData() -> Bool {
        guard
            let login = loginTextField.text,
            let password = passwordTextField.text
            else { return false }
        
        if login == "admin" && password == "123" {
            return true
        } else {
            return false
        }
    }
    
    func showLoginError() {
        //Создаем контроллер
        let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
        //Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "Понятно", style: .default)
        //Добавляем кнопку на UIAlertController
        alert.addAction(action)
        //Показываем UIAlertController
        present(alert, animated: true)
    }
    
    @IBAction func exitFromNextViewController(unwindSegue: UIStoryboardSegue) {}
}

