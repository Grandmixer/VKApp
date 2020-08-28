//
//  AllFriendsController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 27.08.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class AllFriendsController: UITableViewController {
    
    var friends = ["Arturo",
                   "Roberto",
                   "Alex",
                   "Ujin"]

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! AllFriendsCell
        //Получаем имя друга для конкретной строки
        let friend = friends[indexPath.row]
        
        //Устанавливаем имя друга в надпись ячейки
        cell.friendName.text = friend
        
        return cell
    }
}
