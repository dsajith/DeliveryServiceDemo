//
//  Extension+App.swift
//  DeliveryServiceDemo
//
//  Created by Ajith on 22/09/18.
//  Copyright © 2018 Ajith. All rights reserved.
//

import UIKit


extension Array {
    subscript (safe index: Int) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}


extension UIImageView {
    func setImageFrom(url: String) {
        NetworkManager.shared.downloadImage(url: url) {
            (image, error) in
            if error == nil, let theImage = image as? UIImage {
                self.image = theImage
            }
        }
    }
}
