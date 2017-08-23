//
//  AddViewController.swift
//  ProjectC0702741
//
//  Created by Deepesh Mehta on 2017-08-22.
//  Copyright © 2017 Deepesh Mehta. All rights reserved.
//

//import all that is necessary for image and location
import UIKit
import CoreData
import AVFoundation
import MobileCoreServices
import CoreLocation

//set global variables for transfer
var car_image : UIImage?
var locationURL : String?


class AddViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{

    //swipe gesture to switch between screens
    @IBAction func showListView(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    
    //opens the photo picker to select a picture to upload
    @IBAction func selectExistingPictureOrVideo(_ sender: UIButton) {
        pickMediaFromSource(sourceType: UIImagePickerControllerSourceType.photoLibrary)
    }
    
    //outlets of other fields from the app
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var rented_from: UITextField!
    @IBOutlet weak var car_name: UITextField!
    @IBOutlet weak var imageView: UIImageView!

    //the location manager that we shall use to get user's locations
    private let locationManager = CLLocationManager()
    var chosenMediaType : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //take permission and pull user location when the view loads
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //the reset button to reset the form in case the user wants to start all over
    @IBAction func reset(_ sender: Any) {
        name.text = ""
        age.text = ""
        rented_from.text = ""
        car_image = nil
        imageView.image = nil
        car_name.text = ""
    }
    
    //the save method which calls the core data managing object and add's data to it
    @IBAction func save(_ sender: Any) {
        //get appDelegate
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1 make a managed context out of it
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2 pick the particular entitiy and instantiate an object
        let entity =
            NSEntityDescription.entity(forEntityName: "Details",
                                       in: managedContext)!
        let details = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3 set all the values as they are
        details.setValue(name.text, forKeyPath: "name")
        details.setValue(age.text, forKeyPath: "age")
        details.setValue(locationURL, forKeyPath: "current_location")
        details.setValue(rented_from.text, forKeyPath: "rented_from")
        details.setValue(car_name.text, forKeyPath: "car_name")
        
        //convert image to binary data
        let bData = UIImagePNGRepresentation(car_image!)
        details.setValue(bData, forKeyPath: "car_pic")
        
        
        
        // 4 save data and reset the form
        do {
            try managedContext.save()
            self.reset(sender)
            //people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
    
    //action function for image picker
    func pickMediaFromSource(sourceType:UIImagePickerControllerSourceType) {
        let mediaTypes =
            UIImagePickerController.availableMediaTypes(for: sourceType)!
        
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType)
            && mediaTypes.count > 0 {
            //initialise picker
            let picker = UIImagePickerController()
            //set mediatype
            picker.mediaTypes = mediaTypes
            //set delegate
            picker.delegate = self
            picker.allowsEditing = true
            //set sourceType
            picker.sourceType = sourceType
            //show Picker
            present(picker, animated: true, completion: nil)
        } else {
            //Error Handling
            let alertController = UIAlertController(title:"Error accessing media",
                                                    message: "Unsupported media source.",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    //delegate function for picker
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let lastChosenMediaType = info[UIImagePickerControllerMediaType] as? String
        if let mediaType = lastChosenMediaType {
            if mediaType == (kUTTypeImage as NSString) as String {
                //save picked image in global variable for sharing
                car_image = info[UIImagePickerControllerEditedImage] as? UIImage
                //set the image in the temp imageview
                imageView.image = car_image
            } else if mediaType == (kUTTypeMovie as NSString) as String {
                //void if video
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //delegate for location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //save location in URL format
        let latitude = String(describing: manager.location!.coordinate.latitude)
        let longitude = String(describing: manager.location!.coordinate.longitude)
        locationURL = "http://maps.google.com/maps?q=loc:\(latitude),\(longitude)"        
    }
    //location error delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
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
