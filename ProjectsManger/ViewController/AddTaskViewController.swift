//
//  AddTaskViewController.swift
//  ProjectsManger
//
//  Created by Renad nasser on 29/03/2021.
//

import UIKit

class AddTaskViewController: UIViewController {

    //MARK:- Variables
    @IBOutlet weak var nameTextFiled: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var durationTextFiled: UITextField!
 
    @IBOutlet weak var resourcesTextFiled: UITextField!
    
    @IBOutlet weak var costTextFiled: UITextField!
    
    var dataController:DataController!
    var project : Project!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:-Action
    
    @IBAction func addTapped(_ sender: Any) {
        addTask()

    }
    
   //MARK: - Editting
    func addTask() {
        let task = Task(context: dataController.viewContext)
        
        task.name = nameTextFiled.text
        task.creationDate = Date()
        task.startDate = datePicker.date
        task.duration = Double(durationTextFiled.text!)!
        task.recersous = resourcesTextFiled.text
        task.cost = Float(costTextFiled.text!)!
        task.project = project
        
        
        ///Save note to prsistence store , in actual app must notfie the user
        try? dataController.viewContext.save()
        resetUITextFileds()
        showAlert()
        
    }
    
    func resetUITextFileds(){
        nameTextFiled.text = ""
        datePicker.setDate(Date.init(), animated: false)
        durationTextFiled.text = ""
        
        resourcesTextFiled.text = ""
        
        costTextFiled.text = ""
        
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Task added Successfuly", message: "Task have been added to its \(project.name ?? "project") tasks list", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    

}
