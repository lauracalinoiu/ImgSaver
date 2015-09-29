/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.cameraCaptureMode = .Photo
        picker.modalPresentationStyle = .FormSheet
        picker.delegate = self
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imageScalled = scaleImage(info[UIImagePickerControllerOriginalImage] as! UIImage)
        let imageData = UIImagePNGRepresentation(imageScalled)
        
        let imageFile:PFFile = PFFile(data: imageData!)
        self.dismissViewControllerAnimated(true){
            self.displayAlert()
        }
    
        imageFile.saveInBackgroundWithBlock(){
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("there was an overwhellming success saving on cloud")
            } else {
                print("Image not saved.")
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.picker = UIImagePickerController()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func displayAlert(){
        let alertController = UIAlertController(title: "To the Cloud!", message:
            "The image taken was uploaded on the cloud", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        picker.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func scaleImage(image: UIImage) -> UIImage{
        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.1, 0.1))
        let hasAlpha = false
        let scale: CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scalledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scalledImage
    }
}

