//
//  RefuelDetailViewController.swift
//  Gasoline
//
//  Created by Stefan Herold on 25/10/15.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

import UIKit
import SHDateFormatter

class RefuelDetailViewController: UIViewController {

    let totalCostsLabel = UILabel()
    let pricePerLiterLabel = UILabel()
    let literAmountLabel = UILabel()
    let kilometerAmountLabel = UILabel()
    let dateLabel = UILabel()
    let datePicker = UIDatePicker()

    let totalCostsTextField = UITextField()
    let pricePerLiterTextField = UITextField()
    let literAmountTextField = UITextField()
    let mileageTextField = UITextField()
    let noteTextField = UITextField()

    var textFieldList: [UITextField] {
        return [
            totalCostsTextField,
            pricePerLiterTextField,
            literAmountTextField,
            mileageTextField,
            noteTextField]
    }

    var measurementFormatter: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        return formatter
    }

    private lazy var textFieldFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private var decimalSeparator: String {
        return textFieldFormatter.decimalSeparator
    }

    init(refuelItem: Refuel) {
        super.init(nibName: nil, bundle: nil)

        totalCostsTextField.text = textFieldFormatter.string(from: refuelItem.totalPrice as NSDecimalNumber)
        pricePerLiterTextField.text = textFieldFormatter.string(from: refuelItem.literPrice as NSDecimalNumber)
        literAmountTextField.text = measurementFormatter.string(from: refuelItem.fuelAmount)
        mileageTextField.text = measurementFormatter.string(from: refuelItem.mileage)

        noteTextField.text = refuelItem.note
        datePicker.date = refuelItem.date
    }

    @available(*, unavailable, message:"init() has not been implemented")
    init() {
        fatalError()
    }

    @available(*, unavailable, message: "init(nibName: , bundle:) has not been implemented")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }

    @available(*, unavailable, message:"init(coder:) has not been implemented")
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        for textField in textFieldList {
            if textField.keyboardType == .decimalPad || textField.keyboardType == .numberPad {
//                UIView.pcl_attachButtonToolbar(
//                    to: textField,
//                    title: NSLocalizedString("fli.recordDetails.numpadKeyboardAccessoryNextButon.title", comment: ""),
//                    target: self,
//                    action: #selector(RecordDetailViewController.textFieldShouldReturnHelper))
            }
        }
    }

    // MARK: - Actions

    @IBAction func datePickerDidFinish(_ datePicker: UIDatePicker) {
        let date = SHDateFormatter.shared.stringFromDate(date: datePicker.date, format: .noTimeShortDate)
        let time = SHDateFormatter.shared.stringFromDate(date: datePicker.date, format: .shortTimeNoDate)
        dateLabel.text = "\(date), \(time)"
    }

    @IBAction func pressedBackground(_ gr: UITapGestureRecognizer) {

        hideKeyboard(forControls: textFieldList)
    }

    @IBAction func pressedSave(_ sender: AnyObject) {

        guard let priceText = pricePerLiterTextField.text else {
            return
        }

        guard let price = Double(priceText), price > 0.0 else {
            return
        }

        guard let literAmountText = literAmountTextField.text else {
            return
        }

        guard let literAmount = Double(literAmountText), literAmount > 0 else {
            return
        }

        guard let mileageText = mileageTextField.text else {
            return
        }

        guard let mileage = Double(mileageText), mileage > 0 else {
            return
        }

        let refuel = Refuel(
            date: datePicker.date,
            literPrice: Decimal(price),
            fuelAmount: Measurement(value: literAmount, unit: UnitVolume.liters),
            mileage: Measurement(value: mileage, unit: UnitLength.kilometers),
            note: noteTextField.text)

        globalDataBaseReference.add(item: refuel) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Keyboard Mgmt

    func hideKeyboard(forControls controls: [UIControl]) {
        for control in controls {
            control.resignFirstResponder()
        }
    }
}

extension RefuelDetailViewController: UITextFieldDelegate {

    func textFieldShouldReturnHelper() -> Bool {
        for (idx, tf) in textFieldList.enumerated() {
            if !tf.isFirstResponder {
                continue
            }
            if idx == textFieldList.count - 1 {
                tf.resignFirstResponder()
                break
            } else if idx < textFieldList.count - 1 {
                textFieldList[idx + 1].becomeFirstResponder()
                break
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textFieldShouldReturnHelper()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == noteTextField { return true }

        let decimalSet = NSMutableCharacterSet.decimalDigit()
//        decimalSet.addCharactersInString(decimalSeparator)
        let invertedSet = decimalSet.inverted

        // Update the string in the text input
        var currentString = textField.text ?? ""
        currentString = (currentString as NSString).replacingCharacters(in: range, with: string)

        guard
            let numberFromString = textFieldFormatter.number(from: currentString),
            let stringFromNumber = textFieldFormatter.string(from: numberFromString) else {
                fatalError()
        }
        currentString = stringFromNumber

        // Strip out non digits and the separator and convert to cents
        currentString = currentString.components(separatedBy: invertedSet).joined()
        let centValue = Int(currentString) ?? 0

        // get current cursor position
        let beginning = textField.beginningOfDocument
        let start = textField.position(from: beginning, offset:range.location)
        let cursorOffset = textField.offset(from: beginning, to:start!) + string.characters.count

        let decimalNumber = NSDecimalNumber(value: Double(centValue) / 100.0 as Double)
        let formattedString = textFieldFormatter.string(from: decimalNumber)
        textField.text = formattedString

        // Restore the cursor position
        if let newCursorPosition = textField.position(from: textField.beginningOfDocument, offset:cursorOffset) {
            let newSelectedRange = textField.textRange(from: newCursorPosition, to:newCursorPosition)
            textField.selectedTextRange = newSelectedRange
        }

        // Rejects all values that are not digits or the decimal separator
        //        let decimalSet = NSMutableCharacterSet.decimalDigitCharacterSet()
        decimalSet.addCharacters(in: decimalSeparator)
        let invertedDecimalSet = decimalSet.inverted
        if let range = string.rangeOfCharacter(from: invertedDecimalSet), !range.isEmpty {
            return false
        }

        // Only one decimal separator is permitted
        if string.contains(decimalSeparator) && currentString.contains(decimalSeparator) {
            return false
        }

        let currentCharacterCount = currentString.characters.count
        if range.length + range.location > currentCharacterCount {
            return false
        }

        // Cnstain the number of characters entered by the user
        let newLength = currentCharacterCount + string.characters.count - range.length
        if textField == totalCostsTextField {
            return newLength <= 7
        } else if textField == pricePerLiterTextField {
            return newLength <= 5
        } else if textField == literAmountTextField {
            return newLength <= 7
        } else if textField == mileageTextField {
            return newLength <= 7
        } else {
            fatalError("unknown text field: <\(textField)>: \(currentString)")
        }
    }
}
