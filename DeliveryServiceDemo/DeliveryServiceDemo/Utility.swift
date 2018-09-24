//
//  Utility.swift
//  DeliveryServiceDemo
//
//  Created by Ajith on 23/09/18.
//  Copyright © 2018 Ajith. All rights reserved.
//

import UIKit

struct Utility {
    public static func showAlert(alert: String, message: String, controller: UIViewController) {
        let alertVC = UIAlertController(title: alert, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.present(alertVC, animated: true, completion: nil)
    }
}
