//
//  ListRestaurantTableViewCell.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 30.07.2021.
//

import UIKit
import MapKit

class ListRestaurantTableViewCell: UITableViewCellBase {
    
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
            configureLayout()
//            if horizontalPaddingsStackView.superview == nil {
//                self.addSubview(horizontalPaddingsStackView)
//                horizontalPaddingsStackView.fillParentFrame()
//                [
//                    horizontalPaddingsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//                    horizontalPaddingsStackView.topAnchor.constraint(equalTo: self.topAnchor),
//                    horizontalPaddingsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//                    horizontalPaddingsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//                ].activate()
//            }
            return super.contentView
        }
    }
    
    private var isLayoutConfigured = false
    
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let addressLabel = UILabel()
    private let distanceLabel = UILabel()
    private lazy var distanceLabelWidthConstraint = distanceLabel.setWidthConstraint(constant: 0)
//    private let horizontalPaddingsStackView = UIStackView(axis: .horizontal)

    override func postInit() {
        super.postInit()
        // Initialization code
    }
    
    func configureLayout() {
        if isLayoutConfigured == true {
            return
        }
        isLayoutConfigured = true
        
        selectionStyle = .none
        
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
//        nameLabel.setHeightConstraint(constant: 16, relatedBy: .greaterThanOrEqual)
//        nameLabel.backgroundColor = .yellow
//        nameLabel.setWidthConstraint(constant: 0, relatedBy: .greaterThanOrEqual)
        
        priceLabel.font = .boldSystemFont(ofSize: 18)
        priceLabel.textAlignment = .right
//        priceLabel.backgroundColor = .green
//        priceLabel.numberOfLines = 0
        priceLabel.setWidthConstraint(constant: 50)
        priceLabel.textColor = .systemGreen
        
        let firstRowStackView = UIStackView(axis: .horizontal)
//        firstRowStackView.distribution = .fillProportionally
        
        firstRowStackView.addArrangedSubviews(nameLabel, priceLabel)
        firstRowStackView.setHeightConstraint(constant: 20, relatedBy: .greaterThanOrEqual)
        
        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.numberOfLines = 0
        addressLabel.textColor = .systemGray
//        addressLabel.textAlignment = .left
        addressLabel.setHeightConstraint(constant: 15, relatedBy: .greaterThanOrEqual)
        
        distanceLabel.textAlignment = .right
        distanceLabel.font = .systemFont(ofSize: 12)
        
        let secondRowStackView = UIStackView(axis: .horizontal)
        secondRowStackView.addArrangedSubviews(addressLabel, distanceLabel)
        secondRowStackView.spacing = 5
//                secondRowStackView.distribution = .equalSpacing
        
//        let paddingTop = UIView()
//        let paddingBottom = UIView()
//        [paddingTop, paddingBottom].forEach {
//            $0.setHeightConstraint(constant: 15)
//        }
        let contentStackView = UIStackView(axis: .vertical)
        contentStackView.spacing = 5
        contentStackView.addArrangedSubviews(
            firstRowStackView,
            secondRowStackView
        )
        
//        let paddingLeft = UIView()
//        let paddingRight = UIView()
//        [paddingLeft, paddingRight].forEach {
//            $0.setWidthConstraint(constant: 20)
//        }
//        horizontalPaddingsStackView.addArrangedSubviews(
//            paddingLeft,
//            contentStackView,
//            paddingRight
//        )
        
        self.addSubview(contentStackView)
//        horizontalPaddingsStackView.fillParentFrame()
//        horizontalPaddingsStackView.fillParentFrameByConstraints()
        contentStackView.pinEdges(to: self.layoutMarginsGuide, spacingHorizontal: 10, spacingVertical: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        let df = MKDistanceFormatter()
        df.unitStyle = .abbreviated
        df.units = .metric
        let prettyString = df.string(fromDistance: distance)
        distanceLabel.text = prettyString
        distanceLabelWidthConstraint.constant = distanceLabel.textPixelWidth()
    }
}
