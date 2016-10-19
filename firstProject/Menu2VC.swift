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
        loatCatalogueFromDB()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return catalogueList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return catalogueList[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCatalogue = catalogueList[row]
    }
    
    @IBAction func playModePressed(_ sender: AnyObject) {
        if playMode.tag == 0 {
            playMode.tag = 1
            playMode.setTitle("Không tính giờ", for: .normal)
        } else if playMode.tag == 1 {
            playMode.tag = 0
            playMode.setTitle("Tính giờ", for: .normal)
        }
    }
    
    @IBAction func playLevelPressed(_ sender: AnyObject) {
        if playLevel.tag == 0 {
            playLevel.tag = 1
            playLevel.setTitle("Khó", for: .normal)
        } else if playLevel.tag == 1 {
            playLevel.tag = 0
            playLevel.setTitle("Dễ", for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameBoardVC {
            destination.catalogue = selectedCatalogue
            print(selectedCatalogue.name)
            destination.playMode = playMode.tag
            destination.playLevel = playLevel.tag
        }
    }
    

    @IBAction func playBtnPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "menu2ToGameBoardVC", sender: self)
    }
    
    func loatCatalogueFromDB() {
        do {
            let fetchRequest: NSFetchRequest<Catalogue> = Catalogue.fetchRequest()
            let sort = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sort]
            catalogueList = try context.fetch(fetchRequest)
            selectedCatalogue = catalogueList.first
            
            // initial top highest point
//            for cata in catalogueList {
//                for i in 1...3 {
//                    let pointInfo = PointInfo(context: context)
//                    pointInfo.modeType = 0 // Tính giờ
//                    pointInfo.toCatalogue = cata
//                    pointInfo.topPlace = Int64(i)
//                    pointInfo.totalPoint = 0
//                }
//                for i in 1...3 {
//                    let pointInfo = PointInfo(context: context)
//                    pointInfo.modeType = 1 // Không tính giờ
//                    pointInfo.toCatalogue = cata
//                    pointInfo.topPlace = Int64(i)
//                    pointInfo.totalPoint = 0
//                }
//            }
//            try context.save()
        } catch {
            fatalError("Failed")
        }
    }
    
    func create() {
        do{
            let catalogue = Catalogue(context: context)
            catalogue.name = "Đồ vật"
            catalogue.details = "Đồ vật"
            catalogue.id = 3
            for i in 1...4 {
                let image = Image(context: context)
                image.fileName = "object\(i)"
                image.name = "Đồ vật \(i)"
                image.id = Int64(i)
                image.catalogueID = 3
                catalogue.addToToImage(image)
            }
            try context.save()
            let catalogueList = try context.fetch(Catalogue.fetchRequest())
            print(catalogueList.count)
            for i in 0..<catalogueList.count {
                let cata = catalogueList[i] as! Catalogue
                for img in cata.toImage! {
                    let im = img as! Image
                    print(im.name!)
                }
            }
            
        } catch {
            fatalError("Failed")
        }
        
    }

}
