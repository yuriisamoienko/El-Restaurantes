//
//  UIView+Extension.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 28.07.2021.
//

import UIKit

extension UIView: UIAnchorsOwnerProtocol {}
extension UILayoutGuide: UIAnchorsOwnerProtocol {}

public extension UIView {
    
    var frameX: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame = CGRect(x: newValue, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        }
    }

    var frameY: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame = CGRect(x: frame.origin.x, y: newValue, width: frame.size.width, height: frame.size.height)
        }
    }
    
    var frameWidth: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: newValue, height: frame.size.height)
        }
    }

    var frameHeight: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: newValue)
        }
    }
    
    var frameCenterX: CGFloat {
        set {
            frameX = newValue - frameWidth/2
        }
        get {
            let result = frameX + frameWidth/2
            return result
        }
    }
    
    var frameCenterY: CGFloat {
        set {
            frameY = newValue - frameHeight/2
        }
        get {
            let result = frameY + frameHeight/2
            return result
        }
    }
    
    var frameCenter: CGPoint {
        set {
            frameCenterX = newValue.x
            frameCenterY = newValue.y
        }
        get {
            let result = CGPoint(x: frameCenterX, y: frameCenterY)
            return result
        }
    }
    
    var parentViewController: UIViewController? {
        let result = next as? UIViewController ?? superview?.parentViewController
        return result
    }
    
    func fillParentFrame() {
        guard let superview = self.superview else { return }
        self.frame = superview.bounds
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func pinEdges(to layoutGuide: UIAnchorsOwnerProtocol, spacingHorizontal: CGFloat = 0, spacingVertical: CGFloat = 0) {
        pinEdges(to: layoutGuide, leftSpacing: spacingHorizontal/2, topSpacing: spacingVertical/2, rightSpacing: spacingHorizontal/2, bottomSpacing: spacingVertical/2)
    }
    
    func pinEdges(to layoutGuide: UIAnchorsOwnerProtocol, leftSpacing: CGFloat = 0, topSpacing: CGFloat = 0, rightSpacing: CGFloat = 0, bottomSpacing: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        [
            self.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: topSpacing),
            self.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: leftSpacing),
            self.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -bottomSpacing),
            self.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor, constant: -rightSpacing),
        ].activate()
    }
    
    func centerHorizontallyInSuperview() {
        guard let superview = self.superview else {
            return
        }
        self.frameCenterX = superview.frameWidth/2
    }
    
    func centerVerticallyInSuperview() {
        guard let superview = self.superview else {
            return
        }
        self.frameCenterY = superview.frameHeight/2
    }
    
    func centerInSuperview() {
        guard let superview = self.superview else {
            return
        }
        
        frameCenter = superview.bounds.center
    }
    
   /* func pinEdges(to view: UIView, spacingHorizontal: CGFloat = 0, spacingVertical: CGFloat = 0) {
        pinEdges(to: view, leftSpacing: spacingHorizontal/2, topSpacing: spacingVertical/2, rightSpacing: spacingHorizontal/2, bottomSpacing: spacingVertical/2)
    }
    
    func pinEdges(to view: UIView, leftSpacing: CGFloat = 0, topSpacing: CGFloat = 0, rightSpacing: CGFloat = 0, bottomSpacing: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        [
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: topSpacing),
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftSpacing),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomSpacing),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -rightSpacing),
        ].activate()
    }*/
    
    @discardableResult
    func setHeightConstraint(constant: CGFloat, relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
       return  heightAnchor.constraint(constant: constant, relatedBy: relation).activated()
    }
    
    @discardableResult
    func setWidthConstraint(constant: CGFloat, relatedBy relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return widthAnchor.constraint(constant: constant, relatedBy: relation).activated()
    }
    
    func hide()  {
        isHidden = true
    }

    func showMe() {
        isHidden = false
    }
    
    convenience init(heightConstraintConstant value: CGFloat, relatedBy relation: NSLayoutConstraint.Relation = .equal) {
        self.init()
        setHeightConstraint(constant: value, relatedBy: relation)
    }
    
    // MARK: - IBInspectable
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            if newValue != 0 {
                clipsToBounds = true // without it cornerRadius doens't work
            }
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}


