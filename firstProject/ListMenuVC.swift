//
//  ListMenuVC.swift
//  firstProject
//
//  Created by Tri on 10/14/16.
//  Copyright © 2016 efode. All rights reserved.
//

import UIKit

class ListMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var listMenu: UITableView!
    
    var catalougeIDList = ["1", "2", "3"]
    var catalogueNameList = ["Động vật", "Thực vật", "Thành phố"]
    var imageList = ["img1","img2","img3"]
    
    var catalogueList: [Catalogue]!
    
    var selectedID: String!
    var selectedName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catalogueList = loadCatalogueList()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalogueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.listMenu.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        cell.imageV.image = catalogueList[indexPath.row].image
        cell.descriptionLab.text = catalogueList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedID = catalogueList[indexPath.row].id
        selectedName = catalogueList[indexPath.row].name
        performSegue(withIdentifier: "MenuVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MenuVC {
            destination.catalogueID = selectedID
            destination.catalogueName = selectedName
        }
    }
    
    func loadCatalogueList() -> [Catalogue] {
        var cataList = [Catalogue]()
        // -- TODO load from database
        for i in 0..<catalougeIDList.count {
            let cata = Catalogue()
            cata.id = catalougeIDList[i]
            cata.name = catalogueNameList[i]
            cata.image = UIImage(named: imageList[i])
            cataList.append(cata)
        }
        return cataList
    }

}

class Catalogue {
    var id: String!
    var name: String!
    var image: UIImage!
}
