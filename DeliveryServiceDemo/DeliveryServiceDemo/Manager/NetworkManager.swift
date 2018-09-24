//
//  NetworkManager.swift
//  DeliveryServiceDemo
//
//  Created by Ajith on 22/09/18.
//  Copyright © 2018 Ajith. All rights reserved.
//

import UIKit
import Reachability

typealias CompletionHandler = (Any?, Error?) -> ()

let cache = NSCache<AnyObject, AnyObject>()


class NetworkManager: PaginationManager{
    public static let shared = NetworkManager ()
    var baseURL: String = ""
    let reachability = Reachability()!
    
    private let cacheObject = "CacheObject"
    
    private override init() {
        super.init()
        do {
            try reachability.startNotifier()
        } catch let error{
            print(error.localizedDescription)
        }
        if let info = Bundle.main.infoDictionary, let urlString = info["BaseURL"] as? String {
            self.baseURL = urlString
        }
    }
    
    func fetchDeliveries(completion: @escaping CompletionHandler) {
        if reachability.connection != .none {
            if let url = URL(string: baseURL + "/deliveries" + "?limit=\(self.limit)&offset=\(self.offset)") {
                var request = URLRequest(url: url)
                request.allHTTPHeaderFields = ["Accept":"application/json", "Content-Type":"application/json"]
                URLSession.shared.dataTask(with: request) {
                    [weak self] data, response, error in
                    guard let weakSelf = self else { return }
                    if error == nil, let theData = data {
                        let decoder = JSONDecoder()
                        do {
                            let delivers = try decoder.decode([Delivery].self, from: theData)
                            weakSelf.deliveries.append(contentsOf: delivers)
                            weakSelf.numberItemLoaded = delivers.count
                            cache.setObject(weakSelf.deliveries as AnyObject, forKey: weakSelf.cacheObject as AnyObject)
                            completion(nil,nil)
                        } catch let jsonError {
                            print(jsonError)
                            completion(nil,jsonError)
                            
                        }
                        
                    } else {
                        completion(nil,error)
                    }
                    }.resume()
            }
        } else {
            if let deliveries = cache.object(forKey: cacheObject as AnyObject) as? [Delivery] {
                self.deliveries = deliveries
            }
            completion(nil,nil)
        }
        
    }
    
    func downloadImage(url: String, completion: @escaping CompletionHandler) {
        if let cacheImage = cache.object(forKey: url as AnyObject) {
            DispatchQueue.main.async {
                completion(cacheImage,nil)
            }
        } else {
            if let theUrl = URL(string: url) {
                let request = URLRequest(url: theUrl)
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if error == nil, let theData = data, let theResponse = response,let theMimeType = theResponse.mimeType, theMimeType.hasPrefix("image"), let image = UIImage(data: theData) {
                        
                        cache.setObject(image, forKey: url as AnyObject)
                        DispatchQueue.main.async {
                            completion(image,nil)
                        }
                    } else {
                        completion(data,nil)
                        
                    }
                }).resume()
                
            }
            
        }
        
    }
}
