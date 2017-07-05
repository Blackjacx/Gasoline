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

    let dateLabel = RefuelCell.label(withTextAlignment: .right)
    let mileageLabel = RefuelCell.label(withTextAlignment: .left)
    let fuelAmountLabel = RefuelCell.label(withTextAlignment: .left)
    let literPriceLabel = RefuelCell.label(withTextAlignment: .center)
    let totalPriceLabel = RefuelCell.label(withTextAlignment: .right)
    let notesLabel = RefuelCell.label(withTextAlignment: .left)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let topStack = UIStackView()
        topStack.addArrangedSubview(mileageLabel)
        topStack.addArrangedSubview(dateLabel)

        let middleStack = UIStackView()
        middleStack.distribution = .equalCentering
        middleStack.addArrangedSubview(fuelAmountLabel)
        middleStack.addArrangedSubview(literPriceLabel)
        middleStack.addArrangedSubview(totalPriceLabel)

        let bottomStack = UIStackView()
        bottomStack.addArrangedSubview(notesLabel)

        let margin = Constants.rasterSize
        let verticalStackMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        let verticalStack = UIStackView(arrangedSubviews: [topStack, middleStack, bottomStack])
        verticalStack.axis = .vertical
        verticalStack.addMaximizedTo(contentView, margins: verticalStackMargins)
    }

    @available(*, unavailable, message:"init(coder:) has not been implemented")
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Creating Labels

    static func label(withTextAlignment textAlignment: NSTextAlignment) -> UILabel {

        let label = UILabel()
        label.textAlignment = textAlignment
        return label
    }
}

extension RefuelCell: ConfigurableCell {

    func configure(item: GenericDataSourceItem) {

        guard let item = item as? Refuel else { return }

        let date = SHDateFormatter.sharedInstance.stringFromDate(date: item.date, format: .noTimeShortDate)
        let time = SHDateFormatter.sharedInstance.stringFromDate(date: item.date, format: .shortTimeNoDate)
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
