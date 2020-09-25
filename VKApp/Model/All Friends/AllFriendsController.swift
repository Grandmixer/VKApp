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
    var friends = [User(name: "Arturo", avatar: UIImage(named: "BoyAvatar"), gallery: [Photo(image: UIImage(named: "BoyAvatar"), likesCount: 50, isUserLiked: false)]),
                   User(name: "Roberto", avatar: UIImage(named: "BoyAvatar"), gallery: [Photo(image: UIImage(named: "BoyAvatar"), likesCount: 0, isUserLiked: false), Photo(image: UIImage(named: "GirlAvatar"), likesCount: 4, isUserLiked: true)]),
                   User(name: "Alex", avatar: UIImage(named: "BoyAvatar"), gallery: [Photo(image: UIImage(named: "BoyAvatar"), likesCount: 5, isUserLiked: true)]),
                   User(name: "Ujin", avatar: UIImage(named: "BoyAvatar"), gallery: [Photo(image: UIImage(named: "BoyAvatar"), likesCount: 15, isUserLiked: true)]),
                   User(name: "Uriel", avatar: UIImage(named: "GirlAvatar"), gallery:[Photo(image: UIImage(named: "GirlAvatar"), likesCount: 17, isUserLiked: true)])]
    var lastClickedFriend = 0
    var friendsFiltered: [User] = []
    var sectionsList: [FriendsCellHeaderItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Сортируем с начала загрузки, чтобы корректно сохранять индекс последнего нажатого друга
        friends = friends.sorted { (u1, u2) -> Bool in
            u1.name < u2.name
        }
        
        setupSearchBar()
        sectionsList = map(input: friends)
        
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

extension AllFriendsController {
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
}

