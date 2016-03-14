//
//  RecordDetailViewController.swift
//  Gazz
//
//  Created by Stefan Herold on 25/10/15.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

import UIKit
import Firebase

class RecordDetailViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {
    
    // Outlets
    @IBOutlet private weak var totalCostsLabel: UILabel!
    @IBOutlet private weak var pricePerLiterLabel: UILabel!
    @IBOutlet private weak var literAmountLabel: UILabel!
    @IBOutlet private weak var kilometerAmountLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    @IBOutlet private weak var totalCostsTextField: UITextField!
    @IBOutlet private weak var pricePerLiterTextField: UITextField!
    @IBOutlet private weak var literAmountTextField: UITextField!
    @IBOutlet private weak var kilometerAmountTextField: UITextField!
    @IBOutlet private weak var noteTextField: UITextField!
    // Div
    var textFieldList: NSArray?
    var recordKey: String? {
        didSet {
            guard let recordKey = recordKey else {
                return
            }
            if let concreteRecordHandle = firebaseConcreteRecordHandle {
                firebaseConcreteRecordRef?.removeObserverWithHandle(concreteRecordHandle)
            }
            firebaseConcreteRecordRef = Firebase(url: FireBaseURL.recordKey(recordKey))
            firebaseConcreteRecordHandle = firebaseConcreteRecordRef!.observeEventType(.Value, withBlock: { snapshot in
                if let record = Record(snapshot: snapshot) {
                    self.updateWithRecord(record)
                }
            })
        }
    }
    // Private 
    private let firebaseRecordRef = Firebase(url: FireBaseURL.kRecordURL)
    private var firebaseConcreteRecordRef: Firebase?
    private var firebaseConcreteRecordHandle: UInt?
    private let decimalSeparator = NSNumberFormatter().decimalSeparator
    private lazy var textFieldFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.roundingMode = .RoundFloor
        formatter.decimalSeparator = ""
        formatter.groupingSeparator = "."
        return formatter
    }()
    
    
    deinit {
        if let concreteRecordHandle = firebaseConcreteRecordHandle {
            firebaseConcreteRecordRef?.removeObserverWithHandle(concreteRecordHandle)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldList = [totalCostsTextField, pricePerLiterTextField, literAmountTextField, kilometerAmountTextField, noteTextField]
        
        self.datePickerDidFinish(self.datePicker)
    }
    
    func updateWithRecord(record: Record) {
        textFieldFormatter.maximumFractionDigits = 0
        
        totalCostsTextField.text = textFieldFormatter.stringFromNumber(record.totalCosts)
        pricePerLiterTextField.text = textFieldFormatter.stringFromNumber(record.pricePerLiter)
        literAmountTextField.text = textFieldFormatter.stringFromNumber(record.fuelAmount)
        kilometerAmountTextField.text = textFieldFormatter.stringFromNumber(record.mileage)
        
        noteTextField.text = record.note
        datePicker.date = record.creationDate
        
        self.datePickerDidFinish(self.datePicker)
    }
    
    // MARK: - Actions
    
    @IBAction func datePickerDidFinish(datePicker: UIDatePicker) {
        self.dateLabel?.text = FLCDateFormatter.stringFromDate(self.datePicker.date, usingFormat: FLCDateFormat.ShortTime_ShortDate)
    }
    
    @IBAction func pressedBackground(gr: UITapGestureRecognizer) {
        self.hideKeyboard()
    }
    
    @IBAction func pressedSave(sender: AnyObject) {
        let totalCosts = NSDecimalNumber(string: totalCostsTextField.text!)
        let pricePerLiter = NSDecimalNumber(string: pricePerLiterTextField.text!)
        let fuelAmount = NSDecimalNumber(string: literAmountTextField.text!)
        let mileage = Int(kilometerAmountTextField.text!) ?? 0
        let note = self.noteTextField.text ?? ""

        let record = Record(creationDate: self.datePicker.date, totalCosts: totalCosts, pricePerLiter: pricePerLiter, fuelAmount: fuelAmount, mileage: mileage, note: note)
        let recordRef = self.firebaseRecordRef.childByAutoId()
        recordRef.setValue(record.toAnyObject(), withCompletionBlock: { (error, firebaseRef) -> Void in
            self.performSegueWithIdentifier(R.segue.recordDetailViewController.unwindToRecordList, sender: self)
        })
    }
    
    @IBAction func textFieldEditingChanged(textField: UITextField) {
//        if (textField == totalCostsEuroTextField) {
//            return newLength <= 4
//            textField.text = textFieldFormatter.string
//        } else if (textField == totalCostsCentTextField) {
//            return newLength <= 2
//        } else if (textField == pricePerLiterEuroTextField) {
//            return newLength <= 1
//        } else if (textField == pricePerLiterCentTextField) {
//            return newLength <= 3
//        } else if (textField == literAmountLiterTextField) {
//            return newLength <= 4
//        } else if (textField == literAmountCentiliterTextField) {
//            return newLength <= 2
//        } else if (textField == kilometerAmountTextField) {
//            return newLength <= 7
//        } else if (textField == noteTextField) {
//        } else {
//            assert(false, "unknown text field: <\(textField)>: \(textField.text)")
//        }
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let tfList = self.textFieldList!
        let idx = tfList.indexOfObject(textField)
        
        // Dismiss the keyboard
        if idx != NSNotFound {
            if idx == tfList.count-1 {
                textField.resignFirstResponder()
            } else if idx < tfList.count-1 {
                tfList.objectAtIndex(idx+1).becomeFirstResponder()
            }
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == noteTextField) {
            return true
        }
        
        let tfText = textField.text ?? ""
        
        // Rejects non digits - useful if the user copy and pastes...
        let decimalSet = NSMutableCharacterSet.decimalDigitCharacterSet()
        decimalSet.addCharactersInString(decimalSeparator)
        let invertedDecimalSet = decimalSet.invertedSet
        if let range = string.rangeOfCharacterFromSet(invertedDecimalSet) where !range.isEmpty {
            return false
        }
        
        // Only one decimal separator is permitted
        if (string.containsString(decimalSeparator) && tfText.containsString(decimalSeparator)) {
            return false
        }
        
        let currentCharacterCount = tfText.characters.count
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        
        // Cnstain the number of characters entered by the user
        let newLength = currentCharacterCount + string.characters.count - range.length
        if (textField == totalCostsTextField) {
            return newLength <= 7
        } else if (textField == pricePerLiterTextField) {
            return newLength <= 5
        } else if (textField == literAmountTextField) {
            return newLength <= 7
        } else if (textField == kilometerAmountTextField) {
            return newLength <= 7
        } else {
            assert(false, "unknown text field: <\(textField)>: \(tfText)")
            return false
        }
    }
    
    
    // MARK: - Helper
    
    func hideKeyboard() {
        for textField in self.textFieldList! {
            textField.resignFirstResponder()
        }
    }
}
