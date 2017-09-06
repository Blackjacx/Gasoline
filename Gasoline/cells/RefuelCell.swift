//
//  RefuelCell.swift
//  Gasoline
//
//  Created by Stefan Herold on 14/03/16.
//  Copyright © 2016 Stefan Herold. All rights reserved.
//

import UIKit
import SHDateFormatter

class RefuelCell: UITableViewCell {

    let dateLabel = RefuelCell.label(withTextAlignment: .left, requiredCompressionResistancyForAxis: [.horizontal])
    let mileageLabel = RefuelCell.label(withTextAlignment: .right)
    let fuelAmountLabel = RefuelCell.label(withTextAlignment: .right)
    let literPriceLabel = RefuelCell.label(withTextAlignment: .right)
    let totalPriceLabel = RefuelCell.label(withTextAlignment: .right)
    let notesLabel = RefuelCell.label(withTextAlignment: .left)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let margin = Constants.rasterSize
        let parentStackMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)

        let verticalStack = UIStackView(arrangedSubviews: [totalPriceLabel, mileageLabel, literPriceLabel, fuelAmountLabel, notesLabel])
        verticalStack.axis = .vertical

        let horizontalStack = UIStackView(arrangedSubviews: [dateLabel, verticalStack])
        horizontalStack.addMaximizedTo(contentView, margins: parentStackMargins)
    }

    @available(*, unavailable, message:"init(coder:) has not been implemented")
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Creating Labels

    static func label(
        withTextAlignment textAlignment: NSTextAlignment,
        requiredCompressionResistancyForAxis: [UILayoutConstraintAxis] = []) -> UILabel {

        let label = UILabel()
        label.textAlignment = textAlignment
        requiredCompressionResistancyForAxis.forEach { label.setContentCompressionResistancePriority(.required, for: $0) }
        return label
    }
}

extension RefuelCell: ConfigurableCell {

    func configure(item: GenericDataSourceItem) {

        guard let item = item as? Refuel else { return }
        let dateFormatter = SHDateFormatter.shared
        let measurementFormatter = MeasurementFormatting.shared
        let currencyFormatter = CurrencyFormatter.shared

        let date = dateFormatter.stringFromDate(date: item.date, format: .noTimeRelativeDate)
        let time = dateFormatter.stringFromDate(date: item.date, format: .shortTimeNoDate)
        let mileage = measurementFormatter.stringFrom(measurement: item.mileage, fractionDigits: 0)
        let fuelAmount = measurementFormatter.stringFrom(measurement: item.fuelAmount, fractionDigits: 2)
        let note = item.note ?? ""
        let totalPrice = currencyFormatter.stringFromValue(value: item.totalPrice, currencyCode: item.currencyCode)
        let literPrice = currencyFormatter.stringFromValue(value: item.literPrice, currencyCode: item.currencyCode, fractionDigits: 3)

        dateLabel.attributedText = FontStyle.headline.normalStyleAttributedString("\(date), \(time)")
        totalPriceLabel.attributedText = FontStyle.title1.normalStyleAttributedString(totalPrice)
        literPriceLabel.attributedText = FontStyle.body.lightStyleAttributedString(literPrice)
        mileageLabel.attributedText = FontStyle.body.lightStyleAttributedString("\(mileage)")
        fuelAmountLabel.attributedText = FontStyle.body.lightStyleAttributedString("\(fuelAmount)")
        notesLabel.attributedText = FontStyle.body.lightStyleAttributedString(note)
    }
}
