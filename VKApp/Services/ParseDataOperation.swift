//
//  ParseDataOperation.swift
//  VKApp
//
//  Created by Желанов Александр Валентинович on 25.02.2021.
//  Copyright © 2021 OlwaStd. All rights reserved.
//

import Foundation

class ParseDataOperation: Operation {
    
    var outputData: FriendsResult?
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
              let data = getDataOperation.data else { return }
        
        let decoder = JSONDecoder()
        if let result = try? decoder.decode(FriendsResult.self, from: data) {
            outputData = result
        }
    }
}
