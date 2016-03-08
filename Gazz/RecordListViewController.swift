//
//  ItemListViewController.swift
//  Gazz
//
//  Created by Stefan Herold on 08/03/16.
//  Copyright © 2016 Stefan Herold. All rights reserved.
//

import UIKit
import Firebase
import Rswift

class RecordListViewController: UITableViewController {

    // MARK: Properties
    private var records = [Record]()
    private let firebaseRecordRef = Firebase(url: FireBaseURL.kRecordURL)
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up swipe to delete
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        firebaseRecordRef.queryOrderedByChild(Record.JSON.creationDate).observeEventType(.Value, withBlock: { snapshot in
            var newRecord = [Record]()
            let childrenReversed = snapshot.children.reverse()
            for recordDataSnapshot in childrenReversed {
                if let record = Record(snapshot: recordDataSnapshot as! FDataSnapshot) {
                    newRecord.append(record)
                }
            }
            self.records = newRecord
            self.tableView.reloadData()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == R.segue.recordListViewController.showRecordDetailViewController.identifier) {
            let recordDetailViewController = segue.destinationViewController as! RecordDetailViewController
            
            if let indexPath = sender as? NSIndexPath {
                // A table cell has been selected
                let record = records[indexPath.row]
                recordDetailViewController.recordKey = record.key
                recordDetailViewController.isEditMode = true
            } else {
                // The add button has been pressed
            }
        }
    }
    
    @IBAction func unwindToRecordList(segue: UIStoryboardSegue) {
        
    }
    
    
    // MARK: UITableView Delegate methods
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(Value.kDefaultRasterSize * 5.0)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.recordListCell, forIndexPath: indexPath)
        let record = records[indexPath.row]
        
        cell!.textLabel?.text = String(format: NSLocalizedString("gz.recordListViewController.listCellTitle.format", comment:"Title format of the cells displaying a record."), record.fuelAmount, record.totalCosts)
        cell!.detailTextLabel?.text = FLCDateFormatter.stringFromDate(record.creationDate, usingFormat: FLCDateFormat.ShortTime_ShortDate)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let record = records[indexPath.row]
            record.ref?.removeValue()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(R.segue.recordListViewController.showRecordDetailViewController, sender: indexPath)
    }
    
    
    // MARK: Add Item
    
    @IBAction func pressedAddButton(sender: AnyObject) {
        performSegueWithIdentifier(R.segue.recordListViewController.showRecordDetailViewController, sender: sender)
    }
}
