//
//  MasterDataSource.swift
//  Proximity Reminders App
//
//  Created by Brandon Mahoney on 7/3/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class MasterVCDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let tableView: UITableView
    private let context: NSManagedObjectContext
    private let tableVC: MasterViewController
    
    lazy var fetchedResultsController: ReminderFetchedResultsController = {
        return ReminderFetchedResultsController(managedObjectContext: self.context, predicate: nil, tableView: self.tableView)
    }()
    
    //Initialize tableView for MasterViewController
    init(tableVC: MasterViewController) {
        self.tableView = tableVC.tableView
        self.context = tableVC.managedObjectContext
        self.tableVC = tableVC
    }
    
    // MARK: - Table view datasource/delegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        
        if section.numberOfObjects == 0 {
            self.tableView.setEmptyView(title: "You haven't created any reminders.", message: "Tap the '+' to get started!")
        } else {
            self.tableView.restore()
        }
        
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCell
        let reminder = fetchedResultsController.object(at: indexPath)
        cell.configure(with: reminder)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let reminder = fetchedResultsController.object(at: indexPath)
        
        //Remove monitored region
        print("\nmonitoredRegions before deletion: \(self.tableVC.locationManager.monitoredRegions.count)")
        self.tableVC.locationManager.stopMonitoring(for: reminder.geofenceCircularRegion!)
        print("monitoredRegions after deletion: \(self.tableVC.locationManager.monitoredRegions.count)\n")
        
        //Remove reminder from CoreData
        context.delete(reminder)
        context.saveChanges()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedReminder = fetchedResultsController.object(at: indexPath)
        self.tableVC.delegate?.reminderSelected(selectedReminder, with: self.tableVC.managedObjectContext)
        if let detailViewController = self.tableVC.delegate as? DetailViewController,
            let detailNavigationController = detailViewController.navigationController {
            self.tableVC.splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
    
}
