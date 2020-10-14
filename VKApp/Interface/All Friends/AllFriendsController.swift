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
    var friends = [User]()
    var lastClickedFriend = 0
    var friendsFiltered: [User] = []
    var sectionsList: [FriendsCellHeaderItem] = []
    
    var friendsService = FriendsService()
    var localDBService = LocalDataBaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsService.loadFriendsList(completion: { [weak self] result in
            self?.friends = result.response.items
            //Сохраняем в базу данных
            for friend in result.response.items {
                self?.localDBService.saveUser(id: friend.id, first_name: friend.first_name, last_name: friend.last_name, photo_50: friend.photo_50)
            }
            
            //Сортируем с начала загрузки, чтобы корректно сохранять индекс последнего нажатого друга
            self?.friends = self?.friends.sorted { (u1, u2) -> Bool in
                u1.name < u2.name
            } ?? []
            
            self?.sectionsList = self?.map(input: self?.friends ?? []) ?? []
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
        
        setupSearchBar()
        
        tableView.register(AllFriendsCellHeader.self, forHeaderFooterViewReuseIdentifier: "FriendHeader")
        tableView.allowsSelection = true
    }
    
    private func map(input: [User]) -> [FriendsCellHeaderItem] {
        var itemsList: [FriendsCellHeaderItem] = []
        
        var previousLetter = input.first?.getNameFirstLetter() ?? "A"
        var usersList: [User] = []
        var indiciesList: [Int] = []
        
        for (index, user) in input.enumerated() {
            let firstUserNameLetter = user.getNameFirstLetter()
            if firstUserNameLetter == previousLetter {
                usersList.append(user)
                indiciesList.append(index)
            } else {
                itemsList.append(FriendsCellHeaderItem(headerTitle: previousLetter, users: usersList, indicies: indiciesList))
                usersList = [user]
                indiciesList = [index]
                previousLetter = firstUserNameLetter
            }
        }
        if usersList.count > 0 {
            itemsList.append(FriendsCellHeaderItem(headerTitle: previousLetter, users: usersList, indicies: indiciesList))
        }
        
        return itemsList
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsList[section].users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Получаем ячейку из пула
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? AllFriendsCell {
            //Получаем объект друга для конкретной ячейки
            let friend = sectionsList[indexPath.section].users[indexPath.row]
            
            //Конфигурируем ячейку
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
        //Получаем header из пула
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FriendHeader") as? AllFriendsCellHeader {
            //Устанавливаем свойства хедера
            header.config(sectionItem: sectionsList[section])
            return header
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

/*extension AllFriendsController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PhotoViewController {
            if let cell = sender as? UITableViewCell {
                if let indexPath = self.tableView.indexPath(for: cell) {
                    destination.gallery = sectionsList[indexPath.section].users[indexPath.row].gallery
                    lastClickedFriend = sectionsList[indexPath.section].indicies[indexPath.row]
                }
            }
        }
    }

    @IBAction func exitFromPhoto(sender: UIStoryboardSegue) {
        if let source = sender.source as? PhotoViewController {
            friends[lastClickedFriend].gallery = source.gallery
            print(friends[lastClickedFriend].name)
            for element in friends[lastClickedFriend].gallery {
                print(element)
            }
            sectionsList = map(input: friends)
        }
    }
}*/

