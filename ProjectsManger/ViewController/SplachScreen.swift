//
//  SplachScreen.swift
//  ProjectsManger
//
//  Created by Raghad alfuhaid on 20/08/1442 AH.
//

import Foundation
import UIKit
class SplachScreen: UIViewController{
//    var window: UIWindow?
    var dataController:DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
    }
    
    

    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If this is a NotesListViewController, we'll configure its `Notebook`
     
        if let vc = segue.destination as? ProjectsListViewController {
            vc.dataController=dataController
        }
        
        

    }

    
}
