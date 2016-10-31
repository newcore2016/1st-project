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
    
    var boardGame = UIImageView()
    
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
    let timeLimit:Float = 30 // seconds
    var firstCell: CellGame!
    var newCell: CellGame!
    var scoreLabel = UILabel()
    var score:Int = 0
    //------------------------------------------------------------
    
    let imageView = UIImageView() // UIImange for reference original image
    // Switch sound
    var switchPath: String!
    var switchURL: URL!
    // Sinning sound
    var winningPath: String!
    var winningURL: URL!
    var gameOverMenu: UIView!
    
    //continue button
    var continueBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "grass")
        self.view.insertSubview(backgroundImage, at: 0)
        // Switch sound
        switchPath = Bundle.main.path(forResource: "switch", ofType: "wav")
        switchURL = URL(fileURLWithPath: switchPath!)
        // Sinning sound
        winningPath = Bundle.main.path(forResource: "won", ofType: "wav")
        winningURL = URL(fileURLWithPath: winningPath!)
        createGame()
        
    }
    
    func createGame() {
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
        // load image list
        getImageListFromCatalogue()
        let randomIndex = random(max: unsolvedImageList.count)
        doingImage = unsolvedImageList.remove(at: randomIndex)
        image = UIImage(named: doingImage.fileName!)!
        // ----------------------------------------------------------
        self.boardGame.isUserInteractionEnabled = true
//        let backgroundImage = UIImageView(frame:boardGame.bounds)
//        backgroundImage.image = UIImage(named: "wood")
//        self.boardGame.insertSubview(backgroundImage, at: 0)
        boardGame.image = UIImage(named: "wood")
        // reference original photo view
        imageView.frame = CGRect(x: UIScreen.main.bounds.width/4, y: 60 , width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height / 4)
        self.view.addSubview(imageView)
        scoreLabel.text = "0"
        scoreLabel.font = UIFont(name: scoreLabel.font.fontName, size: 30)
        scoreLabel.frame = CGRect(x: 0, y: UIScreen.main.bounds.height/2 - 90 , width: UIScreen.main.bounds.width, height: 40)
        scoreLabel.textAlignment = .center
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.textColor = UIColor.red
        self.view.addSubview(scoreLabel)
        makeGameBoard()
        self.view.addSubview(boardGame)
        // --------- TODO ----------
        let advertiment = UILabel()
        advertiment.text = "Advertiment here!"
        advertiment.textAlignment = .center
        advertiment.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 30, width: UIScreen.main.bounds.width, height: 30)
        self.view.addSubview(advertiment)
        // -----------------------
        do {
            try switchSound = AVAudioPlayer(contentsOf: switchURL)
            try winningSound = AVAudioPlayer(contentsOf: winningURL)
        } catch(let err as NSError) {
            print(err.debugDescription)
        }
        playWinningSound() // FIXME change to welcome sound
    }
    
    // play switch cells sound
    func playSwitchSound() {
        if switchSound.isPlaying {
            switchSound.stop()
            do {
                try switchSound = AVAudioPlayer(contentsOf: switchURL)
            } catch(let err as NSError) {
                print(err.debugDescription)
            }
        }
        switchSound.play()
    }
    
    // play winning sound
    func playWinningSound() {
        if winningSound.isPlaying {
            winningSound.stop()
            do {
                try winningSound = AVAudioPlayer(contentsOf: winningURL)
            } catch(let err as NSError) {
                print(err.debugDescription)
            }
        }
        winningSound.play()
    }
    
    func playAudio(){
        
    }
    

    
    // cell tapped event
    func tapDetected(_ sender: UITapGestureRecognizer) {
        if isFirstTap == true {
            // if mode is Tính giờ
            if playMode == 0 {
                startTimer()
            }
            isFirstTap = false
        }
        let cell = findCell(point: sender.location(in: boardGame))
        if previousCell != nil {
            if !(cell.x == previousCell?.x && cell.y == previousCell?.y) {
                let xTmp = previousCell?.x
                let yTmp = previousCell?.y
                let imageTmp = previousCell?.image
                previousCell?.x = cell.x
                previousCell?.y = cell.y
                previousCell?.image = cell.image
                cell.x = xTmp
                cell.y = yTmp
                cell.image = imageTmp
                // play switch pies sound
                playSwitchSound()
                // check complete
                if(checkComplete() == true) {
                    solvedImageList.append(doingImage)
                    if unsolvedImageList.count != 0 {
                        let randomIndex = random(max: unsolvedImageList.count)
                        doingImage = unsolvedImageList.remove(at: randomIndex)
                        image = UIImage(named: doingImage.fileName!)!
                        
                        let gameResult = UIImageView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0))
                        gameResult.backgroundColor = UIColor.yellow
                        gameResult.image = image
                        self.view.addSubview(gameResult)
                        disableOtherCells();

                        //makeGameBoard()
                        //playWinningSound()
                    } else {
                        playWinningSound()
                        stopTimer()
                        updateHighScore()
                    }
                }
            }
            previousCell?.layer.opacity = 1
            previousCell = nil
        } else {
            previousCell = cell
            cell.layer.opacity = 0.2
            
        }
        self.view.setNeedsDisplay()
    }
    
    // find cell based on x, y coordinate
    func findCell(point: CGPoint) -> CellGame {
        let xFloat = Float(point.x / (boardGame.frame.width / CGFloat(colNo)))
        var x:Int = Int(xFloat)
        if x != 0 && floorf(xFloat) == xFloat {
            x = x - 1
        }
        let yFloat = Float(point.y / (boardGame.frame.height / CGFloat(rowNo)))
        var y:Int = Int(yFloat)
        if y != 0 && floorf(yFloat) == yFloat {
            y = y - 1
        }
        return cellGameArray[x][y]
    }
    
    // find suiable point based on x, y in board game
    func findPoint(x: Int, y: Int) -> CGPoint {
        var point = CGPoint()
        point.x = boardGame.frame.width / CGFloat(colNo) * CGFloat(x - 1)
        point.y = boardGame.frame.height / CGFloat(rowNo) * CGFloat(y - 1)
        return point
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
    
    func disableOtherCells() {
        for i in 0...(colNo - 1) {
            for j in 0...(rowNo - 1) {
                cellGameArray[i][j].isUserInteractionEnabled = false
            }
        }
    }
    
    func enableAllCells() {
        for i in 0...(colNo - 1) {
            for j in 0...(rowNo - 1) {
                cellGameArray[i][j].isUserInteractionEnabled = true
            }
        }
    }
    
    var firstPoint: CGPoint!
    func panDetected(recognizer: UIPanGestureRecognizer) {
        // let translation  = recognizer.translation(in: recognizer.view)
        if recognizer.state == .began {
            disableOtherCells()
            if isFirstTap == true {
                if playMode == 0 {
                    startTimer()
                }
                isFirstTap = false
            }
            firstPoint = recognizer.view?.frame.origin
            boardGame.bringSubview(toFront: recognizer.view!)
        }
        
        if recognizer.state == .changed {
            //        let translation = recognizer.translation(in: recognizer)
            recognizer.view?.center = recognizer.location(in: self.boardGame)
            
            // check if go out game board view
            if recognizer.location(in: boardGame).x < 0 {
                recognizer.view?.center.x = 0
            }
            
            if recognizer.location(in: boardGame).x > boardGame.frame.width {
                recognizer.view?.center.x = boardGame.frame.width
            }
            
            if recognizer.location(in: boardGame).y < 0 {
                recognizer.view?.center.y = 0
            }
            
            if recognizer.location(in: boardGame).y > boardGame.frame.height {
                recognizer.view?.center.y = boardGame.frame.height
            }
        }
        
        if recognizer.state == .ended {
            playSwitchSound()
            let lastPoit = recognizer.view?.center
            recognizer.view?.frame.origin = firstPoint
            firstPoint = recognizer.view?.center
            firstCell = findCell(point: firstPoint)
            newCell = findCell(point: lastPoit!)
            let xTmp = newCell.x
            let yTmp = newCell.y
            let imageTmp = newCell.image
            newCell.x = firstCell.x
            newCell.y = firstCell.y
            newCell.image = firstCell.image
            firstCell.x = xTmp
            firstCell.y = yTmp
            firstCell.image = imageTmp
            if(checkComplete() == true) {
                solvedImageList.append(doingImage)
                // check if there is any unsolved image
                if unsolvedImageList.count != 0 {
                    let randomIndex = random(max: unsolvedImageList.count)
                    doingImage = unsolvedImageList.remove(at: randomIndex)
                    
                    image = UIImage(named: doingImage.fileName!)!
                    
                    // update score
                    // if play mode is Tính giờ
                    if playMode == 0 {
                        score = score + Int(Float(rowNo * colNo) * ((timeLimit - seconds)/timeLimit) * 10000)
                        seconds = 0
                    } else {
                        score = score + 1
                    }
                    scoreLabel.text = "\(score)"
                    UIView.animate(withDuration: 0.5, animations: {
                        self.boardGame.center = self.view.center
                    })
                    
                    continueBtn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 80, y: UIScreen.main.bounds.height/2 , width: 80, height: 40))
                    continueBtn.setTitle("Tiep tuc", for: .normal)
                    continueBtn.titleLabel?.text = "Tiep tuc"
                    continueBtn.backgroundColor = UIColor.purple
                    continueBtn.addTarget(self, action: #selector(self.continueGame), for: .touchUpInside)
                
                    stopTimer();
                    if playMode == 0 {
                        timerBar.removeFromSuperview()
                    }
                    self.view.addSubview(continueBtn)

                    
                    boardGame.isUserInteractionEnabled = false

                } else {
                    // else, finish, update score
                    if playMode == 0 {
                        score = score + Int(Float(rowNo * colNo) * ((timeLimit - seconds)/timeLimit) * 10000)
                    } else {
                        score = score + 1
                    }
                    scoreLabel.text = "\(score)"
                    playWinningSound()
                    stopTimer()
                    updateHighScore()
                }
            }
            enableAllCells()
        }
        
        if recognizer.state == .failed {
            enableAllCells()
        }
        
        if recognizer.state == .cancelled {
            enableAllCells()
        }
        self.view.setNeedsDisplay()
    }
    
    // create game board
    func makeGameBoard(){
        // end - timer progress bar
        imageView.image = image
        boardGame.frame = CGRect(x: 10, y: UIScreen.main.bounds.height/2 - 30, width: UIScreen.main.bounds.width-20 , height: (UIScreen.main.bounds.height)/2)
        boardGame.isExclusiveTouch = true
        // remeove old tiles from board
        for view in boardGame.subviews {
            view.removeFromSuperview()
        }
        // setting row and col number based on mode and number of solved photo
        // Mode Tính giờ
        if playMode == 0 {
            // timer progress bar
            timerBar.progressImage = UIImage(named: "progressBar")
            timerBar.trackTintColor = UIColor.blue
            timerBar.frame = CGRect(x: 0, y: UIScreen.main.bounds.height/2 - 40, width: UIScreen.main.bounds.width, height: 5)
            timerBar.transform = timerBar.transform.scaledBy(x: 1, y: 5)
            self.view.addSubview(timerBar)
            // if player has solved more than specified x pics, increase level
            if solvedImageList.count > (numUpLevel * upLevelTimes) {
                if colNo > rowNo {
                    rowNo = rowNo + 1
                } else {
                    colNo = colNo + 1
                }
                upLevelTimes = upLevelTimes + 1
            }
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
                let tmpImageView = CellGame()
                tmpImageView.frame = CGRect(x: CGFloat(i - 1) * (boardGame.frame.width / CGFloat(colNo)) , y: CGFloat(j - 1) * (boardGame.frame.height / CGFloat(rowNo)), width: boardGame.frame.width / CGFloat(colNo), height: boardGame.frame.height / CGFloat(rowNo))
                let tmpImage = image.splitImage(rowNo: CGFloat(rowNo), colNo: CGFloat(colNo), xOrder: CGFloat(i-1), yOrder: CGFloat(j-1))
                tmpImageView.image = tmpImage
                tmpImageView.x = i
                tmpImageView.y = j
                tmpImageView.tobeX = i
                tmpImageView.tobeY = j
                tmpImageView.isExclusiveTouch = true
//                tmpImageView.layer.borderWidth = 1
//                tmpImageView.layer.borderColor = UIColor.white.cgColor
//                tmpImageView.layer.masksToBounds = true
//                tmpImageView.layer.cornerRadius = 10.0
//                tmpImageView.layer.shadowRadius = 10
//                tmpImageView.alpha = 0.5
//                tmpImageView.layer.op
                
                cellGameArray[i-1][j-1] = tmpImageView
                boardGame.addSubview(tmpImageView)
            }
        }
        for j in 0..<cellGameArray.count {
            for i in 0..<self.cellGameArray[j].count {
//                let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected(_:)))
//                singleTap.numberOfTapsRequired = 1
//                singleTap.numberOfTouchesRequired = 1
                let tmpImage = cellGameArray[j][i]
                tmpImage.isUserInteractionEnabled = true
                let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panDetected))
                pan.maximumNumberOfTouches = 1
