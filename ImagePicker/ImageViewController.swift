//
//  ImageViewController.swift
//  Tanktaler
//
//  Created by Ilker Baltaci on 11.06.18.
//  Copyright © 2018 Thinxnet. All rights reserved.
//

import Foundation
import UIKit

protocol ImagePickerControllerDelegate: class {
    func imagePickerControllerDidFinish(image: UIImage?, _: ImagePickerController)
}


final  class ImagePickerController: UIImagePickerController {
    weak var imagePickerDelegate: ImagePickerControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePickerDelegate?.imagePickerControllerDidFinish(image: pickedImage, self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerDelegate?.imagePickerControllerDidFinish(image: nil, self)
    }
}

