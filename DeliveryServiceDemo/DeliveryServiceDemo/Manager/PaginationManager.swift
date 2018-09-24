//
//  PaginationManager.swift
//  DeliveryServiceDemo
//
//  Created by Ajith on 23/09/18.
//  Copyright © 2018 Ajith. All rights reserved.
//

import Foundation

class PaginationManager  {
    var isLoading = false
    var deliveries = [Delivery]()
    var limit : Int = 7
    var offset = 1
    var numberItemLoaded: Int = 0 {
        didSet {
            offset += numberItemLoaded
        }
    }
    var hasMoreDataToLoad : Bool {
        return limit == numberItemLoaded
    }

    func clearData() {
        limit = 7
        numberItemLoaded = 0
        offset = 1
        deliveries.removeAll()
    }
}
