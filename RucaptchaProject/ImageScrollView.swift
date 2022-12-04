//
//  ImageScrollView.swift
//  RucaptchaProject
//
//  Created by Evgen on 28.11.2022.
//

import UIKit

class ImageScrollView: UIScrollView, UIScrollViewDelegate {

    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    func setUp(img: UIImage) {
        if(imageView != nil) {
            imageView.removeFromSuperview()
            imageView = nil
        }
        self.imageView = UIImageView(image: img)
        self.addSubview(imageView)
        
        configure(for: img.size)
        
        self.minimumZoomScale = 0.1
        self.maximumZoomScale = 3
    }
    
    func configure(for imageSize: CGSize) {
        self.contentSize = imageSize
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
