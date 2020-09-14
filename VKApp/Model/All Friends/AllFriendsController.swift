//
//  AllFriendsController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 27.08.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class AllFriendsController: UITableViewController {
    @IBOutlet weak var myFriendsSearchBar: UISearchBar!
    
    var searchActive: Bool = false
    var friends = [User(name: "Arturo"),
                  User(name: "Roberto"),
                  User(name: "Alex"),
                  User(name: "Ujin"),
                  User(name: "Uriel")]
    var friendsFiltered: [User] = []
    var sectionsList: [FriendsCellHeaderItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        sectionsList = map(input: friends)
        
        tableView.register(AllFriendsCellHeader.self, forHeaderFooterViewReuseIdentifier: "FriendCellHeader")
    }
    
    private func map(input: [User]) -> [FriendsCellHeaderItem] {
        let sortedUsers = input.sorted{ (u1, u2) -> Bool in
            u1.name < u2.name
        }
        var itemsList: [FriendsCellHeaderItem] = []
        
        var previousLetter = sortedUsers.first?.getNameFirstLetter() ?? "A"
        var usersList: [User] = []
        
        for user in sortedUsers {
            let firstUserNameLetter = user.getNameFirstLetter()
            if firstUserNameLetter == previousLetter {
                usersList.append(user)
            } else {
                itemsList.append(FriendsCellHeaderItem(headerTitle: previousLetter, users: usersList))
                usersList = [user]
                previousLetter = firstUserNameLetter
            }
        }
        itemsList.append(FriendsCellHeaderItem(headerTitle: previousLetter, users: usersList))
        
        return itemsList
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsList[section].users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Получаем ячейку из пула
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? AllFriendsCell {
            //Получаем имя друга для конкретной строки
            let friend = sectionsList[indexPath.section].users[indexPath.row]
            
            //Устанавливаем имя друга в надпись ячейки
            cell.config(friend: friend)
            
            return cell
        } else {
            fatalError()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsList.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Получаем ячейку из пула
        if let cellHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FriendCellHeader") as? AllFriendsCellHeader {
            //Устанавливаем свойства хедера
            cellHeader.config(title: sectionsList[section].headerTitle, color: UIColor.blue.withAlphaComponent(0.5))
            return cellHeader
        } else {
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension AllFriendsController: UISearchBarDelegate {
    func setupSearchBar() {
        myFriendsSearchBar.delegate = self
        myFriendsSearchBar.placeholder = "Search friend"
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        friendsFiltered = friends.filter({ $0.name.contains(searchText) })
        if friendsFiltered.count == 0 {
            searchActive = false
            sectionsList = map(input: friends)
        } else {
            searchActive = true
            sectionsList = map(input: friendsFiltered)
        }
        tableView.reloadData()
    }
}
