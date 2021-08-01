//
//  UIAnchorsOwnerProtocol.swift
//  UIKitExtension
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import UIKit

/*
 Common anchors of UIView and UILayoutGuide, to be able accessing them equaly via protocol.
 */

public protocol UIAnchorsOwnerProtocol {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: UIAnchorsOwnerProtocol {}
extension UILayoutGuide: UIAnchorsOwnerProtocol {}
