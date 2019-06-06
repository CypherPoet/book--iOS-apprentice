//
//  AddChecklistViewController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/5/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class AddChecklistViewController: UITableViewController {
    
    var checklist: ChecklistItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}


// MARK: - Navigation

extension AddChecklistViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: Handle unwind
    }

}


// MARK: - UITableViewDelegate

extension AddChecklistViewController {

}
