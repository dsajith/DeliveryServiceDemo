//
//  DeliveryItemTableViewCell.swift
//  DeliveryServiceDemo
//
//  Created by Ajith on 22/09/18.
//  Copyright © 2018 Ajith. All rights reserved.
//

import UIKit

class DeliveryItemTableViewCell: UITableViewCell {
  
    var delivery: Delivery?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
        textLabel?.frame = CGRect(x: (imageView?.frame.width)! + 10.0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }

    
    func setUI() {
        if let theDelivery = delivery {
            self.textLabel?.text = theDelivery.description
            self.imageView?.image = #imageLiteral(resourceName: "PlaceHolder")
            self.imageView?.setImageFrom(url: theDelivery.imageUrl)
        }
    }
}
