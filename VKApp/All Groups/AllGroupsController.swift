//
//  AllGroupsController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 27.08.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class AllGroupsController: UITableViewController {
    
    var groups = ["CatLovers",
                  "2ch.hk",
                  "Memes",
                  "BlackLivesMatter"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! AllGroupsCell
        //Получаем группу для конкретной строки
        let group = groups[indexPath.row]
        
        //Устанавливаем имя группы в надпись в ячейке
        cell.groupName.text = group
        
        return cell
    }
}

