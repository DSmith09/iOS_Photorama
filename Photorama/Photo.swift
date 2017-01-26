//
//  Photo.swift
//  Photorama
//
//  Created by David on 1/22/17.
//  Copyright © 2017 DSmith. All rights reserved.
//

import UIKit
// NOTE: Structs are immutable; Classes are mutable
class Photo {
    // MARK: Struct properties
    private let title: String
    private let remoteURL: NSURL
    private let photoID: String
    private let dateTaken: NSDate
    private var image: UIImage?
    
    // MARK: Init
    init(title: String, remoteURL: NSURL, photoID: String, dateTaken: NSDate) {
        self.title = title
        self.remoteURL = remoteURL
        self.photoID = photoID
        self.dateTaken = dateTaken
    }
    
    // MARK: Getters
    public func getTitle() -> String {
        return title
    }
    
    public func getRemoteURL() -> URL {
        return remoteURL as URL
    }
    
    public func getPhotoID() -> String {
        return photoID
    }
    
    public func getDateTaken() -> Date {
        return dateTaken as Date
    }
    
    public func getImage() -> UIImage? {
        return image
    }
    
    // MARK: Setters
    public func setImage(image: UIImage?) {
        self.image = image
    }
}
