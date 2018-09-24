//
//  PaginationManager.swift
//  DeliveryServiceDemo
//
//  Created by Ajith on 23/09/18.
//  Copyright © 2018 Ajith. All rights reserved.
//

import Foundation


/// This manager is used for pagination 
class PaginationManager  {
    var isLoading = false
    var deliveries = [Delivery]()
    var limit : Int = 20
    var offset = 0
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
        offset = 0
        deliveries.removeAll()
    }
}
