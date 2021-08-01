//
//  UITableViewExtension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 30.07.2021.
//

import UIKit
import FoundationExtension

public extension UITableView {

    // MARK: Public Functions
    
    func registerCellForReuse(_ cellClass: AnyClass) {
        let identifier = String(describing: cellClass)
        register(cellClass, forCellReuseIdentifier: identifier)
    }
    
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
