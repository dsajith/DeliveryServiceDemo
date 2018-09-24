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

let imageCache = NSCache<AnyObject, AnyObject>()

enum ResponseError: Error {
    case runtimeError(String)
}


class NetworkManager: PaginationManager{
    public static let shared = NetworkManager ()
    var baseURL: String = ""
    let reachability = Reachability()!
    
    var googleApiKey: String {
        var key = ""
        if let info = Bundle.main.infoDictionary, let theKey = info["GoogleMapAPIKey"] as? String {
            key = theKey
        } else {
            assert(key == "", "Add Google Map API Key In Plist")
        }
        return key
    }
    
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
        if let url = URL(string: baseURL + "/deliveries" + "?limit=\(self.limit)&offset=\(self.offset)") {
            
            //Create request with caching policy, here URLCache is used, for big data storeage we use core data or realm.
            var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
            request.allHTTPHeaderFields = ["Accept":"application/json", "Content-Type":"application/json"]

            //Get cache response using request object
            let cacheResponse = URLCache.shared.cachedResponse(for: request)
            if reachability.connection != .none {
                
                let config = URLSessionConfiguration.default
                if cacheResponse == nil {
                    //Enable url cache in session configuration and assign capacity
                    config.urlCache = URLCache.shared
                    config.urlCache = URLCache(memoryCapacity: 51200, diskCapacity: 10000, diskPath: "urlCache")
                }
                
                //Here I used default URLSession for network request, I am well aware of alamofire also.
                
                let urlSession = URLSession(configuration: config)
                urlSession.dataTask(with: request) {
                    [weak self] data, response, error in
                    guard let weakSelf = self else { return }
                    if error == nil, let theData = data, let theResponse = response {
                        let error = weakSelf.parseDelivery(data: theData)
                        
                        // below cache the data, request object as key
                        let cacheResponsed = CachedURLResponse(response: theResponse, data: theData)
                        URLCache.shared.storeCachedResponse(cacheResponsed, for: request)
                        
                        
                        completion(nil,error)
                        
                    } else {
                        completion(nil,error)
                    }
                    
                    }.resume()
                
            } else {
                //if offline then check if cached response is available
                let _ = parseDelivery(data: cacheResponse?.data)
                completion(nil,nil)
            }
            
        } else {
            completion(nil,nil)
        }
        
    }
    
    //This method will parse the data from sever to local object, here also I used default codable protocal to map object.
    func parseDelivery(data:Data?) -> Error?{
        var error: Error?
        if let theData = data {
            let decoder = JSONDecoder()
            do {
                let delivers = try decoder.decode([Delivery].self, from: theData)
                self.deliveries.append(contentsOf: delivers)
                self.numberItemLoaded = delivers.count
            } catch let theError{
                error = theError
            }
        } else {
            error = ResponseError.runtimeError("Unable load data")
        }
        return error
    }
    
    //This method will download image and cache it once image is downloaded.
    
    func downloadImage(url: String, completion: @escaping CompletionHandler) {
        if let cacheImage = imageCache.object(forKey: url as AnyObject) {
            DispatchQueue.main.async {
                completion(cacheImage,nil)
            }
        } else {
            if let theUrl = URL(string: url) {
                let request = URLRequest(url: theUrl)
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if error == nil, let theData = data, let theResponse = response,let theMimeType = theResponse.mimeType, theMimeType.hasPrefix("image"), let image = UIImage(data: theData) {
                        imageCache.setObject(image, forKey: url as AnyObject)
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
