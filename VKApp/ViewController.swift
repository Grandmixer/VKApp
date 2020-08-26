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
    
    @IBAction func exitFromNextViewController(unwindSegue: UIStoryboardSegue) {}
}

