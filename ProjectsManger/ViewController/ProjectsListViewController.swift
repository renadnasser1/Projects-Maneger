//
//  ProjectsListViewController.swift
//  ProjectsManger
//
//  Created by Renad nasser on 29/03/2021.
//

import UIKit
import CoreData

class ProjectsListViewController: UIViewController, UITableViewDataSource {

    //MARK: -  Variabels
    @IBOutlet var tableView: UITableView!
    

    var fetchResultsController : NSFetchedResultsController<Project>!
    
    var dataController:DataController!
    
    /// A date formatter for date text in note cells
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    
    //MARK: -  LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFetchedResultController()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpFetchedResultController()

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchResultsController = nil
    }
    
    
    // -------------------------------------------------------------------------
    fileprivate func setUpFetchedResultController() {
        
        ///step 1: Feach Data of Project Tabel
        let fetchRequest:NSFetchRequest<Project> = Project.fetchRequest()
        ///Specify Sort
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors=[sortDescriptor]
        ///step 2
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "projects")
        /// step 3
        fetchResultsController.delegate = self
        
        ///step 4
        do{
            try fetchResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed :\(error.localizedDescription)")
        }
    }

    // MARK: - Editting
    /// Deletes the notebook at the specified index path
    func deleteProject(at indexPath: IndexPath) {
        
        let projectToDelete = fetchResultsController.object(at: indexPath)
        ///Delete from prsistance store and save changes
        dataController.viewContext.delete(projectToDelete)
        try? dataController.viewContext.save()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aProject = fetchResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        
        // Configure cell
        cell.projectName.text = aProject.name
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteProject(at: indexPath)
        default: () // Unsupported
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If this is a NotesListViewController, we'll configure its `Notebook`
        
        if let vc = segue.destination as? AddProjectViewController {
            vc.dataController=dataController
        }else  if let vc = segue.destination as? ProjectViewController {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.project = fetchResultsController.object(at: indexPath)
                vc.dataController=dataController
                
            }
        }
    }
    

}
//MARK: - Extenstion

extension ProjectsListViewController: NSFetchedResultsControllerDelegate{
    
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
