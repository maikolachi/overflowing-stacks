//
//  MasterViewController.swift
//  Overflowing Stacks
//
//  Created by Faisal Bhombal on 1/15/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
//    @IBOutlet weak var durationButton: UIButton!
    let viewModel = MasterViewViewModel()
    
    @IBOutlet weak var countDisplay: UILabel!
    @IBOutlet weak var durationDisplay: UIBarButtonItem!
    
    var isRetrieveCancelled = false
    
    var duration: Int = 4
    var allQuestions = [SOVFQuestionDataModel]()
    
    var maxQuota = 0
    var remainingQuota = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ds = Registrator.shared.value(forKey: .duration)
        self.durationDisplay.title = ds
//        self.durationDisplay.title = ds
        self.duration = ds.hours
        
        // Do any additional setup after loading the view.
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    func refresh() {
        
        self.viewModel.cancelled = true
        
        let end = Int(Date().timeIntervalSince1970)
        let start = end - self.duration * 3600
        
        self.allQuestions.removeAll()
        self.viewModel.fetchRecentQuestions(startEpoch: start, endEpoch: end) { (questions, hasMore, quotaMax, quotaRemaining, isCancelled, error) in
            
            if let error = error {
                let alert = UIAlertController(title: "Retrieve Error", message: "Error retrieving questions from Stack Overflow: \(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            } else if let questions = questions {
                
                // As questions are received, display them - one page at a time is retrieved
                self.maxQuota = quotaMax
                self.remainingQuota = quotaRemaining
                
                self.allQuestions.append(contentsOf: questions)
                
                DispatchQueue.main.async {
                    self.countDisplay.text = "\(self.allQuestions.count) questions" + (isCancelled ? " (STOPPED)" : "")
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to-detail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = allQuestions[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
            }
        } else if segue.identifier == "to-settings" {
            guard let vc = segue.destination as? SettingsViewController else {
                return
            }
            vc.quotaMax = self.maxQuota
            vc.quotaRemaining = self.remainingQuota
        }
    }
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue) {
        
        
        
    }
    
    @IBAction func unwindToHomeWithCancel(segue:UIStoryboardSegue) {
        
    }
    @IBAction func doRefresh(_ sender: UIBarButtonItem) {
        self.refresh()
    }
}

extension MasterViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        let sectionInfo = fetchedResultsController.sections![section]
        //        return sectionInfo.numberOfObjects
        return self.allQuestions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detail-cell", for: indexPath) as! MasterTableViewCell
        
        let row = allQuestions[indexPath.row]
        cell.titleLabel.text = row.title
        cell.answerCountLabel.text = "\(row.answerCount)"
        
        return cell
    }
    
    
    func configureCell(_ cell: UITableViewCell, withEvent event: Event) {
        cell.textLabel!.text = event.timestamp!.description
    }
}
