//
//  TaskCell.swift
//  ProjectsManger
//
//  Created by Renad nasser on 29/03/2021.
//

import UIKit
internal final class TaskCell: UITableViewCell {
    
    @IBOutlet weak var taskName: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        taskName.text = nil
    }
}

