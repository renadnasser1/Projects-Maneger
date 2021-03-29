//
//  ProjectCell.swift
//  ProjectsManger
//
//  Created by Renad nasser on 29/03/2021.
//

import UIKit

internal final class ProjectCell: UITableViewCell {

    @IBOutlet weak var projectName: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        projectName.text = nil
    }
    
}
