//
//  TaskViewController.swift
//  ProjectsManger
//
//  Created by Raghad alfuhaid on 16/08/1442 AH.
//

import Foundation


import UIKit
import CoreData

class TaskViewController: UIViewController, NSFetchedResultsControllerDelegate {


    
    var project:Project!
    var task:Task!
    var fetchResultsController : NSFetchedResultsController<Task>!

    var dataController:DataController!

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var resLabel: UILabel!
    
    @IBOutlet weak var costLabel: UILabel!
   
    /// A date formatter for date text in note cells
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Something Else", style: .plain, target: nil, action: nil)
        
        
        
        setUpFetchResult()
        setUIElements()

        durationLabel.text=String(Int(task.duration))
        resLabel.text=task.recersous
        dateLabel.text=dateFormatter.string(from: task.startDate!)
       
        costLabel.text = String(task.cost)
        
        navigationItem.title = task.name
        

        // make multiline for resourse
        resLabel.numberOfLines = 0
        resLabel.lineBreakMode = .byWordWrapping
        resLabel.frame.size.width = 300
        resLabel.sizeToFit()
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.36, green: 0.18, blue: 0.27, alpha: 1.00)

        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {

        setUpFetchResult()

//
    }

    //Helper method
    fileprivate func setUpFetchResult() {
        /// Fetch Request
        let fetchRequest:NSFetchRequest<Task> = Task.fetchRequest()

        ///Include only notes related to spcific notebook
        let predicate = NSPredicate(format: "project == %@", project)
        fetchRequest.predicate = predicate

        ///sort request
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors=[sortDescriptor]

        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(task)")

        fetchResultsController.delegate = self


        ///fecth
        do{
            try fetchResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed :\(error.localizedDescription)")
        }

    }
    //MARK: - Set UI Elements

    func setUIElements(){
        navigationItem.title = task.name

    }



    func updateEditButtonState() {
        if let sections = fetchResultsController.sections{
            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
        }
    }



    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aTask = fetchResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell

        // Configure cell
        cell.taskName.text = aTask.name
        return cell
    }



}


