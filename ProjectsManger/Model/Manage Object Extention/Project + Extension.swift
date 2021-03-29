//
//  Project + Extension.swift
//  ProjectsManger
//
//  Created by Renad nasser on 29/03/2021.
//

import Foundation
import CoreData

extension Project {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        creationDate = Date()
    }
}
