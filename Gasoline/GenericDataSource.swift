//
//  GenericDataSource.swift
//  Gasoline
//
//  Created by Stefan Herold on 02.07.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit

protocol GenericDataSourceItem {

    var cellId: String {get}
    var classType: AnyClass {get}
    var selectionHandler: (() -> UIViewController)? {get}
    var isEditable: Bool {get}
}

protocol ConfigurableCell {

    func configure(item: GenericDataSourceItem)
}

class GenericDataSource: NSObject {

    var items: [GenericDataSourceItem] = [] {

        didSet {

            dataSourceDidChangeHandler?(self)
        }
    }

    var dataSourceDidChangeHandler: ((_ dataSource: GenericDataSource) -> ())?
}

extension GenericDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = items[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: item.cellId, for: indexPath)
        cell.selectionStyle = item.selectionHandler == nil ? .none : .default

        if let configurableCell = cell as? ConfigurableCell {
            configurableCell.configure(item: item)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        let item = items[indexPath.row]
        return item.isEditable
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        switch editingStyle {
        case .delete:
            items.remove(at: indexPath.row)
        case .insert:
            break
        case .none:
            break
        }
    }
}
