//
//  CreateGazzEntryViewController.swift
//  Gazz
//
//  Created by Stefan Herold on 25/10/15.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//


// TODO: Start implementing everything in Swift

// TODO: Save the date with a standardized time 12:00 afternoon
// TODO: Implement input checking using shouldChangeCharactersInRange
// TODO: Display of all records in a list
// TODO: Make the record list editable

// TODO: Taking Picture of the bill
// TODO: Localize all strings
// TODO: Use a scroll view to display the content
// TODO: Convert Pictures to b&w images to save space
// TODO: Offer to crop image to save space
// TODO: Migrate to core data
// TODO: OCR mileage in the car via camera

// TODO: put a next/done button on the num keypad
// TODO: Make fonts dark gray: 30, 60, ...
// TODO: Realize rows as table cells
// TODO: Realize Datepicker as seperate View and show it from below on button press.
// TODO: Check the Date 22:00 after changing dateii
// TODO: Integrate an advanced date formatter class
// TODO: Make a replacement for NSUsewrdefaults that stores all frefixes all keys



import UIKit

class CreateGazzEntryViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {

    struct UserDefaultsKeys {
        static let RecordList = "kGazzUserDefaultsRecordList"
        static let RecordDictionaryItemId = "RecordDictionaryItemId"
        static let RecordDictionaryItemDate = "RecordDictionaryItemDate"
        static let RecordDictionaryItemTotalCosts = "RecordDictionaryItemTotalCosts"
        static let RecordDictionaryItemPricePerLiter = "RecordDictionaryItemPricePerLiter"
        static let RecordDictionaryItemLiterAmount = "RecordDictionaryItemLiterAmount"
        static let RecordDictionaryItemKilometer = "RecordDictionaryItemKilometer"
    }
    
    enum Tag: Int {
        case AlertViewSaveConfirmation = 1
    }
    
    // Outlets
    @IBOutlet weak var totalCostsLabel: UILabel?
    @IBOutlet weak var pricePerLiterLabel: UILabel?
    @IBOutlet weak var literAmountLabel: UILabel?
    @IBOutlet weak var kilometerAmountLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var datePicker: UIDatePicker?
    @IBOutlet weak var totalCostsEuroTextField: UITextField?
    @IBOutlet weak var totalCostsCentTextField: UITextField?
    @IBOutlet weak var pricePerLiterEuroTextField: UITextField?
    @IBOutlet weak var pricePerLiterCentTextField: UITextField?
    @IBOutlet weak var literAmountLiterTextField: UITextField?
    @IBOutlet weak var literAmountCentiliterTextField: UITextField?
    @IBOutlet weak var kilometerAmountTextField: UITextField?
    // Div
    var textFieldList: NSArray?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldList = [self.totalCostsEuroTextField!, self.totalCostsCentTextField!, self.pricePerLiterEuroTextField!, self.pricePerLiterCentTextField!, self.literAmountLiterTextField!, self.literAmountCentiliterTextField!, self.kilometerAmountTextField!]
        
        self.datePicker?.maximumDate = NSDate()
        self.datePickerDidFinish(self.datePicker!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - Actions
    
    @IBAction func datePickerDidFinish(datePicker: UIDatePicker) {
        self.dateLabel?.text = "\(datePicker.date) \(self.recordCount())"
    }
    
    @IBAction func onBackgroundTap(gr: UITapGestureRecognizer) {
        self.hideKeyboard()
    }
    
    @IBAction func onSave(sender: UIButton) {
        let alert = UIAlertView(title:NSLocalizedString("gz.createEntryViewController.saveAlert.title", comment:"Title of the alert view where users can confirm saving of the current entry."), message: NSLocalizedString("gz.createEntryViewController.saveAlert.message", comment:"Message of the alert view where users can confirm saving of the current entry."), delegate: self, cancelButtonTitle: NSLocalizedString("gz.general.noButton.title", comment:"No button text"), otherButtonTitles: NSLocalizedString("gz.general.yesButton.title", comment:"Yes button text"))
        alert.tag = Tag.AlertViewSaveConfirmation.rawValue
        alert.show()
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
        return true
    }
    
    
    // MARK: - UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        
        switch Tag(rawValue: alertView.tag) {
        case .Some(.AlertViewSaveConfirmation):
            if alertView.cancelButtonIndex != buttonIndex {
                self.performSave()
            }
        default: break
        }
    }
    
    
    // MARK: - Saving Entries
    
    func performSave() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let dataRecordList = NSMutableArray(array: defaults.objectForKey(UserDefaultsKeys.RecordList) as! NSArray)
        let newData = NSMutableDictionary()
        newData[UserDefaultsKeys.RecordDictionaryItemId] = NSUUID().UUIDString
        newData[UserDefaultsKeys.RecordDictionaryItemDate] = self.datePicker?.date
        newData[UserDefaultsKeys.RecordDictionaryItemTotalCosts] = (self.totalCostsEuroTextField?.text)! + "." + (self.totalCostsCentTextField?.text)!
        newData[UserDefaultsKeys.RecordDictionaryItemPricePerLiter] = (self.pricePerLiterEuroTextField?.text)! + "." + (self.pricePerLiterCentTextField?.text)!
        newData[UserDefaultsKeys.RecordDictionaryItemLiterAmount] = (self.literAmountLiterTextField?.text)! + "." + (self.literAmountCentiliterTextField?.text)!
        newData[UserDefaultsKeys.RecordDictionaryItemKilometer] = self.kilometerAmountTextField?.text

        dataRecordList.addObject(newData)
        defaults.setValue(dataRecordList, forKey: UserDefaultsKeys.RecordList)
        defaults.synchronize()
        
        self.datePickerDidFinish(self.datePicker!)
    }
    
    
    // MARK: - Helper
    
    func hideKeyboard() {
        for textField in self.textFieldList! {
            textField.resignFirstResponder()
        }
    }
    
    func recordCount() -> Int? {
        return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultsKeys.RecordList)?.count
    }
}
