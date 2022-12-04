//
//  ViewController.swift
//  RucaptchaProject
//
//  Created by Evgen on 20.11.2022.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var captchaService = RucaptchaService()
    var imageScrollView: ImageScrollView!
    var id: String?
        
    @IBOutlet weak var croppedImageView: UIImageView!
    
    @IBOutlet weak var ancorView: UIView!
    
    @IBAction func loadBtnPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true)
        
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        
        //crop image
        
        let a:CGRect = imageScrollView.convert(imageScrollView.image.frame, to: view)
//        print("a x:",a.minX,a.maxX)
//        print("a y:", a.minY, a.maxY)
//        print("a w/h:", a.width,"/",a.height)
        //var f = ancorView.frame
//        print("ancor y:", f.minY, f.maxY)
//        print( view.safeAreaInsets)
        print("imageScrollView.zoomScale:", imageScrollView.zoomScale)
        let rectToCrop = CGRect(x: CGFloat(50 + abs(a.minX)), y: CGFloat(ancorView.frame.minY + abs(a.minY)
        ), width: ancorView.frame.width, height: ancorView.frame.height)
        
        let newimage = imageScrollView.image.image!.cropToRect(rect: rectToCrop, imageScrollView.zoomScale)
        
        croppedImageView.image = newimage!
        
        captchaService.sendToRecognize(imageScrollView.image.image!, completion: processCaptchaResponse)
    }
    
    @IBAction func checkBtnPressed(_ sender: Any) {
        guard let id = id else {
            return
        }
        
        captchaService.checkRecognized(id, completion: processCaptchaResponse)
    }
    
    @IBOutlet weak var label: UILabel!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            self.imageScrollView.setUp(img: image)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        view.sendSubviewToBack(imageScrollView)
        setUpImageScrollView()

        let image = UIImage(named: "img")!

        imageScrollView.setUp(img: image)

        let pinchMethod = UIPinchGestureRecognizer(target: self, action: #selector(pinchImage(sender:)))
        
        imageScrollView.image.addGestureRecognizer(pinchMethod)
    }
    
    @objc
    func pinchImage(sender: UIPinchGestureRecognizer) {
        //guard let sender = sender.view else { return }
        
        if let scale = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)) {
            guard scale.a > 1.0 else {return }
            guard scale.d > 1.0 else { return }
            sender.view?.transform = scale
            sender.scale = 1.0
        }
    }

    func processCaptchaResponse(_ result: ApiResult) -> Void {
        switch result {
        
        case .success(response: let response):
            label.text = "\(response.request!)"
            if let response = Int(response.request!) {
                id = String(response)
            }
            break;
        case .failure(error: let error):
            label.text = "\(error.localizedDescription)"
            break;
        }
    }
    
    func setUpImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.heightAnchor.constraint(equalToConstant: CGFloat(400))
            .isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

}

