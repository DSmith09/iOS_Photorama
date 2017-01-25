//
//  FlickrAPI.swift
//  Photorama
//
//  Created by David on 1/22/17.
//  Copyright © 2017 DSmith. All rights reserved.
//

import Foundation

enum Method: String {
    case RecentPhotos = "flickr.photos.getRecent"
}

enum PhotoResult {
    case Success([Photo])
    case Failure(Error)
}

enum FlickrError: Error {
    case InvalidJSONData
}

// Struct uses "static" - Classes use "class"
// Structs are Pass By Value - Values are copied to new variable
// Classes are Pass By Reference - Actual object is copied to new variable - useful if needing to modify all properties at once
struct FlickrAPI {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    private static let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static func photosFromJSONData(data: NSData) -> PhotoResult {
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data as Data, options: [])
            guard let jsonDictionary = jsonObject as? [NSString:Any],
            let photos = jsonDictionary["photos"] as? [String:Any],
            let photosArray = photos["photo"] as? [[String:Any]]
                else {
                    return .Failure(FlickrError.InvalidJSONData)
            }
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photoFromJSONObject(json: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            if finalPhotos.count == 0 && photosArray.count > 0 {
                return .Failure(FlickrError.InvalidJSONData)
            }
            return .Success(finalPhotos)
        } catch let error {
            return .Failure(error)
        }
    }
    
    static func recentPhotosURL() -> NSURL {
        return flickrURL(method: Method.RecentPhotos, parameters: ["extras":"url_h,date_taken"])
    }
    
    private static func photoFromJSONObject(json: [String:Any]) -> Photo? {
        guard let
            photoID = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoURLString = json["url_h"] as? String,
            let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString)
            else {
                return nil
        }
        return Photo(title: title, remoteURL: url as NSURL, photoID: photoID, dateTaken: dateTaken as NSDate)
    }
    
    private static func flickrURL(method: Method, parameters: [String: String]?) -> NSURL {
        let components = NSURLComponents(string: baseURLString)
        var queryItems = [NSURLQueryItem]()
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": APIKey
        ]
        
        for (key, value) in baseParams {
            queryItems.append(NSURLQueryItem(name: key, value: value))
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                queryItems.append(NSURLQueryItem(name: key, value: value))
            }
        }
        components?.queryItems = queryItems as [URLQueryItem]
        return components!.url! as NSURL
    }
    
}
