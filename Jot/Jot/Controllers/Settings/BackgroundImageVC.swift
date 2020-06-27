//
//  BackgroundImageVC.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-06-06.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import os
import UIKit
import JotUIKit
import JotModelKit

class BackgroundImageVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: -Class Variables
    
    let app = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "\(URL(fileURLWithPath: #file).deletingPathExtension().lastPathComponent)")
    
    lazy var reuseIdentifier = "FlickrCell"
    
    // Load in images from file content so they don't get stored in cache.
    var images: [UIImage?] = [UIImage(contentsOfFile: Bundle.main.path(forResource: "Background1", ofType: "png") ?? ""),
                              UIImage(contentsOfFile: Bundle.main.path(forResource: "Background2", ofType: "png") ?? ""),
                              UIImage(contentsOfFile: Bundle.main.path(forResource: "Background3", ofType: "png") ?? "")]
    
    lazy var imagesStrings: [String] = ["Background1", "Background2", "Background3"]
    
    lazy var sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    lazy var itemsPerRow: CGFloat = 3
    
    // MARK: -Class Override Functions
    
    override func viewDidLoad() {
        // Log the operating function.
        os_log(.info, log: app, "%@", #function)
        
        super.viewDidLoad()
        
        collectionView!.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        title = "Pick Background Image"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Log the operating function.
        os_log(.info, log: app, "%@", #function)
        
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: -Class Initialization
    
    init() {
        // Initialized with a non-nil layout parameter.
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        os_log(.info, log: app, "%@", #function)
    }
    
    // MARK: -Collection View Setup
    
    /// Logic for when a collection cell is touched.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Log the operating function.
        os_log(.info, log: app, "%@", #function)
        
        // Need to deselect the cell after the tap has ended.
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // Set the image as the background image for the app.
        backgroundImageSet(image: imagesStrings[indexPath.section + indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
    /// Number of items to be displayed.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    /// Set what each cell looks like.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! ImageCollectionViewCell
        
        let image = images[indexPath.section + indexPath.row]
        
        // Recalculate the width iteams.
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        // Set image and size, image scales to fill by default.
        cell.profileImageView.image = image
        cell.profileImageView.frame = CGRect(x: 0, y: 0, width: widthPerItem, height: cell.frame.height)
        
        return cell
    }
    
    // MARK: -Collection View Flow Layout Delegate
    
    /// Set the size and spacing of each cell.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    /// Set the inset.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    /// Set the inset.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
