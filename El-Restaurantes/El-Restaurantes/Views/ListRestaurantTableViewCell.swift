//
//  ListRestaurantTableViewCell.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 30.07.2021.
//

import UIKit
import MapKit

/*
 Cell for ListRestaurantsVC
 */

class ListRestaurantTableViewCell: UITableViewCellBase {
    
    // MARK: Public Properties
    
    public var name: String = "" {
        didSet {
            onNameDidSet()
        }
    }
    public var price: Int = 0 {
        didSet {
            onPriceDidSet()
        }
    }
    public var address: String = "" {
        didSet {
            onAddressDidSet()
        }
    }
    public var distance: Double = 0 {
        didSet {
            onDistanceDidSet()
        }
    }
    
    override open var contentView: UIView {
        get {
            // it called first time when cell kind of "loaded from nib".
            configureLayout()
            return super.contentView
        }
    }
    
    // MARK: Private Properties
    
    // UI
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let addressLabel = UILabel()
    private let distanceLabel = UILabel()
    private lazy var distanceLabelWidthConstraint = distanceLabel.setWidthConstraint(constant: 0)

    private var isLayoutConfigured = false

    
    // MARK: Private Functions
    
    private func configureLayout() {
        if isLayoutConfigured == true {
            return
        }
        isLayoutConfigured = true
        
        selectionStyle = .none
        
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        
        priceLabel.font = .boldSystemFont(ofSize: 18)
        priceLabel.textAlignment = .right
        priceLabel.setWidthConstraint(constant: 50)
        priceLabel.textColor = .systemGreen
        
        let firstRowStackView = UIStackView(axis: .horizontal)
        firstRowStackView.addArrangedSubviews(
            nameLabel,
            priceLabel
        )
        firstRowStackView.setHeightConstraint(constant: 20, relatedBy: .greaterThanOrEqual)
        
        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.numberOfLines = 0
        addressLabel.textColor = .systemGray
        addressLabel.setHeightConstraint(constant: 15, relatedBy: .greaterThanOrEqual)
        
        distanceLabel.textAlignment = .right
        distanceLabel.font = .systemFont(ofSize: 12)
        
        let secondRowStackView = UIStackView(axis: .horizontal)
        secondRowStackView.addArrangedSubviews(addressLabel, distanceLabel)
        secondRowStackView.spacing = 5
        
        let contentStackView = UIStackView(axis: .vertical)
        contentStackView.spacing = 5
        contentStackView.addArrangedSubviews(
            firstRowStackView,
            secondRowStackView
        )

        self.addSubview(contentStackView)
        contentStackView.pinEdges(to: self.layoutMarginsGuide, spacingHorizontal: 10, spacingVertical: 5)
    }
    
    // MARK: Private Functions

    private func onNameDidSet() {
        nameLabel.text = name
    }
    
    private func onPriceDidSet() {
        priceLabel.text = String(repeating: "$", count: price)
    }
    
    private func onAddressDidSet() {
        addressLabel.text = address
    }
    
    private func onDistanceDidSet() {
        // need format distance in readable format
        let df = MKDistanceFormatter()
        df.unitStyle = .abbreviated
        df.units = .metric
        let prettyString = df.string(fromDistance: distance)
        distanceLabel.text = prettyString
        // calc width constraint to fit text
        distanceLabelWidthConstraint.constant = distanceLabel.textPixelWidth()
    }
}
