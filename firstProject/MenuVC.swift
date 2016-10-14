//
//  MenuVC.swift
//  firstProject
//
//  Created by Tri on 10/13/16.
//  Copyright © 2016 efode. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var levelSeg: UISegmentedControl!
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var selectBtn: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    var info = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // select image button pressed
    @IBAction func selectBtnPressed(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            selectedImage.contentMode = .scaleAspectFit
            selectedImage.image = pickedImage
        } else {
            print("Something went wrong")
        }
        
        dismiss(animated: true, completion: nil)
    }

    // play button pressed
    @IBAction func playBtnPressed(_ sender: AnyObject) {
        info["level"] = levelSeg.selectedSegmentIndex
        info["image"] = selectedImage.image
        performSegue(withIdentifier: "GameBoardVC", sender: info)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameBoardVC {
            destination.image = info["image"] as! UIImage!
            destination.rowNo = levelSeg.selectedSegmentIndex + 2
            destination.colNo = levelSeg.selectedSegmentIndex + 2
        }
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
