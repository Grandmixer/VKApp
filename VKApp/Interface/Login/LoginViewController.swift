//
//  ViewController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 23.08.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var webview: WKWebView! {
        didSet {
            webview.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Жест нажатия
        let tapKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        //Присваиваем жест UIScrollView
        scrollView.addGestureRecognizer(tapKeyboardGesture)
        
        loadWebView()
    }
    
    func loadWebView() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7611567"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "friends,photos,groups,wall"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.126"),
            URLQueryItem(name: "state", value: "success")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webview.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
            return true
            //return false
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

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print(navigationResponse.response.url)
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        if let token = params["access_token"] {
            let session = Session.instance
            session.token = token
        }
        
        decisionHandler(.cancel)
        performSegue(withIdentifier: "SuccessLogin", sender: self)
    }
}

