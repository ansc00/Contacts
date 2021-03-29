//
//  ViewController.swift
//  Contacts
//
//  Created by tk on 19.03.21.
//

import UIKit

class PersonTableViewController: UIViewController {

    

    @IBOutlet weak var personTableView: UITableView!
    
    var personsArray = [Person]()
    var selectedPerson: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        personTableView.delegate = self
        personTableView.dataSource = self
        
        //get Width from Screen
        let viewWidth = view.frame.size.width
        //set rowHeight to get an square
        personTableView.rowHeight = viewWidth
        
       
        loadPersonsFromDB()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPersonsFromDB()
    }
    
   
    
    //load All Persons from Database
    func loadPersonsFromDB(){
       
        if let _personsArray = CoreDataDB.instance.loadAllPersonsFromDB() {
            self.personsArray = _personsArray
            //reload TableView
            personTableView.reloadData()
        }
    }
    
    //handle the long press and delete person from DB
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer){
        deletePersonFromDB()
    }
    
    //delete person from DB
    func deletePersonFromDB(){
        
    }

    //MARK: Navigation
    //Give the data (selected Person) to PersonInfo Screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PersonTableToPersonInfo" {
            let personInfoVC = segue.destination as! PersonInfoViewController
            personInfoVC.person = selectedPerson
        }
    }
    
}



//MARK: - UITableViewDataSource
extension PersonTableViewController: UITableViewDataSource {
    //Number of rows taken from the array size
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        personsArray.count
    }
    
    //How the cell should look like
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = personTableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCell
        
        //longPress for delete
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_ :)))
        cell.addGestureRecognizer(longPressRecognizer)
        
        
        let person = personsArray[indexPath.row]
        
        cell.nameLabel.text = person.firstname! + " " + person.lastname!
        let imageAsNSDATA: NSData = person.image?.imageData as! NSData
        cell.photoIV.image = UIImage(data: imageAsNSDATA as Data, scale: 1.0)
        
        //let imageView = UIImageView()
        
        //cell.photoIV.image = person.image?.imageData
        
        return cell
    }
}


//MARK: - UITableViewDelegate
extension PersonTableViewController : UITableViewDelegate{
    
    //person selected perform Segue to Person info Screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPerson = personsArray[indexPath.row]
        
        //Transition to PersonTableViewController
        performSegue(withIdentifier: "PersonTableToPersonInfo", sender: nil)
        
        //deselect row
        personTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //let person = self.personsArray[indexPath.row]
            
            CoreDataDB.instance.deletePersonFromDB(indexPath: indexPath, personsArray: &personsArray)
            //self.personsArray.remove(at: indexPath.row)
            //self.personTableView.deleteRows(at: [indexPath], with: .fade)
            self.personTableView.reloadData()
        }
    }

}



