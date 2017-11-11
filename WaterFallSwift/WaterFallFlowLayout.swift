//
//  WaterFallFlowLayout.swift
//  WaterFallSwift
//
//  Created by Victor Zhang on 11/11/2017.
//  Copyright © 2017 Carol. All rights reserved.
//

import UIKit

public class ZQWaterFallViewLayout: UICollectionViewFlowLayout {
    
    //共有几列
    public let collectionViewCellColumns: Int = 3
    
    public var waterFallFlowLayoutDelegate: UICollectionViewDelegateFlowLayout?
    
    //Cell的个数
    public var cellCounts: Int = 0
    
    //存放列的高度
    public var columnHeightInList: Array<Float>?
    
    //存放Cell的frame位置信息
    public var attributesInDict: Dictionary<String, IndexPath>?
    
    //1.准备布局：
    //  1.1 得到cell的总个数，
    //  1.2 为每个cell确定自己的frame位置
    public override func prepare() {
        super.prepare()
        columnHeightInList = Array<Float>()
        attributesInDict = Dictionary<String, IndexPath>()
        waterFallFlowLayoutDelegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout
        
        //获取0组的cell的个数
        cellCounts = (collectionView?.numberOfItems(inSection: 0))!
        if cellCounts == 0 {
            return
        }
        
        //假设一开始列高等于0
        for _ in 0..<collectionViewCellColumns {
            columnHeightInList?.append(0)
        }
        
        //对0组的所有的cell重新计算frame，并且缓存到成员变量里
        //在layoutAttributesForItem方法里，把重新计算的frame赋值给cell
        for i in 0..<cellCounts {
            layoutItem(at: IndexPath(item: i, section: 0))
        }
    }
    
    //此方法会多次调用，为每个cell布局
    public func layoutItem(at indexPath: IndexPath) {
        //通过协议得到cell的间隙
        let edgeInsets = waterFallFlowLayoutDelegate?.collectionView!(collectionView!, layout: self, insetForSectionAt: indexPath.row)
        
        //拿到每个单元格的高度
        let cellSize = waterFallFlowLayoutDelegate?.collectionView!(collectionView!, layout: self, sizeForItemAt: indexPath)
        
        //找出高度最小的列
        var columnIndex: Int = 0
        var shortHeight = columnHeightInList![columnIndex]
        for i in 0..<columnHeightInList!.count {
            let height = columnHeightInList![i]
            if height  < shortHeight {
                shortHeight = height
                columnIndex = i
            }
        }
        
        //这是最小列的高度
        let top = columnHeightInList![columnIndex]
        
        //重新计算出cell的frame
        let frame = CGRect(x: (edgeInsets?.left)! + CGFloat(columnIndex) * ((edgeInsets?.left)! + cellSize!.width), y: CGFloat(top) + (edgeInsets?.top)!, width: cellSize!.width, height: cellSize!.height)
        
        //将重新计算的列高加入存起来
        columnHeightInList?[columnIndex] = Float(CGFloat(top) + (edgeInsets?.top)! + cellSize!.height)
        
        //每个cell对应的indexPath放到attributesInDict中，key是frame
        let frameStrKey = NSStringFromCGRect(frame)
        attributesInDict![frameStrKey] = indexPath
    }

    //返回cell的布局属性信息，如果忽略传入的rect一次性将所有的cell布局信息返回，图片过多时性能会很差
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var array = Array<UICollectionViewLayoutAttributes>()
        let indexPaths = indexPathOfItem(rect: rect)
        for indexpath in indexPaths {
            let layoutAttributes = layoutAttributesForItem(at: indexpath)
            array.append(layoutAttributes!)
        }
        return array
    }
    
    //为每个cell布局完毕后，需要实现这个方法， 传入frame，返回的时cell的信息
    //传入当前可见cell的rect，视图滑动时调用
    private func indexPathOfItem(rect: CGRect) -> [IndexPath] {
        var array = Array<IndexPath>()
        for (keyRect, _) in attributesInDict! {
            let cellRect = CGRectFromString(keyRect)
            if rect.intersects(cellRect) {
                let indexPath = attributesInDict![keyRect]
                array.append(indexPath!)
            }
        }
        return array
    }
    
    //把重新计算的frame赋值给cell
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        for (keyRect, _) in attributesInDict! {
            if attributesInDict![keyRect]?.compare(indexPath) == .orderedSame {
                attributes.frame = CGRectFromString(keyRect)
            }
        }
        return attributes
    }
    
    //最后还要实现这个方法，返回collectionView内容的大小
    //只需要遍历前面创建的存放列高的数组得到列最高的一个作为高度返回就可以了
    public override var collectionViewContentSize: CGSize {
        var size = collectionView?.frame.size
        var maxHeight = columnHeightInList![0]
        
        //找到最高的列的高度
        for i in 0..<columnHeightInList!.count {
            let colHeight = columnHeightInList![i]
            if colHeight > maxHeight {
                maxHeight = colHeight
            }
        }
        size?.height = CGFloat(maxHeight)
        return size!
    }
}

