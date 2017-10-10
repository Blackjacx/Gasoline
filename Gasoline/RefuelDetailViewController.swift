//
//  RefuelDetailViewController.swift
//  Gasoline
//
//  Created by Stefan Herold on 25/10/15.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

import UIKit
import SHDateFormatter
import Core

class RefuelDetailViewController: UIViewController {

    let refuelItem: Refuel?

    let totalCostsTextField = LabelledTextField()
    let pricePerLiterTextField = LabelledTextField()
    let literAmountTextField = LabelledTextField()
    let mileageTextField = LabelledTextField()
    let datePicker = LabelledDatePicker()
    let noteTextField = LabelledTextField()

    var textFieldList: [UITextField] {
        return [
            totalCostsTextField.field,
            pricePerLiterTextField.field,
            literAmountTextField.field,
            mileageTextField.field,
            noteTextField.field]
    }

    // MARK: - Lifecycle

    init(refuelItem: Refuel?) {

        self.refuelItem = refuelItem
        super.init(nibName: nil, bundle: nil)
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

        if let refuelItem = refuelItem {
            title = "\(refuelItem.date)"
        } else {
            title = "refuelDetailScreen.addItem.title".localized
        }

        applyCloseButtonStyle()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(pressedSave(_:)))

        view.backgroundColor = Colors.background

        setupDatePicker()
        setupTotalCostsTextField()
        setupPricePerLiterTextField()
        setupLiterAmountTextField()
        setupMileageTextField()
        setupNoteTextField()
        setupStack()

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

    // MARK: - Setup UI

    private func setupDatePicker() {
        if let item = refuelItem {
            datePicker.date = item.date
        }
    }

    private func setupTotalCostsTextField() {
        totalCostsTextField.text = NumberFormatting.shared.string(from: refuelItem?.totalPrice as NSDecimalNumber?)
    }

    private func setupPricePerLiterTextField() {
        pricePerLiterTextField.text = NumberFormatting.shared.string(from: refuelItem?.literPrice as NSDecimalNumber?)
    }

    private func setupLiterAmountTextField() {
        if let item = refuelItem {
            literAmountTextField.text = MeasurementFormatting.shared.string(from: item.fuelAmount, fractionDigits: 3)
        }
    }

    private func setupMileageTextField() {
        if let item = refuelItem {
            mileageTextField.text = MeasurementFormatting.shared.string(from: item.mileage, fractionDigits: 0)
        }
    }

    private func setupNoteTextField() {
        noteTextField.text = refuelItem?.note
    }

    private func setupStack() {
        let subviews = [totalCostsTextField,
                        pricePerLiterTextField,
                        literAmountTextField,
                        mileageTextField,
                        datePicker,
                        noteTextField]
        let stack = UIStackView(arrangedSubviews: subviews)
        stack.axis = .vertical
        stack.addMaximizedTo(view)
    }

    // MARK: - Actions

    @IBAction func datePickerDidFinish(_ datePicker: UIDatePicker) {
        let date = SHDateFormatter.shared.stringFromDate(date: datePicker.date, format: .noTimeShortDate)
        let time = SHDateFormatter.shared.stringFromDate(date: datePicker.date, format: .shortTimeNoDate)
        self.datePicker.title = "\(date), \(time)"
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

        globalDataBaseReference.add(item: refuel) {
            dismissViewControllerAnimated()
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

        let decimalSeparator = NumberFormatting.shared.decimalSeparator
        let decimalSet = NSMutableCharacterSet.decimalDigit()
//        decimalSet.addCharactersInString(decimalSeparator)
        let invertedSet = decimalSet.inverted

        // Update the string in the text input
        var currentString = textField.text ?? ""
        currentString = (currentString as NSString).replacingCharacters(in: range, with: string)

        guard
            let numberFromString = NumberFormatting.shared.number(from: currentString),
            let stringFromNumber = NumberFormatting.shared.string(from: numberFromString) else {
                fatalError()
        }
        currentString = stringFromNumber

        // Strip out non digits and the separator and convert to cents
        currentString = currentString.components(separatedBy: invertedSet).joined()
        let centValue = Int(currentString) ?? 0

        // get current cursor position
        let beginning = textField.beginningOfDocument
        let start = textField.position(from: beginning, offset: range.location)
        let cursorOffset = textField.offset(from: beginning, to: start!) + string.characters.count

        let decimalNumber = NSDecimalNumber(value: Double(centValue) / 100.0 as Double)
        let formattedString = NumberFormatting.shared.string(from: decimalNumber)
        textField.text = formattedString

        // Restore the cursor position
        if let newCursorPosition = textField.position(from: textField.beginningOfDocument, offset: cursorOffset) {
            let newSelectedRange = textField.textRange(from: newCursorPosition, to: newCursorPosition)
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
