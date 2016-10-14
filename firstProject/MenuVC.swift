//
//  MenuVC.swift
//  firstProject
//
//  Created by Tri on 10/13/16.
//  Copyright © 2016 efode. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var imageListTV: UITableView!
    
    var catalogueID: String!
    var catalogueName: String!
    
    var selectedLevel: Int!
    
    var imageList: [Image]!
    
    var imageInfo: Image!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageList = loadImageList()
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.imageListTV.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageCell
        cell.imageV.image = UIImage(named: imageList[indexPath.row].id)
        cell.nameLab.text = "\(indexPath.row+1). \(imageList[indexPath.row].name!)"
        cell.imageInfo = imageList[indexPath.row]
        cell.level1Btn.tag = indexPath.row
        cell.level2Btn.tag = indexPath.row
        cell.level3Btn.tag = indexPath.row
        cell.level4Btn.tag = indexPath.row
        cell.level1Btn.addTarget(self, action: #selector(self.level1Btn), for: .touchUpInside)
        cell.level2Btn.addTarget(self, action: #selector(self.level2Btn), for: .touchUpInside)
        cell.level3Btn.addTarget(self, action: #selector(self.level3Btn), for: .touchUpInside)
        cell.level4Btn.addTarget(self, action: #selector(self.level4Btn), for: .touchUpInside)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameBoardVC {
            destination.image = UIImage(named: imageInfo.id)
            destination.colNo = selectedLevel + 1
            destination.rowNo = selectedLevel + 1
        }
    }
    
    func level1Btn(sender: UIButton) {
        imageInfo = imageList[sender.tag]
        selectedLevel = 1
        performSegue(withIdentifier: "GameBoardVC", sender: self)
    }
    
    func level2Btn(sender: UIButton) {
        imageInfo = imageList[sender.tag]
        selectedLevel = 2
        performSegue(withIdentifier: "GameBoardVC", sender: self)
    }
    
    func level3Btn(sender: UIButton) {
        imageInfo = imageList[sender.tag]
        selectedLevel = 3
        performSegue(withIdentifier: "GameBoardVC", sender: self)
    }
    
    func level4Btn(sender: UIButton) {
        imageInfo = imageList[sender.tag]
        selectedLevel = 4
        performSegue(withIdentifier: "GameBoardVC", sender: self)
    }

    
    func loadImageList() -> [Image] {
        var images = [Image]()
        // -- TODO load from database
        for i in 1...10 {
            let image = Image()
            image.id = "img\(i)"
            image.name = "Image \(i)"
            image.catalogueID = catalogueID
            images.append(image)
        }
        return images
    }
    
}

class Image {
    var id: String!
    var fileName: String!
    var name: String!
    var catalogueID: String!
}

class UserImageInfo {
    var userID: String!
    var imageID: String!
    var time: Int!
    var moves: Int!
    var point: Int!
    
}
