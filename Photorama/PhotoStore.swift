//
//  PhotoStore.swift
//  Photorama
//
//  Created by David on 1/22/17.
//  Copyright © 2017 DSmith. All rights reserved.
//

import UIKit

enum ImageResult {
    case Success(UIImage)
    case Failure(Error)
}

enum PhotoError:Error {
    case ImageCreationError
}

class PhotoStore {
    let session: URLSession = {
        return URLSession.init(configuration: URLSessionConfiguration.default)
    }()
    
    func fetchRecentPhotos(completion: @escaping (PhotoResult) -> Void) {
        let request = URLRequest(url: FlickrAPI.recentPhotosURL() as URL)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            completion(self.processRecentPhotosRequest(data: data, error: error))
        })
        task.resume()
    }
    
    func processRecentPhotosRequest(data: Data?, error: Error?) -> PhotoResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return FlickrAPI.photosFromJSONData(data: jsonData as NSData)
    }
    
    func fetchUIImageFromPhotoData(photo: Photo, completion: @escaping (ImageResult) -> Void) {
        let request = URLRequest(url: photo.getRemoteURL())
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            let imageResult = self.processImageDataRequest(data: data, error: error)
            if case let .Success(image) = imageResult {
                photo.setImage(image: image)
            }
            completion(imageResult)
        })
        task.resume()
    }
    
    func processImageDataRequest(data: Data?, error: Error?) -> ImageResult {
        guard let imageData = data,
        let image = UIImage(data: imageData) else {
            if data == nil {
                return .Failure(error!)
            } else {
                return .Failure(PhotoError.ImageCreationError)
            }
        }
        return .Success(image)
    }
}


