//
//  Menu2VC.swift
//  firstProject
//
//  Created by Tri on 10/15/16.
//  Copyright © 2016 efode. All rights reserved.
//

import UIKit
import CoreData

class Menu2VC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var playMode: UIButton!

    @IBOutlet weak var catalogue: UIPickerView!
    
    @IBOutlet weak var playLevel: UIButton!
    
    @IBOutlet weak var playBtn: UIButton!
    
    var controller: NSFetchedResultsController<Catalogue>!
    var catalogueList: [Catalogue]!
    
    var catalogueNameList = [String]()
    var catalogueIDList = [Int64]()
    var selectedCatalogue: Catalogue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delAllData()
        loatCatalogueFromDB()
        print("View did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View did appeared")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return catalogueList.count
        //return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return catalogueList[row].name
        //return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCatalogue = catalogueList[row]
        
    }
    
    // play mode button pressed
    @IBAction func playModePressed(_ sender: AnyObject) {
        if playMode.tag == 0 {
            playMode.tag = 1
            playMode.setTitle("Không tính giờ", for: .normal)
        } else if playMode.tag == 1 {
            playMode.tag = 0
            playMode.setTitle("Tính giờ", for: .normal)
        }
    }
    
    // play level button pressed
    @IBAction func playLevelPressed(_ sender: AnyObject) {
        if playLevel.tag == 0 {
            playLevel.tag = 1
            playLevel.setTitle("Khó", for: .normal)
        } else if playLevel.tag == 1 {
            playLevel.tag = 0
            playLevel.setTitle("Dễ", for: .normal)
        }
    }
    
    // prepare for perform segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameBoardVC {
            destination.catalogue = selectedCatalogue
            print(selectedCatalogue.name)
            destination.playMode = playMode.tag
            destination.playLevel = playLevel.tag
        }
    }
    
    // play button pressed
    @IBAction func playBtnPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "menu2ToGameBoardVC", sender: self)
    }
    
    // load list of catalogue from database
    func loatCatalogueFromDB() {
        do {
            let fetchRequest: NSFetchRequest<Catalogue> = Catalogue.fetchRequest()
            let sort = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sort]
            catalogueList = try context.fetch(fetchRequest)
            // check if catalogue is empty - the first time launched
            //del all data
            //delAllData()
            if catalogueList.isEmpty {
                // initial database
                create()
            }
            selectedCatalogue = catalogueList.first
        } catch {
            fatalError("Failed")
        }
    }
    
    //del all data
    func delAllData(){
        deleteAllCatalogData()
        deleteAllImageData()
        
    }
    
    //delete catalog data
    func deleteAllCatalogData(){
        
        let fetchRequest: NSFetchRequest<Catalogue> = Catalogue.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data catalog error : \(error) \(error.userInfo)")
        }
    }
    
    //delete image data
    func deleteAllImageData(){
        
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data catalog error : \(error) \(error.userInfo)")
        }
    }
    
    // initial data
    func create() {
        do{
            let catalogueAnimal = Catalogue(context: context)
            // ------------------------
            catalogueAnimal.name = "Con vật"
            catalogueAnimal.details = "Con vật"
            catalogueAnimal.id = 1
            for i in 1...10 {
                let image = Image(context: context)
                image.fileName = "animal\(i)"
                image.name = "Con vật \(i)"
                image.id = Int64(i)
                image.catalogueID = 1
                image.audio = "animal\(i)"
                catalogueAnimal.addToToImage(image)
            }
            // ----------------------
            let catalogueFlower = Catalogue(context: context)
            catalogueFlower.name = "Hoa"
            catalogueFlower.details = "Hoa"
            catalogueFlower.id = 2
            for i in 1...4 {
                let image = Image(context: context)
                image.fileName = "flower\(i)"
                image.name = "Hoa \(i)"
                image.id = Int64(i)
                image.catalogueID = 2
                catalogueFlower.addToToImage(image)
            }
            
            // -----------------------
            let catalogueObject = Catalogue(context: context)
            catalogueObject.name = "Đồ vật"
            catalogueObject.details = "Đồ vật"
            catalogueObject.id = 3
            for i in 1...4 {
                let image = Image(context: context)
                image.fileName = "object\(i)"
                image.name = "Đồ vật \(i)"
                image.id = Int64(i)
                image.catalogueID = 3
                catalogueObject.addToToImage(image)
            }
            try context.save()
            let sort = NSSortDescriptor(key: "name", ascending: true)
            let fetchRequest: NSFetchRequest<Catalogue> = Catalogue.fetchRequest()
            fetchRequest.sortDescriptors = [sort]
            catalogueList = try context.fetch(Catalogue.fetchRequest())
            // initial top highest point
            for cata in catalogueList {
                for i in 1...3 {
                    let pointInfo = PointInfo(context: context)
                    pointInfo.modeType = 0 // Tính giờ
                    pointInfo.toCatalogue = cata
                    pointInfo.topPlace = Int64(i)
                    pointInfo.totalPoint = 0
                }
                for i in 1...3 {
                    let pointInfo = PointInfo(context: context)
                    pointInfo.modeType = 1 // Không tính giờ
                    pointInfo.toCatalogue = cata
                    pointInfo.topPlace = Int64(i)
                    pointInfo.totalPoint = 0
                }
            }
            try context.save()
            
        } catch {
            fatalError("Failed")
        }
        
        
    }

}
