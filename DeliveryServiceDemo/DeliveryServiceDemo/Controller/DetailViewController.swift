//
//  DetailViewController.swift
//  DeliveryServiceDemo
//
//  Created by Ajith on 22/09/18.
//  Copyright © 2018 Ajith. All rights reserved.
//

import UIKit
import GoogleMaps


class DetailViewController: UIViewController {

    var mapView: GMSMapView!
    var detailLabel: UILabel!
    var delivery: Delivery!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Delivery Detail"
        setUpMapView()
        setUpLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //This method will create view to google map

    func setUpMapView() {
        //GMSCameraPosition that tells the map to display the

        let camera = GMSCameraPosition.camera(withLatitude: delivery.location.lat, longitude: delivery.location.lng, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        self.view.addSubview(mapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: delivery.location.lat, longitude:delivery.location.lng)
        marker.title = delivery.location.address
        marker.map = mapView
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0).isActive = true
        mapView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: view.bounds.height*0.80).isActive = true

    }
    
   //This will create  label for delivery description
    
    func setUpLabel() {
        
        detailLabel = UILabel()
        detailLabel.numberOfLines = 0
        detailLabel.backgroundColor = .lightGray
        detailLabel.textColor = .black
        detailLabel.textAlignment = .center
        detailLabel.text = delivery.description
        self.view.addSubview(detailLabel)
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0 - view.safeAreaInsets.bottom).isActive = true
        detailLabel.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: view.bounds.height*0.20).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0).isActive = true

       
    }
}

extension DetailViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    // custom view when user tapped to see marker adderss
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 6
        
        let label = UILabel(frame: view.frame)
        label.text = delivery.location.address
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        view.addSubview(label)
        
        return view
    }
}
