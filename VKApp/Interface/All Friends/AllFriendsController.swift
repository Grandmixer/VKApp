//
//  AllFriendsController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 27.08.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class AllFriendsController: UITableViewController {
    
    @IBOutlet weak var myFriendsSearchBar: UISearchBar!

    var friendsService = FriendsService()
    var realmService = RealmService()
    var token: NotificationToken?
    
    var users: Results<RealmUser>?
    var sectionsList: [FriendsCellHeaderItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(AllFriendsCellHeader.self, forHeaderFooterViewReuseIdentifier: "FriendHeader")
        tableView.allowsSelection = true
        
        setupSearchBar()
        
        /*friendsService.loadFriendsList(completion: { [weak self] result in
            //Сохраняем web модель в базу данных realm
            self?.realmService.saveUserData(result.response.items)
        })*/
        
        friendsService.loadFriendListOp()
        
        pairTableAndRealm()
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        
        users = realm.objects(RealmUser.self)
        if let users = users {
            sectionsList = map(input: Array(users))
        } else {
            sectionsList = []
        }
        
        token = users?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            
            //Для этой страницы только обновляем
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update:
                if let users = self?.users {
                    self?.sectionsList = self?.map(input: Array(users)) ?? []
                } else {
                    self?.sectionsList = []
                }
                tableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    deinit {
        token?.invalidate()
    }
    
    private func map(input: [RealmUser]) -> [FriendsCellHeaderItem] {
        let input = input.sorted { (u1, u2) -> Bool in
            u1.name < u2.name
        }
        var itemsList: [FriendsCellHeaderItem] = []
        
        var previousLetter = input.first?.getNameFirstLetter() ?? "A"
        var usersList: [RealmUser] = []
        
        for user in input {
            let firstUserNameLetter = user.getNameFirstLetter()
            if firstUserNameLetter == previousLetter {
                usersList.append(user)
            } else {
                itemsList.append(FriendsCellHeaderItem(headerTitle: previousLetter, users: usersList))
                usersList = [user]
                previousLetter = firstUserNameLetter
            }
        }
        if usersList.count > 0 {
            itemsList.append(FriendsCellHeaderItem(headerTitle: previousLetter, users: usersList))
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
    
    @IBAction func exitButtonAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "unwindToLogin", sender: self)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
    }
}

extension AllFriendsController: UISearchBarDelegate {
    func setupSearchBar() {
        myFriendsSearchBar.delegate = self
        myFriendsSearchBar.placeholder = "Поиск друзей"
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let users = users {
            let filtered = Array(users).filter {( $0.name.contains(searchText) )}
            
            if filtered.count == 0 {
                sectionsList = map(input: Array(users))
            } else {
                sectionsList = map(input: filtered)
            }
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension AllFriendsController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PhotoViewController {
            if let cell = sender as? UITableViewCell {
                if let indexPath = self.tableView.indexPath(for: cell) {
                    destination.user = sectionsList[indexPath.section].users[indexPath.row]
                }
            }
        }
    }
}
