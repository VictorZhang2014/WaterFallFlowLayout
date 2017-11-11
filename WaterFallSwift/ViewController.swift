//
//  ViewController.swift
//  WaterFallSwift
//
//  Created by Victor Zhang on 11/11/2017.
//  Copyright © 2017 Carol. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let reuse_identifier = "reuse_identifier_collectionView_cell"
    
    var datalist: Array<UIImage>?
    
    let cellWidth: CGFloat = 110
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Water Fall Flow Layout"
        
        datalist = Array<UIImage>()
        for i in 0...16 {
            datalist?.append(UIImage(named: "huoying\(i+1)")!)
        }
    
        
        let layout = ZQWaterFallViewLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WaterFallCollectionViewCell.self, forCellWithReuseIdentifier: reuse_identifier)
        self.view.addSubview(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (datalist?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuse_identifier, for: indexPath) as! WaterFallCollectionViewCell
        cell.setImage(img: datalist![indexPath.row])
        return cell
    }
    
    func getImgWith(height: CGFloat, width: CGFloat) -> CGFloat {
        return height / width * cellWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = datalist![indexPath.row]
        let height = getImgWith(height: image.size.height, width: image.size.width)
        return CGSize(width: cellWidth, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin: CGFloat = (self.view.frame.size.width - cellWidth * 3) / 4
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }

}
