//
//  ImagesAssets.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 28.07.2021.
//

import UIKit

extension UIImage {
    
    // MARK: Namespaces
    class Icons {
        var mapFill: UIImage? {
            UIImage(named: "map.fill")
        }
        var playlistAddCheck: UIImage? {
            UIImage(named: "playlist.add.check")
        }
    }
    
    // MARK: Public Properties
    static var icons: Icons {
        Icons()
    }
}
