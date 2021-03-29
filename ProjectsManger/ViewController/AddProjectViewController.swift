//
//  AddProjectViewController.swift
//  ProjectsManger
//
//  Created by Renad nasser on 29/03/2021.
//

import UIKit

class AddProjectViewController: UIViewController {

    //MARK: - Variables
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var goalsTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var addButton: UIButton!
    
    var dataController:DataController!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        addProject()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)

    }
    
    
    //MARK: - Add Functions
    func addProject() {
        /// Create Note
        let project = Project(context: dataController.viewContext)
        
        project.creationDate = Date()
        project.name = nameTextField.text
        project.descriptions = descriptionTextField.text
        project.goals = goalsTextField.text
        project.startDate = datePicker.date
        
        ///Save note to prsistence store , in actual app must notfie the user
        try? dataController.viewContext.save()
        
        self.dismiss(animated: true)
        
    }

}
