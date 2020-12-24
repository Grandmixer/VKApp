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
    
    var groupsService = GroupsService()
    
    var groupsFinded: [RealmGroup] = []
    
    override func viewDidLoad() {
        tableView.allowsSelection = true
        
        setupSearchBar()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsFinded.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Получаем ячейку из пула
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? AllGroupsCell {
            //Получаем группу для конкретной строки
            let group = groupsFinded[indexPath.row]
            //Устанавливаем имя группы в надпись в ячейке
            cell.config(group: group)
            
            return cell
        } else {
            fatalError()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension AllGroupsController: UISearchBarDelegate {
    func setupSearchBar() {
        allGroupsSearchBar.delegate = self
        allGroupsSearchBar.placeholder = "Найти сообщество"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard searchBar.text?.count != 0 else { return }
        
        if let text = searchBar.text {
            groupsFinded = []
            tableView.reloadData()
            
            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .large)
            tableView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            activityIndicator.center = tableView.center
            
            groupsService.searchGroups(substring: text, completion: { [weak self] result in
                self?.groupsFinded = result.response.items
                
                DispatchQueue.main.async {
                    activityIndicator.removeFromSuperview()
                    self?.tableView.reloadData()
                }
            })
        }
    }
}

