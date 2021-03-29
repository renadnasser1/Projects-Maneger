//
//  Task + Extention.swift
//  ProjectsManger
//
//  Created by Renad nasser on 29/03/2021.
//

import Foundation
import CoreData

extension Task {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        creationDate = Date()
    }
}
