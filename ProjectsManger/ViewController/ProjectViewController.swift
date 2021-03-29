//
//  ProjectViewController.swift
//  ProjectsManger
//
//  Created by Renad nasser on 29/03/2021.
//

import UIKit
import CoreData

class ProjectViewController: UIViewController, UITableViewDataSource {
    

    //MARK:- Variable
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    var totalCost : Float = 0
    
    var project:Project!
    var fetchResultsController : NSFetchedResultsController<Task>!
    
    var dataController:DataController!
    
    /// A date formatter for date text in note cells
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFetchResult()
        setUIElements()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setUpFetchResult()
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()

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
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(project)")
        
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
        navigationItem.title = project.name
        descriptionLabel.text = project.descriptions
        goalsLabel.text = project.goals
        if let startDate = project.startDate{
            dataLabel.text = dateFormatter.string(from: startDate) }
        
        if let tasks = fetchResultsController.fetchedObjects{
            
            for task in tasks {
                updateCost(with: task.cost)
            }
        }

    }
    
    func updateCost(with cost:Float){
        totalCost += cost
        costLabel.text = "\(totalCost) SR"
    }
    
    //MARK: - Editting
    
    // Deletes the `Task` at the specified index path
    func deleteTask(at indexPath: IndexPath) {
        //TODO: remove note
        let taskToDelete = fetchResultsController.object(at: indexPath)
        ///Delete from prsistance store and save changes
        dataController.viewContext.delete(taskToDelete)
        
        try? dataController.viewContext.save()
        
    }
    
    func updateEditButtonState() {
        if let sections = fetchResultsController.sections{
            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteTask(at: indexPath)
        default: () // Unsupported
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If this is a NotesListViewController, we'll configure its `Notebook`
        
        if let vc = segue.destination as? AddTaskViewController {
            vc.dataController=dataController
            vc.project = project
        }
//        if let vc = segue.destination as? ProjectViewController {
//
//            if let indexPath = tableView.indexPathForSelectedRow {
//                vc.project = fetchResultsController.object(at: indexPath)
//                vc.dataController=dataController
//            }
 //       }
    }

}

extension  ProjectViewController:NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
        
    }
    
}

