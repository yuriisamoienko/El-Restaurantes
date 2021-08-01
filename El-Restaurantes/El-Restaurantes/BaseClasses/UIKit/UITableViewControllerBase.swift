//
//  UITableViewControllerBase.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 28.07.2021.
//

import UIKit
import FoundationExtension

class UITableViewControllerBase: UITableViewController, UINavigationBarDisplayer {

    // MARK: Public Properties
    
    public private(set) var didAppearOnce = false
    public var navigationBarVisibility: NavigationBarVisibility = .none

    // MARK: Overriden functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printFuncLog("class: \(self.className())")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printFuncLog("class: \(self.className()), animated = \(animated)")
        
//        if didAppearOnce == false { // first appear
            showNavigationControllerBarIfNeeded()
//        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didAppearOnce = true
        printFuncLog("class: \(self.className()), animated = \(animated)")
        
//        if didAppearOnce == true { // non first appear
//            showNavigationControllerBarIfNeeded()
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printFuncLog("class: \(self.className()), animated = \(animated)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printFuncLog("class: \(self.className()), animated = \(animated)")
    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
