//
//  Images.swift
//  searchImages
//
//  Created by ritessshhh on 1/6/25.
//
import Foundation
import SwiftUI
import Photos

class PhotoFetcher: ObservableObject {
    @Published var authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    @Published var images: [UIImage] = []
    
    private let imageManager = PHCachingImageManager()
    
    init() {
        // If already authorized or limited, fetch photos immediately
        if authorizationStatus == .authorized || authorizationStatus == .limited {
            fetchPhotos()
        }
    }
    
    func requestPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
            DispatchQueue.main.async {
                self.authorizationStatus = newStatus
                if newStatus == .authorized || newStatus == .limited {
                    self.fetchPhotos()
                }
            }
        }
    }
    
    /// Fetch photos from the photo library (simple example).
    func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        // You can sort or limit your fetch. For example:
        // fetchOptions.fetchLimit = 50

        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        // For demonstration, request a ~200pt image (modify as needed).
        let targetSize = CGSize(width: 200, height: 200)
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        
        assets.enumerateObjects { asset, _, _ in
            self.imageManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: requestOptions
            ) { image, _ in
                if let image = image {
                    DispatchQueue.main.async {
                        self.images.append(image)
                    }
                }
            }
        }
    }
}

// NOT USED YET
class Images {
    var image: Image
    var isPhoto: Bool
    var caption: String
    var date: Date
    var location: String
    var tags: [String]

    // Initializer
    init(image: Image, isPhoto: Bool, caption: String, date: Date, location: String, tags: [String]) {
        self.image = image
        self.isPhoto = isPhoto
        self.caption = caption
        self.date = date
        self.location = location
        self.tags = tags
    }

    // Method to display details
    func details() {
        print("Image: \(image)")
        print("Is Photo: \(isPhoto)")
        print("Caption: \(caption)")
        print("Date: \(date)")
        print("Location: \(location)")
        print("Tags: \(tags.joined(separator: ", "))")
    }
}
