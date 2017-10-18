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

    var refuelItem: Refuel? {
        didSet {
            guard let item = refuelItem else { return }
            item.
        }
    }

    let totalCosts = LabeledTextField()
    let pricePerFuelUnit = LabeledTextField()
    let fuelAmount = LabeledTextField()
    let mileage = LabeledTextField()
    let datePicker = LabeledDatePicker()
    let notes = LabeledTextField()

    var textFieldList: [UITextField] {
        return [
            totalCosts.textField,
            pricePerFuelUnit.textField,
            fuelAmount.textField,
            mileage.textField,
            notes.textField]
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
        setupPricePerFuelUnitTextField()
        setupFuelAmountTextField()
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

    private func setupDatePicker() {
        datePicker.title = "refuelDetailScreen.datePicker.title".localized
    }

    private func setupTotalCostsTextField() {
        let formatter = CurrencyFormatter.shared
        totalCosts.title = "refuelDetailScreen.totalCostsTextField.title".localized
        totalCosts.placeholder = formatter.stringFromValue(value: 39.99, currencyCode: formatter.currencyCode)
        totalCosts.textField.keyboardType = .numberPad
    }

    private func setupPricePerFuelUnitTextField() {
        let formatter = CurrencyFormatter.shared
        pricePerFuelUnit.title = "refuelDetailScreen.pricePerFuelUnitTextField.title".localized
        pricePerFuelUnit.placeholder = formatter.stringFromValue(value: 1.299, currencyCode: formatter.currencyCode, fractionDigits: 3)
        pricePerFuelUnit.textField.keyboardType = .numberPad
    }

    private func setupFuelAmountTextField() {
        fuelAmount.title = "refuelDetailScreen.fuelAmountTextField.title".localized
        fuelAmount.placeholder = MeasurementFormatting.shared.string(from: Measurement(value: 33.13, unit: UnitVolume.liters),
                                                                     fractionDigits: 2)
        fuelAmount.textField.keyboardType = .numberPad
    }

    private func setupMileageTextField() {
        mileage.title = "refuelDetailScreen.mileageTextField.title".localized
        mileage.placeholder = MeasurementFormatting.shared.string(from: Measurement(value: 135000, unit: UnitLength.kilometers),
                                                                  fractionDigits: 0)
        mileage.textField.keyboardType = .numberPad
    }

    private func setupNoteTextField() {
        notes.title = "refuelDetailScreen.noteTextField.title".localized
        notes.placeholder = "refuelDetailScreen.noteTextField.title".localized
    }

    private func setupStack() {
        let subviews = [totalCosts, pricePerFuelUnit, fuelAmount, mileage, notes, datePicker, UIView()]
        let stack = UIStackView(arrangedSubviews: subviews)
        stack.axis = .vertical
        stack.spacing = Constants.UI.rasterSize
        stack.addMaximizedTo(view, margins: Constants.UI.defaultInsets)
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

        guard let priceText = pricePerFuelUnit.text else {
            return
        }

        guard let price = Double(priceText), price > 0.0 else {
            return
        }

        guard let literAmountText = fuelAmount.text else {
            return
        }

        guard let literAmount = Double(literAmountText), literAmount > 0 else {
            return
        }

        guard let mileageText = mileage.text else {
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
            note: notes.text)

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

        if textField == notes { return true }

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
        if textField == totalCosts {
            return newLength <= 7
        } else if textField == pricePerFuelUnit {
            return newLength <= 5
        } else if textField == fuelAmount {
            return newLength <= 7
        } else if textField == mileage {
            return newLength <= 7
        } else {
            fatalError("unknown text field: <\(textField)>: \(currentString)")
        }
    }
}
