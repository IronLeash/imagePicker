//
//  ViewController.swift
//  ImagePicker
//
//  Created by Ilker Baltaci on 22.06.18.
//  Copyright © 2018 Ilker Baltaci. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ImagePickerPresenting {

    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapOnSelectImageButton(_ sender: UIButton) {
        
        presentImagePicker { (image) in
            self.imageView.image = image
        }
    }
    
}

