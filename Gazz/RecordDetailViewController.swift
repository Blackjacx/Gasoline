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
    
    enum Tag: Int {
        case AlertViewSaveConfirmation = 1
    }
    
    // Outlets
    @IBOutlet weak var totalCostsLabel: UILabel!
    @IBOutlet weak var pricePerLiterLabel: UILabel!
    @IBOutlet weak var literAmountLabel: UILabel!
    @IBOutlet weak var kilometerAmountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var totalCostsEuroTextField: UITextField!
    @IBOutlet weak var totalCostsCentTextField: UITextField!
    @IBOutlet weak var pricePerLiterEuroTextField: UITextField!
    @IBOutlet weak var pricePerLiterCentTextField: UITextField!
    @IBOutlet weak var literAmountLiterTextField: UITextField!
    @IBOutlet weak var literAmountCentiliterTextField: UITextField!
    @IBOutlet weak var kilometerAmountTextField: UITextField!
    // Div
    var textFieldList: NSArray?
    var recordKey: String?
    var isEditMode: Bool = false {
        didSet {
            
        }
    }
    // Private 
    private let firebaseRecordRef = Firebase(url: FireBaseURL.kRecordURL)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldList = [self.totalCostsEuroTextField!, self.totalCostsCentTextField!, self.pricePerLiterEuroTextField!, self.pricePerLiterCentTextField!, self.literAmountLiterTextField!, self.literAmountCentiliterTextField!, self.kilometerAmountTextField!]
        
        self.datePicker?.maximumDate = NSDate()
        self.datePickerDidFinish(self.datePicker!)
    }
    
    
    // MARK: - Actions
    
    @IBAction func datePickerDidFinish(datePicker: UIDatePicker) {
        self.dateLabel?.text = FLCDateFormatter.stringFromDate(self.datePicker.date, usingFormat: FLCDateFormat.ShortTime_ShortDate)
    }
    
    @IBAction func pressedBackground(gr: UITapGestureRecognizer) {
        self.hideKeyboard()
    }
    
    @IBAction func pressedSave(sender: AnyObject) {
        let sTotalCosts = (self.totalCostsEuroTextField?.text)! + "." + (self.totalCostsCentTextField?.text)!
        let sPricePerLiter = (self.pricePerLiterEuroTextField?.text)! + "." + (self.pricePerLiterCentTextField?.text)!
        let sFuelAmount = (self.literAmountLiterTextField?.text)! + "." + (self.literAmountCentiliterTextField?.text)!
        let sMileage = (self.kilometerAmountTextField?.text)!
        guard let record = Record(creationDate: self.datePicker.date, totalCosts: sTotalCosts, pricePerLiter: sPricePerLiter, fuelAmount: sFuelAmount, mileage: sMileage) else {
            return
        }
        let recordRef = self.firebaseRecordRef.childByAutoId()
        recordRef.setValue(record.toAnyObject(), withCompletionBlock: { (error, firebaseRef) -> Void in
            self.performSegueWithIdentifier(R.segue.recordDetailViewController.unwindToRecordList, sender: self)
        })
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
