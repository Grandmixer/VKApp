//
//  MyGroupsController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 27.08.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class MyGroupsController: UITableViewController {
    
    @IBOutlet weak var myGroupsSearchBar: UISearchBar!
    
    var groupsService = GroupsService()
    var realmService = RealmService()
    var token: NotificationToken?
    
    var groups: Results<RealmGroup>?
    var groupsFiltered: [RealmGroup]?
    
    override func viewDidLoad() {
        tableView.allowsSelection = true
        
        setupSearchBar()
        
        groupsService.loadGroupsList(completion: { [weak self] result in
            //Сохраняем web модель в базу данных realm
            self?.realmService.saveGroupData(result.response.items)
        })
        pairTableAndRealm()
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        
        groups = realm.objects(RealmGroup.self)
        if let groups = groups {
            groupsFiltered = Array(groups)
        } else {
            groupsFiltered = []
        }
        
        token = groups?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                if let groups = self?.groups {
                    self?.groupsFiltered = Array(groups)
                } else {
                    self?.groupsFiltered = []
                }
                
                tableView.reloadData()
                /*tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()*/
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    deinit {
        token?.invalidate()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groupsFiltered?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Получаем ячейку из пула
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as? MyGroupsCell {
            //Получаем группу для конкретной строки
            if let group = groupsFiltered?[indexPath.row] {
                //Устанавливаем имя группы в надпись в ячейке
                cell.config(group: group)
            }
            
            return cell
        } else {
            fatalError()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //Если была нажата кнопка "Удалить"
        if editingStyle == .delete {
            //Удаляем группу из основного массива
            //groups.remove(at: sectionsList[indexPath.section].groups[indexPath.row].index)
            //Удаляем группу из массива хедеров
            sectionsList[indexPath.section].groups.remove(at: indexPath.row)
            //Удаляем строку из таблицы
            tableView.deleteRows(at: [indexPath], with: .fade)
            //Если массив хедеров пуст - удаляем хедер
            if sectionsList[indexPath.section].groups.count == 0 {
                sectionsList.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
            }
            //Заного нумеруем
            groups = indexation(input: groups)
        }
    }*/
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        //Проверяем идентификатор, чтобы убедиться, что это нужный переход
        if segue.identifier == "addGroup" {
            //Получаем ссылку на контроллер, с которого осуществлен переход
            guard
                let allGroupsController = segue.source as? AllGroupsController
                else { return }
            //Получаем индекс выделенной ячейки
            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
                //Получаем группу по индексу
                let group = allGroupsController.groupsFinded[indexPath.row]
                //Проверяем, что такой группы нет
                if !(groupsFiltered?.contains(where: { $0.name == group.name }) ?? true) {
                    //Добавляем группу в список выбранных групп
                    groupsFiltered?.append(group)
                    //Обновляем таблицу
                    tableView.reloadData()
                }
            }
        }
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

extension MyGroupsController: UISearchBarDelegate {
    func setupSearchBar() {
        myGroupsSearchBar.delegate = self
        myGroupsSearchBar.placeholder = "Поиск сообществ"
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let groups = groups {
            let filtered = Array(groups).filter({ $0.name.contains(searchText) })
            
            if filtered.count == 0 {
                groupsFiltered = Array(groups)
            } else {
                groupsFiltered = filtered
            }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
