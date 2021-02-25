//
//  GetDataOperation.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 25.02.2021.
//  Copyright © 2021 OlwaStd. All rights reserved.
//

import Foundation

class GetDataOperation: AsyncOperation {
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
    
    private var session: URLSession
    private var url: URL
    private var task: URLSessionDataTask?
    
    var data: Data?
    
    override func main() {
        task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else { return }
            
            self?.data = data
            self?.state = .finished
        }
        task?.resume()
    }
    
    init(session: URLSession, url: URL) {
        self.session = session
        self.url = url
    }
}
