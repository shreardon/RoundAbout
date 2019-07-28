//
//  ImageViewController.swift
//  RoundAbout
//
//  Created by Shannon Reardon on 6/28/19.
//  Copyright © 2019 Shannon Reardon. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var giftItemLabel: UITextField!
    @IBOutlet weak var storeLabel: UITextField!
    @IBOutlet weak var imageToPunch: UIImageView!
    @IBOutlet weak var priceLabel: UITextField!
    
    var giftListItem: GiftListItem!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if giftListItem == nil {
            giftListItem = GiftListItem(giftItem: "", store: "", price: "")
        }
        giftItemLabel.text = giftListItem.giftItem
        storeLabel.text = giftListItem.store
        priceLabel.text = giftListItem.price
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        giftListItem.giftItem = giftItemLabel.text
        giftListItem.store = storeLabel.text
        giftListItem.price = priceLabel.text
        
        if segue.identifier == "UnwindFromSave" {
            giftListItem.giftItem = giftItemLabel.text
        }
    }
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    func animateImage() {
        let bounds = self.imageToPunch.bounds
        let shrinkValue: CGFloat = 60
        
        //shrink our imageToPunch by 60 pixels
        self.imageToPunch.bounds = CGRect(x:self.imageToPunch.bounds.origin.x + 60, y:self.imageToPunch.bounds.origin.y + 60, width: self.imageToPunch.bounds.size.width - 60, height:self.imageToPunch.bounds.size.height - 60)
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {self.imageToPunch.bounds = bounds}, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageToPunch.image = selectedImage
        
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Action
    @IBAction func libraryPressed(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            
            imagePicker.delegate = self
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlert(title: "Camera Not Available", message: "There is no camera available on this device.")
        }
        
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        animateImage()
    }
}