//                tmpImage.addGestureRecognizer(singleTap)
                tmpImage.addGestureRecognizer(pan)
            }
        }
        // random cells
        mixingCells(times: 5)
        while checkComplete() {
            mixingCells(times: 5)
        }
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
                    let imageTmp = cell1.image
                    let cell2 = cellGameArray[random(max: colNo)][random(max: rowNo)]
                    cell1.x = cell2.x
                    cell1.y = cell2.y
                    cell1.image = cell2.image
                    cell2.x = xTmp
                    cell2.y = yTmp
                    cell2.image = imageTmp
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
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    // update time : add 0.1s
    func updateTime() {
        if seconds <= timeLimit {
            seconds += 0.1
            timerBar.progress = seconds.divided(by: timeLimit)
        } else {
            // finish game TODO het gio
            timer.invalidate()
            updateHighScore()
        }
    }
    
    // stop timer
    func stopTimer() {
        timer.invalidate()
    }
    
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
    
    func updateHighScore() {
//        for point in catalogue.toPointInfo! {
//            let p = point as! PointInfo
//            if p.modeType == Int64(playMode) {
//                print(p.totalPoint)
//            }
//        }
        var pointInfoList: [PointInfo]!
        var isNewRecord = false
        do {
            let fetchRequest: NSFetchRequest<PointInfo> = PointInfo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "toCatalogue == %@ && modeType == %d", catalogue, playMode)
            let sort = NSSortDescriptor(key: "topPlace", ascending: true)
            fetchRequest.sortDescriptors = [sort]
            pointInfoList = try context.fetch(fetchRequest)
            for i in 0..<pointInfoList.count {
                if Int64(score) > pointInfoList[i].totalPoint {
                    let oldPoint = pointInfoList[i].totalPoint
                    pointInfoList[i].totalPoint = Int64(score)
                    score = Int(oldPoint)
                    if i == 0 {
                        isNewRecord = true
                    }
                }
            }
            try context.save()
        } catch {
            fatalError("Failed")
        }
        // TODO thong bao neu co ky luc moi
        if isNewRecord {
            print("New record: \(pointInfoList[0].totalPoint)")
        }
        
        // for debug FIXME
        for i in 0..<pointInfoList.count {
            print(pointInfoList[i].totalPoint)
        }
        
        // Menu game over
        gameOverMenu = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let gameOver = UIView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0))
        gameOver.backgroundColor = UIColor.red
        
        let replayBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        replayBtn.titleLabel?.text = "Chơi lại"
        replayBtn.setTitle("Chơi lại", for: .normal)
        replayBtn.backgroundColor = UIColor.blue
        replayBtn.addTarget(self, action: #selector(self.replay), for: .touchUpInside)
        
        
        let stopBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        stopBtn.setTitle("Thoát", for: .normal)
        stopBtn.titleLabel?.text = "Thoát"
        stopBtn.backgroundColor = UIColor.purple
        stopBtn.addTarget(self, action: #selector(self.stop), for: .touchUpInside)
        
        gameOver.addSubview(replayBtn)
        gameOver.addSubview(stopBtn)
        gameOverMenu.addSubview(gameOver)
        self.view.addSubview(gameOverMenu)
        print(gameOver.center)
        print(replayBtn.center)
        
        //show game result
        //let gameResult = UIView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0))
        //gameResult.backgroundColor = UIColor.yellow
        
        
        
        //Call whenever you want to show it and change the size to whatever size you want
        UIView.animate(withDuration: 0.5, animations: {
            gameOver.frame.size = CGSize(width: 300, height: 300)
            gameOver.center = self.view.center
            replayBtn.center = CGPoint(x: gameOver.frame.width/2 , y: gameOver.frame.height/2 - 30)
            stopBtn.center = CGPoint(x: gameOver.frame.width/2 , y: gameOver.frame.height/2 + 30)
        })
    }
    
    func replay() {
        seconds = 0
        timerBar.progress = 0
        isFirstTap = true
        solvedImageList.removeAll()
        upLevelTimes = 1
        score = 0
        gameOverMenu.removeFromSuperview()
        boardGame.removeFromSuperview()
        imageView.removeFromSuperview()
        scoreLabel.removeFromSuperview()
        createGame()
    }
    
    func stop() {
            self.dismiss(animated: true, completion: nil)
    }
    
    func continueGame(){
        continueBtn.removeFromSuperview()
        if(playMode == 0){
            startTimer()
        }
        boardGame.isUserInteractionEnabled = true
        makeGameBoard()
        playWinningSound()
    }
}

class CellGame: UIImageView {
    var x: Int?
    
    var y: Int?
    
    var tobeX: Int?
    
    var tobeY: Int?
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


