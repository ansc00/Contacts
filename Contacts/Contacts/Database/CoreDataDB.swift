//
//  CoreDataDB.swift
//  Contacts
//
//  Created by tk on 20.03.21.
//

import Foundation
import CoreData

class CoreDataDB {
    
    // MARK: - Singleton Pattern
    static let instance = CoreDataDB()
    
    // MARK: - Context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init(){
        
    }
   
    
    
    
// MARK: - Core Data stack

lazy var persistentContainer: NSPersistentContainer = {
    //WICHTIG !!!
    let container = NSPersistentContainer(name: "Contacts") //<- muss wie die datei .xcdatamodel heissen !!!
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()

// MARK: - Core Data Saving support

func saveContext() {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
    
    
    // MARK: - CRUD - Create /Read / Update / Delete
    
    //Create
    func createPerson(_firstname: String, _lastname: String, _age: Int64, _gender: String, _image: Image ,_address: Address) -> Person {
        let person = Person(context: context)
        person.firstname = _firstname
        person.lastname = _lastname
        person.gender = _gender
        person.age = _age
        
        person.image = _image
        person.address = _address
        
       
        saveContext()
        
        return person
        
    }
    
    
    func createImage(_imageData: NSData, _creationDate: Int64 ) -> Image {
        let image = Image(context: context)
        image.imageData = _imageData as Data
        image.creationDate = _creationDate
        
       
        saveContext()
        
        return image
        
    }
    
    func createAddress(_postal: String, _city: String, _street: String, _housenumber: Int64) -> Address{
        let address = Address(context: context)
        address.postal = _postal
        address.city = _city
        address.street = _street
        address.housenumber = _housenumber
        
        saveContext()
        
        return address
    }
    
    
    
    //Read
    func loadAllPersonsFromDB() -> [Person]?{
        //Nur die Anfrage
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            let resultArray = try context.fetch(fetchRequest)
            return resultArray
        } catch {
            print("Fehler beim laden der Daten", error.localizedDescription)
        }
        return nil
    }
    
    
    func deletePersonFromDB(indexPath: IndexPath, personsArray: inout [Person]){
        //aus coredata löschen
        //person löschen
        context.delete(personsArray[indexPath.row])
        //beziehungen löschen
        context.delete(personsArray[indexPath.row].image!)
        context.delete(personsArray[indexPath.row].address!)
        
        //aus dem array löschen
        personsArray.remove(at: indexPath.row)
        
        //abspeichern in coreData
        saveContext()
    }


}
