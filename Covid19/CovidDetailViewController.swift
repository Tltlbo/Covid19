//
//  CovidDetailViewController.swift
//  Covid19
//
//  Created by 박진성 on 2023/07/28.
//

import UIKit

class CovidDetailViewController: UITableViewController {
    
    
    @IBOutlet weak var newCaseCell: UITableViewCell!
    @IBOutlet weak var totalCaseCell: UITableViewCell!
    @IBOutlet weak var recoveredCell: UITableViewCell!
    @IBOutlet weak var deathCell: UITableViewCell!
    @IBOutlet weak var percentageCell: UITableViewCell!
    @IBOutlet weak var overseasInflowCell: UITableViewCell!
    @IBOutlet weak var regionalOutbreakCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}