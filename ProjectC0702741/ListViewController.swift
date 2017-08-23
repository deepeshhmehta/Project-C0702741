//
//  ListViewController.swift
//  ProjectC0702741
//
//  Created by Deepesh Mehta on 2017-08-22.
//  Copyright © 2017 Deepesh Mehta. All rights reserved.
//

//import requirements

import UIKit
import CoreData

class ListViewController: UIViewController,UITableViewDataSource {
    //swipe left to go to previous page
    @IBAction func showAddPage(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    //initialise data array
    var details :[NSManagedObject] = []
    
    //delegate for table count
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.details.count
    }
    
    //delegate for table data
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let detail = self.details[indexPath.row]
            //self defined table cell UI
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellTableViewCell", for: indexPath) as! MyCellTableViewCell
            
            //fetch required data from coredata
            let bdata = detail.value(forKeyPath: "car_pic")
            let naam = (detail.value(forKeyPath: "name") as? String)
            let car_naam = detail.value(forKeyPath: "car_name") as? String
            let place = detail.value(forKeyPath: "rented_from") as? String

            //process and map data to respective self defined cell element
            cell.nameLabel?.text = naam! + " booked a " + car_naam!
            cell.fromLabel?.text = "from " + place!
            cell.locationUrl? = (detail.value(forKeyPath: "location") as? String)!
            cell.carImage?.image = UIImage(data: bdata as! Data);
            return cell
    }
    //outlet to the table
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        //register table for to be able to dequeuefor cells
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "Cell")
    }
    
    //load data
    override func viewWillAppear(_ animated: Bool) {
        //initialise delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        //set managedContext
        let managedContext =
            appDelegate.persistentContainer.viewContext
        //fetch data
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Details")
        
        //assign fetched data to details array and reload data of table
        do {
            self.details = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
