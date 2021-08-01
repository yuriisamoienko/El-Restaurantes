//
//  UITableViewExtension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 30.07.2021.
//

import UIKit
import FoundationExtension

public extension UITableView {

//    func registerCellType(_ cellType: AnyClass, forCellReuseIdentifier identifier: String) {
//        registerCellType(cellType, bundle: nil, forCellReuseIdentifier: identifier)
//    }
//
//    func registerCellType(_ cellType: AnyClass, bundle: Bundle? = nil, forCellReuseIdentifier identifier: String) {
//        registerCellType(cellType, bundle: bundle, forCellReuseIdentifiers: [identifier])
//    }
//
//    func registerCellType(_ cellType: AnyClass, bundle: Bundle?, forCellReuseIdentifiers identifiers: [String]) {
//        guard identifiers.count > 0
//        else {
//            return
//        }
//        let cellTypeString = String(describing: cellType)
//        let nib = UINib(nibName: cellTypeString, bundle: bundle)
//        registerNib(nib, forCellReuseIdentifiers: identifiers)
//    }
    
    func registerCellForReuse(_ cellClass: AnyClass) {
        let identifier = String(describing: cellClass)
        register(cellClass, forCellReuseIdentifier: identifier)
    }
    
//    func dequeueReusableCell(withType cellType: AnyClass, forIndexPath indexPath: IndexPath) -> UITableViewCell {
//        let cellTypeString = String(describing: cellType)
//        return dequeueReusableCell(withIdentifier: cellTypeString, for: indexPath)
//    }
    
    func dequeueReusableCell<Type: UITableViewCell>(byType cellType: Type.Type, forIndexPath indexPath: IndexPath) -> Type? {
        let cellTypeString = String(describing: cellType)
        let cell = dequeueReusableCell(withIdentifier: cellTypeString, for: indexPath)
        guard let result = cell as? Type else { // ignore this warning, because AnyClass inherits from UITableView
            fatalMistake("cell (\(cell.className()) is not a \(String(describing: type(of: Type.self)))")
            return nil
        }
        return result
    }
}
