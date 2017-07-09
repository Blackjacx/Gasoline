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
        label.backgroundColor = .red
        label.textAlignment = textAlignment
        requiredCompressionResistancyForAxis.forEach { label.setContentCompressionResistancePriority(.required, for: $0) }
        return label
    }
}

extension RefuelCell: ConfigurableCell {

    func configure(item: GenericDataSourceItem) {

        guard let item = item as? Refuel else { return }

        let date = SHDateFormatter.shared.stringFromDate(date: item.date, format: .noTimeShortDate)
        let time = SHDateFormatter.shared.stringFromDate(date: item.date, format: .shortTimeNoDate)
        let literPrice = CurrencyFormatter.shared.stringFromValue(value: item.literPrice, maximumFractionDigits: 3)
        let totalPrice = CurrencyFormatter.shared.stringFromValue(value: item.totalCosts)

        dateLabel.text = "\(date), \(time)"
        mileageLabel.text = "\(item.mileage)"
        fuelAmountLabel.text = "\(item.fuelAmount)"
        literPriceLabel.text = "\(literPrice)"
        totalPriceLabel.text = "\(totalPrice)"
        notesLabel.text = item.note ?? ""
    }
}
