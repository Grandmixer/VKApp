//
//  FirebaseAuthService.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 01.03.2021.
//  Copyright © 2021 OlwaStd. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAuthService {
    
    private var handle: AuthStateDidChangeListenerHandle!
    
    func setListener(triggered: @escaping (String?) -> Void) {
        self.handle = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                triggered("success")
            }
        }
    }
    
    func removeListener() {
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    func signIn(email: String, password: String, completion: @escaping (String?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard
                email.count > 0,
                password.count > 5
            else {
                completion("Логин и пароль введены не верно")
                
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: password) { user, error in
                if let error = error, user == nil {
                    completion(error.localizedDescription)
                }
            }
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (String?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                if let error = error {
                    completion(error.localizedDescription)
                } else {
                    Auth.auth().signIn(withEmail: email, password: password)
                }
            }
        }
    }
    
}
