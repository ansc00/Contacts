//
//  PersonInfoViewController.swift
//  Contacts
//
//  Created by tk on 19.03.21.
//

import UIKit

class PersonInfoViewController: UIViewController {

    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var photoIV: UIImageView!
    @IBOutlet weak var firstNameLabe: UILabel!
    @IBOutlet weak var postalLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var housenumberLabel: UILabel!
    
    var person: Person? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //defensiv prog.
        if let firstname = person?.firstname { firstNameLabe.text = firstname }
        if let lastname = person?.lastname { lastNameLabel.text = lastname }
        if let age = person?.age { ageLabel.text = String(age) }
        if let gender = person?.gender  { genderLabel.text = gender }
        
        if let photoImageData = person?.image?.imageData {
            let imageAsNSDATA: NSData = photoImageData as! NSData
            photoIV.image = UIImage(data: imageAsNSDATA as Data, scale: 1.0)
            }
        
        if let postal = person?.address?.postal { postalLabel.text = postal }
        if let city = person?.address?.city { cityLabel.text = city }
        if let street = person?.address?.street  { streetLabel.text = street }
        if let housenumber = person?.address?.housenumber { housenumberLabel.text = String(housenumber) }
    }
    

    //navigation back to PersonTableView //dismiss
    @IBAction func okButton_clicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
