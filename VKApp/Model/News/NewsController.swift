//
//  NewsController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 11.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class NewsController: UITableViewController {
    override func viewDidLoad() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Получаем ячейку из пула
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell {
            return cell
        } else {
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}
