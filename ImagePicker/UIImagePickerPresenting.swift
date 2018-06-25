//
//  ImagePickerPresenting.swift
//  Tanktaler
//
//  Created by Ilker Baltaci on 11.06.18.
//  Copyright © 2018 Thinxnet. All rights reserved.
//
//  Localized on 12.06,2018

import Foundation
import AVFoundation
import Photos

private var completionBlock: ((UIImage?) -> Void)?

protocol ImagePickerPresenting: ImagePickerControllerDelegate {
    func presentImagePicker(completion: @escaping (UIImage?) -> Void)
}

extension ImagePickerPresenting where Self: UIViewController {
    
    func presentImagePicker(completion: @escaping (UIImage?) -> Void) {
        
        completionBlock = completion
        let imagePickerViewController = ImagePickerController()
        imagePickerViewController.imagePickerDelegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerViewController.sourceType = .camera
            imagePickerViewController.cameraDevice = .rear
            imagePickerViewController.cameraCaptureMode = .photo
            imagePickerViewController.showsCameraControls = true
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Take Photo".localized, style: .default) { (action) in
                imagePickerViewController.sourceType = .camera
                self.accessCameraWithReminderPrompt(completion: { (accessGranted) in
                    self.present(imagePickerViewController, animated: true, completion: nil)
                })
                
            }
            let gallery = UIAlertAction(title: "Choose Photo".localized, style: .default) { (action) in
                imagePickerViewController.sourceType = .photoLibrary
                self.remindToGiveGalleryWithReminderPrompt(completion: { (accessGranted) in
                    self.present(imagePickerViewController, animated: true, completion: nil)
                })
            }
            
            let cancelAction = UIAlertAction(title: "Abbrechen".localized, style: .cancel) { (action) in
                completionBlock = nil
            }
            
            actionSheet.addAction(camera)
            actionSheet.addAction(gallery)
            actionSheet.addAction(cancelAction)
            self.present(actionSheet, animated: true, completion: nil)
        } else {
            imagePickerViewController.sourceType = .photoLibrary
            imagePickerViewController.imagePickerDelegate = self
            imagePickerViewController.isNavigationBarHidden = false
            imagePickerViewController.isToolbarHidden = true
            self.present(imagePickerViewController, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidFinish(image: UIImage?, _ viewController: ImagePickerController) {
        
        completionBlock?(image)
        completionBlock = nil
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func accessCameraWithReminderPrompt(completion:@escaping (_ accessGranted: Bool)->()) {
        let accessRight = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch accessRight {
        case .authorized:
            completion(true)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if granted == true  {
                    completion(true)
                    return
                }
                self.alertCameraAccessNeeded()
            })
        case .denied, .restricted:
            self.alertCameraAccessNeeded()
            
            break
        }
    }
    
    func remindToGiveGalleryWithReminderPrompt(completion:@escaping (_ accessGranted: Bool)->()) {
        
        let accessRight = PHPhotoLibrary.authorizationStatus()
        
        switch accessRight {
        case .authorized:
            completion(true)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    completion(true)
                    return
                }
                self.alertPhotosAccessNeeded()
            }
        case .denied, .restricted:
            alertPhotosAccessNeeded()
            break
        }
    }
    
    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplicationOpenSettingsURLString)!
        
        let alert = UIAlertController(
            title: "TCO_camera_access".localized,
            message: "TCO_camera_access_message".localized,
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        alert.addAction(UIAlertAction(title: "Abbrechen".localized, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "TCO_camera_access".localized, style: .cancel, handler: { (alert) -> Void in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(settingsAppURL)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func alertPhotosAccessNeeded() {
        let settingsAppURL = URL(string: UIApplicationOpenSettingsURLString)!
        
        let alert = UIAlertController(
            title: "TCO_photos_access".localized,
            message: "TCO_photos_access_message".localized,
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        alert.addAction(UIAlertAction(title: "Abbrechen".localized, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "TCO_photos_access".localized, style: .cancel, handler: { (alert) -> Void in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(settingsAppURL)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
