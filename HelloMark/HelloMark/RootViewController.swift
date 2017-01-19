//
//  RootViewController.swift
//  Home Control
//
//  Created by mbcharbonneau on 7/20/15.
//  Copyright (c) 2015 Once Living LLC. All rights reserved.
//

import UIKit

class RootViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    // MARK: RootViewController
    let reuseIdentifier = "RoomCell" // also enter this string as the cell identifier in the storyboard
    let deviceReuseIdentifier = "DeviceCell"
    var items = ["1", "2", "3", "4"]
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        // Do any additional setup after loading the view, typically from a nib
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth / 3, height: screenWidth / 3)
        self.collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    // MARK: - UICollectionViewDataSource protocol
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            print(111)
            return self.items.count
        case 1:
            return self.items.count
        default:
            assert( false, "invalid section" )
        }
    }
    
    // make a cell for each cell index path
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            // get a reference to our storyboard cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 0.5
//            cell.frame.size.width = screenWidth/1.5
//            cell.frame.size.height = screenWidth/1.5
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.roomName.text = self.items[indexPath.item]
            return cell
            
        case 1:
            // get a reference to our storyboard cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deviceReuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.roomName.text = self.items[indexPath.item]
            
            return cell
        default:
            assert( false, "invalid section" )
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let margins = layout.sectionInset.left + layout.sectionInset.right
        
        switch indexPath.section {
        case 0:
            let width = ( collectionView.frame.size.width - layout.minimumInteritemSpacing - margins ) / 2.0
            return CGSize(width, width * 0.86)
        case 1:
            return CGSize(collectionView.frame.size.width - margins, 60.0)
        default:
            assert( false, "invalid section" )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsetsMake(50.0, 50.0, 50.0, 50.0)
        case 1:
            return UIEdgeInsetsMake(0.0, 20.0, 20.0, 20.0)
        default:
            assert( false, "invalid section" )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(0,0)
        case 1:
            return CGSize(collectionView.frame.width, 34.0)
        default:
            assert( false, "invalid section" )
        }
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}

extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
