//
//  AllGroupsController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 27.08.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class AllGroupsController: UITableViewController {
    
    @IBOutlet weak var allGroupsSearchBar: UISearchBar!
    
    var searchActive: Bool = false
    var groupsFiltered: [Group] = []
    var sectionsList: [GroupsCellHeaderItem] = []
    
    override func viewDidLoad() {
        /*groups = groups.sorted { (u1, u2) -> Bool in
            u1.name < u2.name
        }
        
        setupSearchBar()
        sectionsList = map(input: groups)
        
        tableView.register(AllGroupsCellHeader.self, forHeaderFooterViewReuseIdentifier: "GroupsHeader")
        tableView.allowsSelection = true*/
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? AllGroupsCell {
            //Получаем группу для конкретной строки
            let group = sectionsList[indexPath.section].groups[indexPath.row]
            
            //Устанавливаем имя группы в надпись в ячейке
            //cell.config(group: group)
            
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
}

extension AllGroupsController: UISearchBarDelegate {
    func setupSearchBar() {
        allGroupsSearchBar.delegate = self
        allGroupsSearchBar.placeholder = "Search group"
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
        /*groupsFiltered = groups.filter({ $0.name.contains(searchText) })
        if groupsFiltered.count == 0 {
            searchActive = false
            sectionsList = map(input: groups)
        } else {
            searchActive = true
            sectionsList = map(input: groupsFiltered)
        }
        tableView.reloadData()*/
    }
}

