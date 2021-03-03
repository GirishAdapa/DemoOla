//
//  ImageLoader.swift
//  OlaDemo
//
//  Created by Abhishek Singh on 03/03/21.
//  Copyright © 2021 Girish. All rights reserved.
//

import UIKit
import Accelerate



class ImageLoader {
     private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
 func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
    if url == nil{
        let err: Error? = nil
        completion(.failure(err!))
        return nil
    }

    // 1
    if let image = loadedImages[url] {
      completion(.success(image))
      return nil
    }

    // 2
    let uuid = UUID()

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      // 3
      defer {self.runningRequests.removeValue(forKey: uuid) }

      // 4
      
      if let data = data, let image = UIImage(data: data) {
        
        let img = image.resizeImageUsingVImage(size: CGSize(width: image.size.width, height: image.size.height))
         self.loadedImages[url] = img
        completion(.success(img!))
         return
      }

      // 5
      guard let error = error else {
        // without an image or an error, we'll just ignore this for now
        // you could add your own special error cases for this scenario
        return
      }

      guard (error as NSError).code == NSURLErrorCancelled else {
        completion(.failure(error))
        return
      }

      // the request was cancelled, no need to call the callback
    }
    task.resume()

    // 6
    runningRequests[uuid] = task
    return uuid
  }
}

extension UIImage {

    var highestQualityJPEGNSData: Data { return self.jpegData(compressionQuality: 1.0)! }
    var highQualityJPEGNSData: Data    { return self.jpegData(compressionQuality: 0.75)!}
    var mediumQualityJPEGNSData: Data  { return self.jpegData(compressionQuality: 0.5)! }
    var lowQualityJPEGNSData: Data     { return self.jpegData(compressionQuality: 0.25)!}
    var lowestQualityJPEGNSData: Data  { return self.jpegData(compressionQuality: 0.0)! }

}
extension UIImage{
    func resizeImageUsingVImage(size:CGSize) -> UIImage? {
         let cgImage = self.cgImage!
         var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue), version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
         var sourceBuffer = vImage_Buffer()
         defer {
              free(sourceBuffer.data)
         }
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
         guard error == kvImageNoError else { return nil }
       // create a destination buffer
       let scale = self.scale
       let destWidth = Int(size.width)
       let destHeight = Int(size.height)
       let bytesPerPixel = self.cgImage!.bitsPerPixel/8
       let destBytesPerRow = destWidth * bytesPerPixel
       let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
       defer {
             //destData.deallocate(capacity: destHeight * destBytesPerRow)
       }
      var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
    // scale the image
     error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
     guard error == kvImageNoError else { return nil }
     // create a CGImage from vImage_Buffer
     var destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
    guard error == kvImageNoError else { return nil }
    // create a UIImage
     let resizedImage = destCGImage.flatMap { UIImage(cgImage: $0, scale: 0.0, orientation: self.imageOrientation) }
     destCGImage = nil
    return resizedImage
    }
}
