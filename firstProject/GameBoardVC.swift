//
//  ViewController.swift
//  firstProject
//
//  Created by Tri on 10/13/16.
//  Copyright © 2016 efode. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class GameBoardVC: UIViewController {

    var cellGameArray = Array<Array<CellGame>>()
    
    var colNo = 2 // default column number
    
    var rowNo = 2 // default row number
    
    var image =  UIImage() // current playing image
    
    var boardGame = UIView()
    
    var isSecondClick = false // check if there is second click
    
    var previousCell : CellGame! // store previous cliked cell info
    
    var switchSound: AVAudioPlayer! // sound of switching tiles
    
    var winningSound: AVAudioPlayer! // winning sound
    
    var seconds:Float = 0.0 // time on second
    
    var timer = Timer() // timer object
    
    var isFirstTap = true // check if first tab to active timer
    
    let timerBar = UIProgressView()
    
    // ------New feature: Random photo from list-----------------
    var playMode = 0 // 0: Tính giờ, 1: Không tính giờ
    var playLevel = 0 // 0: Dễ, 1: Khó
    
    var catalogue: Catalogue!
    var unsolvedImageList:[Image]!
    var solvedImageList = [Image]()
    var doingImage: Image!
    let numUpLevel = 3 // Number of solved images to increase level
    var upLevelTimes = 1 // Number of times of leveling
    let timeLimit:Float = 10 // seconds
    //------------------------------------------------------------
    
    let imageView = UIImageView() // UIImange for reference original image
    
    func getImageListFromCatalogue(){
        // -- TODO load from database
//        for img in catalogue.toImage! {
//            images.append(img as! Image)
//        }
        do {
            let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "toCatalogue == %@", catalogue)
            let sort = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sort]
            unsolvedImageList = try context.fetch(fetchRequest)
        } catch {
            fatalError("Failed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Easy level
        if playLevel == 0 {
            colNo = 2
            rowNo = 2
        } else {
            // hard level
            colNo = 4
            rowNo = 4
        }
        // ------New feature: Random photo from list-----------------
        // load image list TODO
        getImageListFromCatalogue()
        let randomIndex = random(max: unsolvedImageList.count)
        doingImage = unsolvedImageList.remove(at: randomIndex) 
        image = UIImage(named: doingImage.fileName!)!
        // ----------------------------------------------------------
        self.boardGame.isUserInteractionEnabled = true
        self.view.backgroundColor = UIColor.cyan
        // reference original photo view
        imageView.frame = CGRect(x: UIScreen.main.bounds.width/4, y: 60 , width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height / 4)
        self.view.addSubview(imageView)
        makeGameBoard()
        self.view.addSubview(boardGame)
        // --------- TODO ----------
        let advertiment = UILabel()
        advertiment.text = "Advertiment here!"
        advertiment.textAlignment = .center
        advertiment.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 30, width: UIScreen.main.bounds.width, height: 30)
        self.view.addSubview(advertiment)
        // -----------------------
        // Switch sound
        let switchPath = Bundle.main.path(forResource: "switch", ofType: "wav")
        let switchURL = URL(fileURLWithPath: switchPath!)
        // Sinning sound
        let winningPath = Bundle.main.path(forResource: "won", ofType: "wav")
        let winningURL = URL(fileURLWithPath: winningPath!)
        do {
            try switchSound = AVAudioPlayer(contentsOf: switchURL)
            try winningSound = AVAudioPlayer(contentsOf: winningURL)
        } catch(let err as NSError) {
            print(err.debugDescription)
        }
        playWinningSound() // FIXME change to welcome sound
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // play switch cells sound
    func playSwitchSound() {
        if switchSound.isPlaying {
            switchSound.stop()
        }
        switchSound.play()
    }
    
    // play winning sound
    func playWinningSound() {
        if winningSound.isPlaying {
            winningSound.stop()
        }
        winningSound.play()
    }
    
    // cell tapped event
    func tapDetected(_ sender: UITapGestureRecognizer) {
        if isFirstTap == true {
            startTimer()
            isFirstTap = false
        }
        let cell = findCell(point: sender.location(in: boardGame))
        if previousCell != nil {
            if !(cell.x == previousCell?.x && cell.y == previousCell?.y) {
                let xTmp = previousCell?.x
                let yTmp = previousCell?.y
                let imageTmp = previousCell?.cellImage?.image
                previousCell?.x = cell.x
                previousCell?.y = cell.y
                previousCell?.cellImage?.image = cell.cellImage?.image
                cell.x = xTmp
                cell.y = yTmp
                cell.cellImage?.image = imageTmp
                // play switch pies sound
                playSwitchSound()
                // check complete
                if(checkComplete() == true) {
                    solvedImageList.append(doingImage)
                    if unsolvedImageList.count != 0 {
                        let randomIndex = random(max: unsolvedImageList.count)
                        doingImage = unsolvedImageList.remove(at: randomIndex)
                        image = UIImage(named: doingImage.fileName!)!
                        makeGameBoard()
                        playWinningSound()
                    } else {
                        playWinningSound()
                        stopTimer()
                    }
                }
            }
            previousCell?.cellImage?.layer.opacity = 1
            previousCell = nil
        } else {
            previousCell = cell
            cell.cellImage?.layer.opacity = 0.2
            
        }
        self.view.setNeedsDisplay()
    }
    
    // find cell based on x, y coordinate
    func findCell(point: CGPoint) -> CellGame {
        let x:Int = Int(point.x / (boardGame.frame.width / CGFloat(colNo)))
        let y:Int = Int(point.y / (boardGame.frame.height / CGFloat(rowNo)))
        return cellGameArray[x][y]
    }
    
    // check if the game board is completed
    func checkComplete() -> Bool {
        for i in 0..<colNo {
            for j in 0..<rowNo {
                if(!(cellGameArray[i][j].x == cellGameArray[i][j].tobeX && cellGameArray[i][j].y == cellGameArray[i][j].tobeY)) {
                    return false
                }
            }
        }
        return true
    }
    
    // create game board
    func makeGameBoard(){
        // timer progress bar
        timerBar.progressImage = UIImage(named: "progressBar")
        timerBar.frame = CGRect(x: 0, y: UIScreen.main.bounds.height/2 - 40, width: UIScreen.main.bounds.width, height: 20)
        self.view.addSubview(timerBar)
        // end - timer progress bar
        imageView.image = image
        boardGame.frame = CGRect(x: 10, y: UIScreen.main.bounds.height/2 - 30, width: UIScreen.main.bounds.width-20 , height: (UIScreen.main.bounds.height)/2)
        // remeove old tiles from board
        for view in boardGame.subviews {
            view.removeFromSuperview()
        }
        // setting row and col number based on mode and number of solved photo
        // Mode Tính giờ
        if playMode == 0 {
            // TODO
        } else {
            // Mode không tính giờ
            // if player has solved more than specified x pics, increase level
            if solvedImageList.count > (numUpLevel * upLevelTimes) {
                if colNo > rowNo {
                    rowNo = rowNo + 1
                } else {
                    colNo = colNo + 1
                }
                upLevelTimes = upLevelTimes + 1
            }
        }
        cellGameArray = Array(repeating: Array(repeating : CellGame(), count: rowNo), count: colNo)
        // create tiles
        for i in 1...colNo {
            for j in 1...rowNo {
                let tmpImageView = UIImageView()
                tmpImageView.frame = CGRect(x: CGFloat(i - 1) * (boardGame.frame.width / CGFloat(colNo)) , y: CGFloat(j - 1) * (boardGame.frame.height / CGFloat(rowNo)), width: boardGame.frame.width / CGFloat(colNo), height: boardGame.frame.height / CGFloat(rowNo))
                let tmpImage = image.splitImage(rowNo: CGFloat(rowNo), colNo: CGFloat(colNo), xOrder: CGFloat(i-1), yOrder: CGFloat(j-1))
                tmpImageView.image = tmpImage
                let cellGame = CellGame()
                cellGame.x = i
                cellGame.y = j
                cellGame.tobeX = i
                cellGame.tobeY = j
                cellGame.cellImage = tmpImageView
                cellGameArray[i-1][j-1] = cellGame
                for j in 0..<cellGameArray.count {
                    for i in 0..<self.cellGameArray[j].count {
                        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected(_:)))
                        singleTap.numberOfTapsRequired = 1
                        singleTap.numberOfTouchesRequired = 1
                        let tmpImage = cellGameArray[j][i]
                        tmpImage.cellImage?.isUserInteractionEnabled = true
                        tmpImage.cellImage?.addGestureRecognizer(singleTap)
                    }
                }
                boardGame.addSubview(tmpImageView)
            }
        }
        // random cells
        mixingCells(times: 5)
    }
    
    func random(max: Int) -> Int {
        let randomNum:UInt32 = arc4random_uniform(UInt32(max)) // range is 0 to max - 1
        print(randomNum)
        return Int(randomNum)
    }
    
    func mixingCells(times: Int) {
        for _ in 1...times {
            for row in 0..<rowNo {
                for col in 0..<colNo {
                    let cell1 = cellGameArray[col][row]
                    let xTmp = cell1.x
                    let yTmp = cell1.y
                    let imageTmp = cell1.cellImage?.image
                    let cell2 = cellGameArray[random(max: colNo)][random(max: rowNo)]
                    cell1.x = cell2.x
                    cell1.y = cell2.y
                    cell1.cellImage?.image = cell2.cellImage?.image
                    cell2.x = xTmp
                    cell2.y = yTmp
                    cell2.cellImage?.image = imageTmp
                }
            }
        }
        
    }

    // back button pressed
    @IBAction func backBtnPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // start timer: 0.1s
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameBoardVC.updateTime), userInfo: nil, repeats: true)
    }
    
    // update time : add 0.1s
    func updateTime() {
        seconds += 0.1
        timerBar.progress = seconds.divided(by: timeLimit)
    }
    
    // stop timer
    func stopTimer() {
        timer.invalidate()
    }
}

class CellGame {
    var x: Int?
    
    var y: Int?
    
    var tobeX: Int?
    
    var tobeY: Int?
    
    var cellImage : UIImageView?
    
}

// add split image extension for UIImage
extension UIImage {
    func splitImage(rowNo: CGFloat, colNo: CGFloat, xOrder: CGFloat, yOrder: CGFloat) -> UIImage? {
        guard let
            newImage = self.cgImage!.cropping(to: CGRect(origin: CGPoint(x: size.width/colNo * xOrder, y: size.height/rowNo * yOrder), size: CGSize(width:
                size.width/colNo, height: size.height/rowNo)))
            else { return nil }
        return UIImage(cgImage: newImage, scale: 1, orientation: imageOrientation)
    }
}

