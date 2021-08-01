//
//  String+Localization.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 01.08.2021.
//

import Foundation
import FoundationExtension

/*
 Contains localization keys list
 
 example:
 let text: String = .localize.map.capitalized
 */

extension String.Localizations {
    
    // MARK: Public Properties
    
    var map: String {
        "k_map".localized
    }
    var list: String {
        "k_list".localized
    }
    var noLocation: String {
        "k_no_location".localized
    }
    var pleaseEnableLocationService: String {
        "k_enable_location_service".localized
    }
    
    
}
