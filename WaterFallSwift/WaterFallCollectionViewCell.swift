//
//  WaterFallCollectionViewCell.swift
//  WaterFallSwift
//
//  Created by Victor Zhang on 11/11/2017.
//  Copyright © 2017 Carol. All rights reserved.
//

import UIKit

class WaterFallCollectionViewCell: UICollectionViewCell {
  
    private var image: UIImage?
    
    func setImage(img: UIImage) {
        image = img
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let newHeight = (image?.size.height)! / (image?.size.width)! * 100
        image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: newHeight))
    }
    
}
