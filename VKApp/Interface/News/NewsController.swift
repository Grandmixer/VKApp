//
//  NewsController.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 11.09.2020.
//  Copyright © 2020 OlwaStd. All rights reserved.
//

import UIKit

class NewsController: UITableViewController {
    
    var newsService = NewsService()
    
    var news: [News] = []
    var users: [RealmUser] = []
    var groups: [RealmGroup] = []
    
    override func viewDidLoad() {
        let actividtyIndicator = UIActivityIndicatorView(style: .large)
        tableView.addSubview(actividtyIndicator)
        actividtyIndicator.startAnimating()
        actividtyIndicator.center = tableView.center
        
        newsService.loadNews(completion: { [weak self] result in
            self?.news = result.response.items
            self?.users = result.response.profiles
            self?.groups = result.response.groups
            
            DispatchQueue.main.async {
                actividtyIndicator.removeFromSuperview()
                self?.tableView.reloadData()
            }
        })
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Получаем ячейку из пула
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell {
            let news = self.news[indexPath.row]
            
            let id = news.source_id
            if id > 0 {
                if let user = users.filter({ $0.id == id }).first {
                    cell.config(news: news, user: user)
                }
            } else {
                if let group = groups.filter({ abs($0.id) == abs(id) }).first {
                    cell.config(news: news, group: group)
                }
            }
            
            return cell
        } else {
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
}
