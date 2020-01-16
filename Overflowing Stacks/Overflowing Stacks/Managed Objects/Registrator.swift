//
//  Session.swift
//  Overflowing Stacks
//
//  Created by Faisal Bhombal on 1/15/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//

import Foundation
import CoreData

/***
 Singleton to manage setting and retrieving registry values from core data
 */
class Registrator {
    
    public enum RegistryKey: String {
        case duration = "duration"
    }
    
    let options: [String] = [ "4 hours", "12 hours", "24 hours", "2 days", "3 days", "4 days" , "5 days" , "6 days", "1 week", "2 weeks", "3 weeks", "4 weeks"]
    
    weak var persistentContainer: NSPersistentContainer!
    
    static let shared = Registrator()
    private init() {}
    
    func set(value: String, forKey key: RegistryKey ) -> Void {
        
        let fetchRequest: NSFetchRequest<Registry> = Registry.fetchRequest()
        fetchRequest.predicate = NSPredicate( format:"key == %@",  key.rawValue)
        let moc = persistentContainer.viewContext
        do {
            let result = try moc.fetch(fetchRequest)
            if let rec = result.first {
                rec.value = value
            } else {
                // Add the key
                let entity = NSEntityDescription.entity(forEntityName: "Registry", in: moc)
                guard let registry = NSManagedObject(entity: entity!, insertInto: moc ) as? Registry else {
                    return
                }
                registry.key = key.rawValue
                registry.value = value
            }
            try moc.save()
            
        } catch {
            print( error )
        }
    }
    
    func value(forKey key: RegistryKey) -> String {
        
        let fetchRequest: NSFetchRequest<Registry> = Registry.fetchRequest()
        fetchRequest.predicate = NSPredicate( format:"key == %@",  key.rawValue)
        let moc = persistentContainer.viewContext
        do {
            let result = try moc.fetch(fetchRequest)
            return result.first?.value ?? "4 hours"
            
            
        } catch {
            print( error )
        }
        return "4 hours"
    }
}
