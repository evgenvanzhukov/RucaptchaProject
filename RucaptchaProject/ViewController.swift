//
//  ViewController.swift
//  RucaptchaProject
//
//  Created by Evgen on 20.11.2022.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var captchaService = RucaptchaService()
    var id: String?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func loadBtnPressed(_ sender: Any) {
        var image = UIImagePickerController()
        
        image.delegate = self
        image.allowsEditing = true
        image.sourceType = .photoLibrary
        self.present(image, animated: true) {
            
        }
        
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        captchaService.sedToRecognize(imageView.image!, completion: processCaptchaResponse)
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
            self.imageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

}

