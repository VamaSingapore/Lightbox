//
//  PhotoLibraryManager.swift
//  Lightbox-iOS
//
//  Created by Aleksandr on 25.05.2022.
//  Copyright © 2022 Hyper Interaktiv AS. All rights reserved.
//

import Photos
import UIKit
import Foundation

enum PhotoLibraryManager {
    
    typealias Completion = (Bool, Error?) -> Void
    
    static func saveVideo(from url: URL, completionHandler: Completion? = nil) {
        if url.path.starts(with: "/") {
            storeVideoAsset(url, completionHandler: completionHandler)
        } else {
            fetchAndStoreVideo(from: url, completionHandler: completionHandler)
        }
    }
    
    static func saveImage(from url: URL, completionHandler: Completion? = nil) {
        if url.path.starts(with: "/") {
            storePhotoAsset(url, completionHandler: completionHandler)
        } else {
            fetchAndStoreImage(from: url, completionHandler: completionHandler)
        }
    }
    
    static func saveImage(_ image: UIImage, completionHandler: Completion? = nil) {
        storeImage(image, completionHandler: completionHandler)
    }
}

private extension PhotoLibraryManager {
    static func fetchAndStoreVideo(from url: URL, completionHandler: Completion?) {
        let fileName = url.lastPathComponent
        DispatchQueue.global(qos: .background).async {
            if let urlData = NSData(contentsOf: url) {
                let galleryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let filePath = "\(galleryPath)/\(fileName)"
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    let url = URL(fileURLWithPath: filePath)
                    storeVideoAsset(url, completionHandler: completionHandler)
                }
            } else {
                completionHandler?(false, nil)
            }
        }
    }
    
    static func fetchAndStoreImage(from url: URL, completionHandler: Completion?) {
        DispatchQueue.global(qos: .background).async {
            let fileName = url.lastPathComponent
            if let urlData = NSData(contentsOf: url) {
                let galleryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let filePath = "\(galleryPath)/\(fileName)"
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    let url = URL(fileURLWithPath: filePath)
                    storePhotoAsset(url, completionHandler: completionHandler)
                }
            } else {
                completionHandler?(false, nil)
            }
        }
    }
    
    static func storeImage(_ image: UIImage, completionHandler: Completion?) {
        DispatchQueue.main.async {
            storeImageAsset(image, completionHandler: completionHandler)
        }
    }
}

private extension PhotoLibraryManager {
    private static func storeVideoAsset(_ localUrl: URL, completionHandler: Completion?) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: localUrl)
        }, completionHandler: completionHandler)
    }
    
    private static func storePhotoAsset(_ localUrl: URL, completionHandler: Completion?) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: localUrl)
        }, completionHandler: completionHandler)
    }
    
    private static func storeImageAsset(_ image: UIImage, completionHandler: Completion?) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: completionHandler)
    }
}
