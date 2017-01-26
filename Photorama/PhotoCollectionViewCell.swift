//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by David on 1/25/17.
//  Copyright © 2017 DSmith. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    // MARK: Reset ImageView
    // These methods are within UICollectionViewCell - They allow for initialization of View "awakeFromNib()" and preparing for cell reuse "prepareForReuse()"
    override func awakeFromNib() {
        super.awakeFromNib()
        updateWithImage(image: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateWithImage(image: nil)
    }
}
