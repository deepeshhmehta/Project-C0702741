//
//  AddViewController.swift
//  ProjectC0702741
//
//  Created by Deepesh Mehta on 2017-08-22.
//  Copyright © 2017 Deepesh Mehta. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBAction func selectExistingPictureOrVideo(_ sender: UIButton) {
        pickMediaFromSource(sourceType: UIImagePickerControllerSourceType.photoLibrary)
    }
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var rented_from: UITextField!
    @IBOutlet weak var car_name: UITextField!
    @IBOutlet weak var imageView: UIImageView!

    var car_image : UIImage?
    var chosenMediaType : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func reset(_ sender: Any) {
        name.text = ""
        age.text = ""
        location.text = ""
        rented_from.text = ""
        car_image = nil
        car_name.text = ""
    }
    
    @IBAction func save(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Details",
                                       in: managedContext)!
        
        let details = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        details.setValue(name.text, forKeyPath: "name")
        details.setValue(age.text, forKeyPath: "age")
        details.setValue(location.text, forKeyPath: "current_location")
        details.setValue(rented_from.text, forKeyPath: "rented_from")
        let bData = UIImagePNGRepresentation(self.car_image!)
        details.setValue(bData, forKeyPath: "car_pic")
        details.setValue(car_name.text, forKeyPath: "car_name")
        
        
        // 4
        do {
            try managedContext.save()
            print("saved")
            self.reset(sender)
            //people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
    
    func pickMediaFromSource(sourceType:UIImagePickerControllerSourceType) {
        let mediaTypes =
            UIImagePickerController.availableMediaTypes(for: sourceType)!
        
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType)
            && mediaTypes.count > 0 {
            let picker = UIImagePickerController()
            picker.mediaTypes = mediaTypes
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            present(picker, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title:"Error accessing media",
                                                    message: "Unsupported media source.",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        self.car_image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        picker.dismiss(animated: true, completion: nil)
//
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.car_image = image
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
