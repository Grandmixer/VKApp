//
//  NextViewController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 23.08.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    @IBAction func exitTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
