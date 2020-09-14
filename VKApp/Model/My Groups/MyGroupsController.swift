//
//  MyGroupsController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 27.08.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class MyGroupsController: UITableViewController {
    
    var groups = [String]()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Получаем ячейку из пула
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as? MyGroupsCell {
            //Получаем группу для конкретной строки
            let group = groups[indexPath.row]
            
            //Устанавливаем имя группы в надпись в ячейке
            cell.config(name: group)
            
            return cell
        } else {
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //Если была нажата кнопка "Удалить"
        if editingStyle == .delete {
            //Удаляем группу из массива
            groups.remove(at: indexPath.row)
            //Удаляем строку из таблицы
            tableView.deleteRows(at: [indexPath], with: .fade)
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
                let group = allGroupsController.groups[indexPath.row]
                //Проверяем, что такой группы нет
                if !groups.contains(group) {
                    //Добавляем группу в список выбранных групп
                    groups.append(group)
                    //Обновляем таблицу
                    tableView.reloadData()
                }
            }
        }
    }
}
