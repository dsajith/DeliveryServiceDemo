//
//  Delivery.swift
//  DeliveryServiceDemo
//
//  Created by Ajith on 22/09/18.
//  Copyright © 2018 Ajith. All rights reserved.
//

import Foundation


struct Delivery: Codable {
    var id: Int
    var description: String
    var imageUrl: String
    var location: Location
    
}
