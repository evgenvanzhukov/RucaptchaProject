//
//  ImageExtensions.swift
//  RucaptchaProject
//
//  Created by Evgen on 04.12.2022.
//

import UIKit

extension UIImage {

    func cropToRect(rect: CGRect!, _ zoomScale: CGFloat?) -> UIImage? {

        let scale = zoomScale ?? self.scale

        let scaledRect = CGRect(x: rect.origin.x / scale, y: rect.origin.y / scale, width: rect.size.width / scale , height: rect.size.height / scale );


        guard let imageRef: CGImage = self.cgImage?.cropping(to:scaledRect)
        else {
            return nil
        }

        let croppedImage: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        return croppedImage
    }
}
