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
    
    @IBOutlet private weak var totalCostsEuroTextField: UITextField!
    @IBOutlet private weak var totalCostsCentTextField: UITextField!
    @IBOutlet private weak var pricePerLiterEuroTextField: UITextField!
    @IBOutlet private weak var pricePerLiterCentTextField: UITextField!
    @IBOutlet private weak var literAmountLiterTextField: UITextField!
    @IBOutlet private weak var literAmountCentiliterTextField: UITextField!
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
        self.textFieldList = [self.totalCostsEuroTextField, self.totalCostsCentTextField, self.pricePerLiterEuroTextField, self.pricePerLiterCentTextField, self.literAmountLiterTextField, self.literAmountCentiliterTextField, self.kilometerAmountTextField, self.noteTextField]
        
        self.datePickerDidFinish(self.datePicker)
    }
    
    func updateWithRecord(record: Record) {
        textFieldFormatter.maximumFractionDigits = 0
        
        totalCostsEuroTextField.text = textFieldFormatter.stringFromNumber(record.totalCosts)
        pricePerLiterEuroTextField.text = textFieldFormatter.stringFromNumber(record.pricePerLiter)
        literAmountLiterTextField.text = textFieldFormatter.stringFromNumber(record.fuelAmount)
        kilometerAmountTextField.text = textFieldFormatter.stringFromNumber(record.mileage)
        
        textFieldFormatter.maximumIntegerDigits = 0
        textFieldFormatter.minimumFractionDigits = 2
        textFieldFormatter.maximumFractionDigits = 2
        
        totalCostsCentTextField.text = textFieldFormatter.stringFromNumber(record.totalCosts)
        literAmountCentiliterTextField.text = textFieldFormatter.stringFromNumber(record.fuelAmount)
        
        textFieldFormatter.minimumFractionDigits = 3
        textFieldFormatter.maximumFractionDigits = 3
        
        pricePerLiterCentTextField.text = textFieldFormatter.stringFromNumber(record.pricePerLiter)
        
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
        let sTotalCosts = totalCostsEuroTextField.text! + "." + totalCostsCentTextField.text!
        let sPricePerLiter = pricePerLiterEuroTextField.text! + "." + pricePerLiterCentTextField.text!
        let sFuelAmount = literAmountLiterTextField.text! + "." + literAmountCentiliterTextField.text!
        let sMileage = kilometerAmountTextField.text!
        let note = self.noteTextField.text!
        guard let record = Record(creationDate: self.datePicker.date, totalCosts: sTotalCosts, pricePerLiter: sPricePerLiter, fuelAmount: sFuelAmount, mileage: sMileage, note: note) else {
            return
        }
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
        
        // Rejects non digits - useful if the user copy and pastes...
        let nonDigitsCharacterSet = NSCharacterSet.decimalDigitCharacterSet().invertedSet
        if let range = string.rangeOfCharacterFromSet(nonDigitsCharacterSet) where !range.isEmpty {
            return false
        }
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        
        let newLength = currentCharacterCount + string.characters.count - range.length
        
        if (textField == totalCostsEuroTextField) {
            return newLength <= 4
        } else if (textField == totalCostsCentTextField) {
            return newLength <= 2
        } else if (textField == pricePerLiterEuroTextField) {
            return newLength <= 1
        } else if (textField == pricePerLiterCentTextField) {
            return newLength <= 3
        } else if (textField == literAmountLiterTextField) {
            return newLength <= 4
        } else if (textField == literAmountCentiliterTextField) {
            return newLength <= 2
        } else if (textField == kilometerAmountTextField) {
            return newLength <= 7
        } else {
            assert(false, "unknown text field: <\(textField)>: \(textField.text)")
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
