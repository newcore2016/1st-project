//
//  ViewController.swift
//  firstProject
//
//  Created by Tri on 10/13/16.
//  Copyright © 2016 efode. All rights reserved.
//

import UIKit
import AVFoundation

class GameBoardVC: UIViewController {
    
    var cellGameArray = Array<Array<CellGame>>()
    
    var colNo: Int!
    
    var rowNo: Int!
    
    var image: UIImage!
    
    var boardGame = UIView()
    
    var isSecondClick = false
    
    var previousCell : CellGame?
    
    var switchSound: AVAudioPlayer!
    
    var winningSound: AVAudioPlayer!
    
    let timeLabel = UILabel()
    
    var seconds = 0
    
    var timer = Timer()
    
    var isFirstTap = true
    
    var imageInfo: Image!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // -----Test---------
//        photoName = "img01"
//        rowNo = 3
//        colNo = 3
        //-------------------
        self.cellGameArray = Array(repeating: Array(repeating : CellGame(), count: rowNo), count: colNo)
        self.boardGame.isUserInteractionEnabled = true
        self.view.backgroundColor = UIColor.cyan
        // reference original photo view
        let firstFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-20 , height: (UIScreen.main.bounds.height - 30 ) / 2)
        let imageView = UIImageView()
        imageView.frame = CGRect(x: UIScreen.main.bounds.width/4, y: 60 , width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height / 4)
//        let image = UIImage(named: photoName!)
        imageView.image = image
        self.view.addSubview(imageView)
        timeLabel.text = "0"
        print(timeLabel.font.fontName)
        timeLabel.font = UIFont(name: timeLabel.font.fontName, size: 30)
        timeLabel.frame = CGRect(x: 0, y: UIScreen.main.bounds.height/2 - 90 , width: firstFrame.width, height: 40)
        timeLabel.textAlignment = .center
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textColor = UIColor.red
        self.view.addSubview(timeLabel)
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
        playWinningSound()
        
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
                if(checkComplete() == true) {
                    playWinningSound()
                    stopTimer()
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
        for i in 0..<colNo! {
            for j in 0..<rowNo! {
                if(!(cellGameArray[i][j].x == cellGameArray[i][j].tobeX && cellGameArray[i][j].y == cellGameArray[i][j].tobeY)) {
                    return false
                }
            }
        }
        return true
    }
    
    // create game board
    func makeGameBoard(){
        boardGame.frame = CGRect(x: 10, y: UIScreen.main.bounds.height/2 - 30, width: UIScreen.main.bounds.width-20 , height: (UIScreen.main.bounds.height)/2)
//        let image = UIImage(named: photoName!)
        for i in 1...colNo! {
            for j in 1...rowNo! {
                let tmpImageView = UIImageView()
                tmpImageView.frame = CGRect(x: CGFloat(i - 1) * (boardGame.frame.width / CGFloat(colNo!)) , y: CGFloat(j - 1) * (boardGame.frame.height / CGFloat(rowNo!)), width: boardGame.frame.width / CGFloat(colNo!), height: boardGame.frame.height / CGFloat(rowNo!))
                //                print(tmpImageView.frame.minX)
                //                print(tmpImageView.frame.minY)
                //                print(tmpImageView.frame.maxX)
                //                print(tmpImageView.frame.maxY)
                let tmpImage = image?.splitImage(rowNo: CGFloat(rowNo!), colNo: CGFloat(colNo!), xOrder: CGFloat(i-1), yOrder: CGFloat(j-1))
                //                print(tmpImage?.size.width)
                //                print(tmpImage?.size.height)
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
        mixingCells(times: 1)
    }
    func random(max: Int) -> Int {
        let randomNum:UInt32 = arc4random_uniform(UInt32(max)) // range is 0 to max - 1
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
                    let cell2 = cellGameArray[random(max: col)][random(max: row)]
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
    
    // start timer
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameBoardVC.updateTime), userInfo: nil, repeats: true)
    }
    
    // update time : add 1
    func updateTime() {
        seconds += 1
        timeLabel.text = "\(seconds)"
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

