//
//  addNewPersonViewController.swift
//  Contacts
//
//  Created by tk on 19.03.21.
//

import UIKit

class AddNewPersonViewController: UIViewController, UITextFieldDelegate {

    //person
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderSC: UISegmentedControl!
    
    
    @IBOutlet weak var photoIV: UIImageView!
    
    //Address
    @IBOutlet weak var postalTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var streetTF: UITextField!
    @IBOutlet weak var houseNumberTF: UITextField!
    
    var gender: String?
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        //set Age Label with data from Slider
        ageSlider.value = 20
        ageLabel.text = String(Int(ageSlider.value))
        
        setGenderValue(genderSC.selectedSegmentIndex)
        
        
        //close keyboard by touching anywhere
        addTapGestureToDissmissKeyboard()
        
        //setup keyboard observer to scroll up the view if keyboard is presented
        setupKeyboardObserves()
        //delegate only the two top textfields to know when the view shouldnt moved (cause of keyboard)
        firstnameTF.delegate = self
        lastNameTF.delegate = self
        
        //add Tap Gesture to the imageView to select a photo
        addTapGestureToImageView()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addTapGestureToDissmissKeyboard(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleKeyboardDissmiss(_ :)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleKeyboardDissmiss(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    //setup keyboard observer to handle keyboard will show/hide
    func setupKeyboardObserves(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func handleKeyboardWillShow(notification: NSNotification){
        //print(notification) //infos
        //print("handleKeyboardWillShow")
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            //access to firstnameTF and lastnameTF (top textfields)
            if activeField != nil {
                //print("bingo")
                //dont move the view
            }else {
                //move view in relation to keyboard
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
            
               
            }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification){
        //print("handleKeyboardWillHide")
        if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //print("begin editing")
        activeField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("end editing")
        activeField = nil
        
    }
    
    //age slider moved
    @IBAction func ageSlider_moved(_ sender: UISlider) {
        ageLabel.text = String(Int(sender.value))
    }
    
    @IBAction func genderSC_clicked(_ sender: UISegmentedControl) {
        setGenderValue(sender.selectedSegmentIndex)
    }
    
    
    @IBAction func cancelButton_clicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        //print("cancel gedrückt")
    }
    
    @IBAction func addButton_clicked(_ sender: UIButton) {
        //print("Add gedrückt")
        
        if validInputFields() {
            let address = CoreDataDB.instance.createAddress(_postal: postalTF.text!, _city: cityTF.text!, _street: streetTF.text!, _housenumber: Int64(houseNumberTF.text!)! )
            
            let imageAsNSData: NSData = photoIV.image?.pngData() as! NSData
            let creationDate = Int64(Date().timeIntervalSince1970)
            let image = CoreDataDB.instance.createImage(_imageData: imageAsNSData, _creationDate: creationDate)
            
            let person = CoreDataDB.instance.createPerson(_firstname: firstnameTF.text!, _lastname: lastNameTF.text!, _age: Int64(ageLabel.text!)!, _gender: gender!, _image: image, _address: address)
            
            
            //person dem array hinzufügen //geschieht alles in ViewDIDAppear in PErsonTableVIewController schon !!!
            //tabelle aktualiseren
            
            dismiss(animated: true, completion: nil)
        } else {
            showAlertDialog()
        }
    }
    
    //Set the gender value to Male or Woman
    func setGenderValue(_ selectedSegmentIndex: Int) -> Void {
        switch selectedSegmentIndex {
        case 0:
            gender = "M" //Männlich setzen
        case 1:
            gender = "W"
        default:
            break
        }
    }
    
    //check all input Fields before submit
    func validInputFields() -> Bool {
        var valid = false
        
        if !(firstnameTF.text!.isEmpty) && !(lastNameTF.text!.isEmpty) && !(postalTF.text!.isEmpty) && !(cityTF.text!.isEmpty) && !(streetTF.text!.isEmpty) && !(houseNumberTF.text!.isEmpty) &&
            photoIV.image != nil {
            valid = true
        }
        
        return valid
    }
    
    //show alert dialog if the textfields are not filled and the image is not has been set
    func showAlertDialog(){
        let alert = UIAlertController(title: "Achtung!", message: "Bitte alle Felder ausfüllen und Bild wählen", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
   
    //MARK: Choose Image
    func addTapGestureToImageView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapGesture(_ :)))
        photoIV.addGestureRecognizer(tapGesture)
        //set inertaction with view enabled
        photoIV.isUserInteractionEnabled = true
    }

    
    //handle the photo tap gesture
    @objc func handlePhotoTapGesture(_ sender: UITapGestureRecognizer) -> Void {
        askUserForImageSourceType()
    }
    
    func askUserForImageSourceType(){
        
        let alert = UIAlertController(title: "Quelle", message: "Von wo möchtest du dein Profilbild beziehen?", preferredStyle: .alert)
        let galaryAction = UIAlertAction(title: "Galary", style: .default) { (galaryAction) in
            self.chooseImage(source: "galary")
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (cameraAction) in
            self.chooseImage(source: "camera")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (cancelAction) in }
        
        alert.addAction(galaryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //choose Image from Source
    func chooseImage(source: String){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        switch source {
        case "camera":
            
            //Camera dont work @ simulation
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                let alertController = UIAlertController(title: nil, message: "Device has no camera.", preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction!) in
                })

                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                // set sourceType to Camera
                imagePickerController.sourceType = .camera
            }
            
            
            
            break
        case "galary":
            imagePickerController.allowsEditing = true // allow Editing image
            break
        default:
            //Default value
            print("default fall")
            break
        }
        
        
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
  
    
    
    
}


extension AddNewPersonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Called after picking an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //image from edit
        if let editImage = info[.editedImage] as? UIImage {
            photoIV.image = editImage
        } else if let originalImage = info[.originalImage] as? UIImage { //original image
            photoIV.image = originalImage
        } else if let camImage = info[.livePhoto] as? UIImage {
            photoIV.image = camImage
        }
        
        //dissmiss pickercontroller
        dismiss(animated: true, completion: nil)
    }
    

}
