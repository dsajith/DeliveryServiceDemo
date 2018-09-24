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
    

    func setUpMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: delivery.location.lat, longitude: delivery.location.lng, zoom: 10.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        self.view.addSubview(mapView)

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
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = "Testing"
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = delivery.location.address
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl2)
        
        return view
    }
}
