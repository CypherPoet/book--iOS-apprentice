//
//  ChecklistLoader.swift
//  Checklists
//
//  Created by Brian Sipple on 6/9/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


final class ChecklistLoader {}


extension ChecklistLoader {
    enum Error: Swift.Error {
        case noData
    }
}


// MARK: - Computeds

extension ChecklistLoader {
    
    private var savedChecklistsURL: URL {
        return FileManager
            .userDocumentsDirectory
            .appendingPathComponent("checklists", isDirectory: false)
            .appendingPathExtension("json")
    }
}


// MARK: - Core Methods

extension ChecklistLoader {
    typealias CompletionHandler = (Result<[Checklist], Error>) -> Void
    
    
    func loadSavedChecklists(
        on queue: DispatchQueue = .global(qos: .userInitiated),
        then completionHandler: @escaping CompletionHandler
    ) {
        let url = savedChecklistsURL
        print("Loading saved checklists from file at: \(url)")
        
        queue.async {
            do {
                let decoder = JSONDecoder()

                if let data = try? Data(contentsOf: url) {
                    let checklists = try decoder.decode([Checklist].self, from: data)
                    
                    completionHandler(.success(checklists))
                } else {
                    completionHandler(.failure(.noData))
                }
            } catch {
                fatalError("Error while attempting to decode saved checklists data:\n\n\(error.localizedDescription)\n\(error)")
            }
        }
    }
    
    
    func save(
        _ checklists: [Checklist],
        on queue: DispatchQueue = .global(qos: .userInitiated)
    ) {
        let url = savedChecklistsURL
        print("Saving checklists to file at: \(url)")
        
        queue.async {
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(checklists)
                try data.write(to: url, options: .atomic)
            } catch {
                fatalError("Error encoding checklist data:\n\n\(error.localizedDescription)")
            }
        }
    }

}
