//
//  DataController.swift
//  ProjectsManger
//
//  Created by Renad nasser on 29/03/2021.
//

import Foundation
import CoreData

class DataController{
    
    /// Proprities
    let persistentContainar:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext{
        return persistentContainar.viewContext
    }
    var backgroundContext:NSManagedObjectContext!
    
    /// Intilaizer
    init(modelName:String) {
        persistentContainar = NSPersistentContainer(name: modelName)
    }
    func configureContext() {
        backgroundContext = persistentContainar.newBackgroundContext()
        
        ///Automaticlly configure changes
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        
        
    }
    
    /// Functions
    func load(complation: (() -> Void)? = nil) {
        persistentContainar.loadPersistentStores { (storeDescription, error) in
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext(interval: 30)
            self.configureContext()
            complation?()
        }
    }
    
}

extension DataController{
    
    func autoSaveViewContext(interval:TimeInterval = 30) {
        print("auto save")
        guard interval  > 0 else {
            print("cannot set negative autosave")
            return
        }
        
        if viewContext.hasChanges{
            try? viewContext.save()}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
    
}
