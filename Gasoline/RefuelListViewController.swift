//
//  RefuelListViewController.swift
//  Gasoline
//
//  Created by Stefan Herold on 02.07.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit

class RefuelListViewController: UIViewController {

    let dataSource = GenericDataSource()
    private(set) var refuelItems: [Refuel] = []

    private(set) lazy var tableView: UITableView = { [weak self] in
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.backgroundColor = GasolineColor.background
        table.separatorColor = GasolineColor.cellSeparator
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = Constants.tableViewCellHeight
        table.tableFooterView = UIView()
        return table
    }()

    init() {

        super.init(nibName: nil, bundle: nil)

        dataSource.dataSourceDidChangeHandler = { [weak self] dataSource in

            for item in dataSource.items {
                self?.tableView.register(item.classType, forCellReuseIdentifier: item.cellId)
            }
            self?.tableView.dataSource = dataSource
            self?.tableView.reloadData()
        }

        globalDataBaseReference.query { [weak self] (refuelItems: [Refuel]) in
            self?.refuelItems = refuelItems
            self?.dataSource.items = refuelItems
        }
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

        // Set up swipe to delete
        tableView.allowsMultipleSelectionDuringEditing = false

        // Enable editing
        navigationItem.leftBarButtonItem = self.editButtonItem

        // Add create button, to add a new item
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressedAddNewItem(sender:)))

        // Setup UI
        tableView.addMaximizedTo(view)
    }
    
    // MARK: - Actions

    @IBAction func pressedAddNewItem(sender: UIButton) {

        print("pressed add new refuel item...")
    }
}

extension RefuelListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let refuelItem = refuelItems[indexPath.row]
        if let viewController = refuelItem.selectionHandler?() {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension Refuel: GenericDataSourceItem {
    
    var cellId: String {
        return "\(type(of: self))"
    }

    var classType: AnyClass {
        return RefuelCell.self
    }

    var isEditable: Bool {
        return true
    }

    var selectionHandler: (() -> UIViewController)? {

        return { () -> UIViewController in
            return RefuelDetailViewController(refuelItem: self)
        }
    }
}
