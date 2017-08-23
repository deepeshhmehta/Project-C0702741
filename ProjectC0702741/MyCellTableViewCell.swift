//
//  MyCellTableViewCell.swift
//  ProjectC0702741
//
//  Created by Deepesh Mehta on 2017-08-23.
//  Copyright © 2017 Deepesh Mehta. All rights reserved.
//


import UIKit

class MyCellTableViewCell: UITableViewCell {
    //MARK: Properties
        //properties & outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var fromLabel: UILabel!
    var locationUrl : String!
    
    //open and show loaction in a mapview
    @IBAction func openLocation(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: locationURL!)!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
