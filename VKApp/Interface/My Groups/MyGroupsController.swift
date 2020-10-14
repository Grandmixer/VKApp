//
//  MyGroupsController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 27.08.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class MyGroupsController: UITableViewController {
    
    @IBOutlet weak var myGroupsSearchBar: UISearchBar!
    
    var searchActive = false
    var groups: [Group] = []
    var groupsFiltered: [Group] = []
    var sectionsList: [GroupsCellHeaderItem] = []
    
    var groupsService = GroupsService()
    
    override func viewDidLoad() {
        groupsService.loadGroupsList(completion: { [weak self] result in
            self?.groups = result.response.items
            
            //Сортируем с начала загрузки, чтобы корректно сохранять индекс последнего нажатого друга
            self?.groups = self?.groups.sorted { (u1, u2) -> Bool in
                u1.name < u2.name
            } ?? []
            
            self?.sectionsList = self?.map(input: self?.groups ?? []) ?? []
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
        setupSearchBar()
        
        tableView.register(AllGroupsCellHeader.self, forHeaderFooterViewReuseIdentifier: "GroupsHeader")
        tableView.allowsSelection = true
    }
    
    private func indexation(input: [Group]) -> [Group] {
        return input.enumerated().map{ (index, element: Group) -> Group in
            var mutableGroup = element
            //mutableGroup.index = index
            return mutableGroup
        }
    }
    
    private func map(input: [Group]) -> [GroupsCellHeaderItem] {
        var itemsList: [GroupsCellHeaderItem] = []
        
        var previousLetter = input.first?.getNameFirstLetter() ?? "A"
        var groupsList: [Group] = []
        
        for group in input {
            let firstGroupNameLetter = group.getNameFirstLetter()
            if firstGroupNameLetter == previousLetter {
                groupsList.append(group)
            } else {
                itemsList.append(GroupsCellHeaderItem(headerTitle: previousLetter, groups: groupsList))
                groupsList = [group]
                previousLetter = firstGroupNameLetter
            }
        }
        if groupsList.count > 0 {
            itemsList.append(GroupsCellHeaderItem(headerTitle: previousLetter, groups: groupsList))
        }
        
        return itemsList
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsList[section].groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Получаем ячейку из пула
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as? MyGroupsCell {
            //Получаем группу для конкретной строки
            let group = sectionsList[indexPath.section].groups[indexPath.row]
            
            //Устанавливаем имя группы в надпись в ячейке
            cell.config(group: group)
            
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
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GroupsHeader") as? AllGroupsCellHeader {
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

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    }
    
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
                let group = allGroupsController.sectionsList[indexPath.section].groups[indexPath.row]
                //Проверяем, что такой группы нет
                if !groups.contains(where: { $0.name == group.name }) {
                    //Добавляем группу в список выбранных групп
                    groups.append(group)
                    groups = indexation(input: groups)
                    //Обновляем таблицу
                    sectionsList = map(input: groups)
                    tableView.reloadData()
                }
            }
        }
    }
}

extension MyGroupsController: UISearchBarDelegate {
    func setupSearchBar() {
        myGroupsSearchBar.delegate = self
        myGroupsSearchBar.placeholder = "Search group"
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
        groupsFiltered = groups.filter({ $0.name.contains(searchText) })
        if groupsFiltered.count == 0 {
            searchActive = false
            sectionsList = map(input: groups)
        } else {
            searchActive = true
            sectionsList = map(input: groupsFiltered)
        }
        tableView.reloadData()
    }
}
