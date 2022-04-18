//
//  MatchViewController.swift
//  BadmintonScoreBoard
//
//  Created by Hsiao-Han Chi on 2022/4/10.
//

import UIKit

class MatchViewController: UIViewController {

//宣告儲存第一頁輸入的選手名稱的變數
    var player1Name: String!
    var player2Name: String!
    
    var getScoreSequence: [String] = []

    @IBOutlet weak var player1NameCard: UILabel!
    @IBOutlet weak var player2NameCard: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var firstServeLable: UILabel!
    @IBOutlet weak var firstServeSegment: UISegmentedControl!

    @IBOutlet weak var serveDirectionImageView: UIImageView!
    
    @IBOutlet weak var leftUpVIew: UIView!
    @IBOutlet weak var leftUpLable: UILabel!
    @IBOutlet weak var leftLowerView: UIView!
    @IBOutlet weak var leftLowerLable: UILabel!
    @IBOutlet weak var rightUpView: UIView!
    @IBOutlet weak var rightUpLable: UILabel!
    @IBOutlet weak var rightLowerView: UIView!
    @IBOutlet weak var rightLowerLable: UILabel!
  
    @IBOutlet weak var leftPlayerServe: UIView!
    @IBOutlet weak var rightPlayerServe: UIView!
    @IBOutlet weak var player1Serve: UIView!
    @IBOutlet weak var player2Serve: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
//宣告計時的物件及儲存秒數的變數，初始值為0
    var timer: Timer?
    var counter = 0

//宣告儲存初始狀態選手名稱首字的變數
    var leftPlayerWord: String = ""
    var rightPlayerWord: String = ""

    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    @IBOutlet weak var player1WinMatchLable: UILabel!
    @IBOutlet weak var player2WinMatchLable: UILabel!
//宣告選手贏的局數的變數，初始值為0
    var player1WinCount = 0
    var player2WinCount = 0
    
    
    @IBOutlet weak var leftPlayerScore: UILabel!
    @IBOutlet weak var rightPlayerScore: UILabel!

    @IBOutlet weak var leftPlayerAddScoreButton: UIButton!
    @IBOutlet weak var rightPlayerAddScoreButton: UIButton!
    @IBOutlet weak var leftPlayerGamePointButton: UIButton!
    @IBOutlet weak var rightPlayerGamePointButton: UIButton!
    
//宣告用來計分的變數
    var player1ScoreCount = 0
    var player2ScoreCount = 0
    var leftPlayerScoreCount = 0
    var rightPlayerScoreCount = 0
    
    @IBOutlet weak var resetButton: UIButton!
    
    
    
//建立初始狀態的Function，放在viewDidLoad中執行
    func initialUI(){
        
//player1、player2儲存接收到的名稱
//系統覺得player1Name跟player2Name可能會出現空值，因此需給初始值才能執行
        let player1 = player1Name ?? "Player1"
        let player2 = player2Name ?? "Player2"
//將字串轉成陣列個別儲存字元
        let player1Array = Array(player1)
        let player2Array = Array(player2)
//抓出名字首字
        let player1FirstWord = String(player1Array[0])
        let player2FirstWord = String(player2Array[0])
        player1NameCard.text = player1
        player2NameCard.text = player2
//顯示start按鈕及可使用功能，隱藏stop按鈕及功能
        stopButton.isHidden = true
        stopButton.isEnabled = false
        startButton.isHidden = false
        startButton.isEnabled  = true
//設定Segmented control顯示的選項名稱
        firstServeSegment.setTitle(player1, forSegmentAt: 0)
        firstServeSegment.setTitle(player2, forSegmentAt: 1)
//顯示選擇第一發球者的標籤及選項，預設發球者是player1
        firstServeLable.isHidden = false
        firstServeSegment.isHidden = false
        firstServeSegment.selectedSegmentIndex = 0
//設定場上圓形標誌顯示的字
        leftUpLable.text = player1FirstWord
        leftLowerLable.text = player1FirstWord
        rightUpLable.text = player2FirstWord
        rightLowerLable.text = player2FirstWord
//儲存初始狀態圓形標誌顯示的字
        leftPlayerWord = leftLowerLable.text!
        rightPlayerWord = rightUpLable.text!
//設定雙方贏的局數顯示為初始值０
        player1WinCount = 0
        player1WinMatchLable.text = "\(player1WinCount)"
        player2WinCount = 0
        player2WinMatchLable.text = "\(player2WinCount)"
//設定雙方分數顯示的初始值為０
        player1ScoreCount = 0
        player1Score.text = "\(player1ScoreCount)"
        player2ScoreCount = 0
        player2Score.text = "\(player2ScoreCount)"
        leftPlayerScoreCount = 0
        leftPlayerScore.text = "\(leftPlayerScoreCount)"
        rightPlayerScoreCount = 0
        rightPlayerScore.text = "\(rightPlayerScoreCount)"
//初始狀態發球者顯示為player1，位置在左方
        player1Serve.isHidden = false
        player2Serve.isHidden = true
        leftPlayerServe.isHidden = false
        rightPlayerServe.isHidden = true
//初始狀態為左方選手發球，發球者跟接發球者會站在自己場上的右邊，所以就app的視角是左下跟右上顯示
        leftUpVIew.isHidden = true
        leftLowerView.isHidden = false
        rightUpView.isHidden = false
        rightLowerView.isHidden = true
//初始狀態為左方選手發球，雙數位發球方向是左下到右上
        serveDirectionImageView.image = UIImage(named: "leftEven")
//初始狀態不顯示加分按鈕及最後Game Point的按鈕
        leftPlayerAddScoreButton.isHidden = true
        rightPlayerAddScoreButton.isHidden = true
        leftPlayerGamePointButton.isHidden = true
        leftPlayerGamePointButton.isEnabled = false
        rightPlayerGamePointButton.isHidden = true
        rightPlayerGamePointButton.isEnabled = false

    }

//將秒數轉換為時分秒
    @objc func updateTime(timer: Timer) {
         counter += 1
        
        let (minute, sec) = counter.quotientAndRemainder(dividingBy: 60)
        let (hour, min) = minute.quotientAndRemainder(dividingBy: 60)
        if min < 10 && sec < 10{
            timeLabel.text = "0\(hour):0\(min):0\(sec)"
        }else if min > 10 && sec < 10{
            timeLabel.text = "0\(hour):\(min):0\(sec)"
        }else if min < 10 && sec > 10{
            timeLabel.text = "0\(hour):0\(min):\(sec)"
        }else if min > 10 && sec > 10{
            timeLabel.text = "0\(hour):\(min):\(sec)"
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUI()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func chooseFirstServer(_ sender: Any) {

//如果選擇player1先發球，黃色點點在player1名字後方顯示
        if firstServeSegment.selectedSegmentIndex == 0{
            player1Serve.isHidden = false
            player2Serve.isHidden = true

//如果左方選手名字首字跟左邊場地上圓形標誌相同，代表左方選手是player1，黃色點點顯示在左方，發球方向是左下到右上;如果不同，顯示在右方，發球方向是右上到左下
            if leftPlayerWord == leftLowerLable.text{
                leftPlayerServe.isHidden = false
                rightPlayerServe.isHidden = true
                serveDirectionImageView.image = UIImage(named: "leftEven")
            }else if leftPlayerWord != leftLowerLable.text{
                leftPlayerServe.isHidden = true
                rightPlayerServe.isHidden = false
                serveDirectionImageView.image = UIImage(named: "rightEven")
            }
//如果選擇player2先發球，黃色點點在player2名字後方顯示
        }else if firstServeSegment.selectedSegmentIndex == 1{
            player2Serve.isHidden = false
            player1Serve.isHidden = true

//如果左方選手名字首字跟左邊場地上圓形標誌相同，代表左方選手是player1，但現在是player2發球，所以黃色點點應顯示在右方，發球方向是右上到左下;如果不同，代表左方選手是player2，黃色點點顯示在左方，發球方向是左下到右上
            if leftPlayerWord == leftLowerLable.text{
                leftPlayerServe.isHidden = true
                rightPlayerServe.isHidden = false
                serveDirectionImageView.image = UIImage(named: "rightEven")
            }else if leftPlayerWord != leftLowerLable.text{
                leftPlayerServe.isHidden = false
                rightPlayerServe.isHidden = true
                serveDirectionImageView.image = UIImage(named: "leftEven")
            }
        }
        
    }
    
    @IBAction func startMatch(_ sender: Any) {
//點擊start按鈕後，start按鈕隱藏且不可使用；stop按鈕顯示並可以點選使用
        startButton.isHidden = true
        startButton.isEnabled = false
        stopButton.isHidden = false
        stopButton.isEnabled = true

//開始計時
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
//顯示加分按鈕
        leftPlayerAddScoreButton.isHidden = false
        rightPlayerAddScoreButton.isHidden = false
        
        
//隱藏第一發球者的Label跟Segment
        firstServeLable.isHidden = true
        firstServeSegment.isHidden = true

    }
    
    @IBAction func stopMatch(_ sender: Any) {
        timer?.invalidate()
//點擊start按鈕後，start按鈕隱藏且不可使用；stop按鈕顯示並可以點選使用
        stopButton.isHidden = true
        stopButton.isEnabled = false
        startButton.isHidden = false
        startButton.isEnabled  = true

    }
    
    
    @IBAction func changeSide(_ sender: Any) {
        
//交換場地圖片上的圓形標誌
        let changeLeftUpView = leftUpVIew
        let changeLeftLowerView = leftLowerView
        let changeRightUpView = rightUpView
        let changeRightLowerView = rightLowerView
        let changeLeftUpLable = leftUpLable.text
        let changeLeftLowerLable = leftLowerLable.text
        let changeRightUpLable = rightUpLable.text
        let changeRightLowerLable = rightLowerLable.text

        leftUpVIew = changeRightLowerView
        leftLowerView = changeRightUpView
        rightUpView = changeLeftLowerView
        rightLowerView = changeLeftUpView
        leftUpLable.text = changeRightUpLable
        leftLowerLable.text = changeRightLowerLable
        rightUpLable.text = changeLeftUpLable
        rightLowerLable.text = changeLeftLowerLable

//交換場地中間的發球方向圖片
        if serveDirectionImageView.image == UIImage(named: "leftEven"){
            serveDirectionImageView.image = UIImage(named: "rightEven")
        }else if serveDirectionImageView.image == UIImage(named: "leftOdd"){
            serveDirectionImageView.image = UIImage(named: "rightOdd")
        }else if serveDirectionImageView.image == UIImage(named: "rightEven"){
            serveDirectionImageView.image = UIImage(named: "leftEven")
        }else if serveDirectionImageView.image == UIImage(named: "rightOdd"){
            serveDirectionImageView.image = UIImage(named: "leftOdd")
        }
//交換中間的分數顯示
        let changeLeftPlayerScoreCount = leftPlayerScoreCount
        let changeRightPlayerScoreCount = rightPlayerScoreCount
        
        leftPlayerScoreCount = changeRightPlayerScoreCount
        rightPlayerScoreCount = changeLeftPlayerScoreCount
        
        leftPlayerScore.text = "\(changeRightPlayerScoreCount)"
        rightPlayerScore.text = "\(changeLeftPlayerScoreCount)"
        
//交換中間的發球圓點顯示
        if leftPlayerServe.isHidden == true{
            leftPlayerServe.isHidden = false
            rightPlayerServe.isHidden = true
        }else{
            leftPlayerServe.isHidden = true
            rightPlayerServe.isHidden = false
        }
        if player1Serve.isHidden == false{
            player1Serve.isHidden = false
            player2Serve.isHidden = true
        }else{
            player1Serve.isHidden = true
            player2Serve.isHidden = false
        }
    }
    
    func nextGame(){
//分數歸0
        player1ScoreCount = 0
        player1Score.text = "\(player1ScoreCount)"
        player2ScoreCount = 0
        player2Score.text = "\(player2ScoreCount)"
        leftPlayerScoreCount = 0
        leftPlayerScore.text = "\(leftPlayerScoreCount)"
        rightPlayerScoreCount = 0
        rightPlayerScore.text = "\(rightPlayerScoreCount)"
//如果最後一分得分的是左方選手，因新的一局是從偶數位發球，因此先調整場地中間的發球方向改為偶數位，由左下到右上，圓形標誌顯示左下跟右上的，最後用changeside整個換邊，改為右方選手（上一局的勝者）發球
        if serveDirectionImageView.image == UIImage(named: "leftOdd") || serveDirectionImageView.image == UIImage(named: "leftEven"){
            serveDirectionImageView.image = UIImage(named: "leftEven")
            leftLowerView.isHidden = false
            leftUpVIew.isHidden = true
            rightLowerView.isHidden = true
            rightUpView.isHidden = false
            changeSide((Any).self)
//如果最後一分得分的是右方選手，因新的一局是從偶數位發球，因此先調整場地中間的發球方向改為偶數位，由右上到左下，圓形標誌顯示右上跟左下的，最後用changeside整個換邊，改為左方選手（上一局的勝者）發球
        }else if serveDirectionImageView.image == UIImage(named: "rightOdd") || serveDirectionImageView.image == UIImage(named: "rightEven"){
            serveDirectionImageView.image = UIImage(named: "rightEven")
            leftLowerView.isHidden = false
            leftUpVIew.isHidden = true
            rightLowerView.isHidden = true
            rightUpView.isHidden = false
            changeSide((Any).self)
        }
        getScoreSequence.removeAll()
    }
    
    func openLeftGamePointBurron(){
        leftPlayerAddScoreButton.isHidden = true
        leftPlayerAddScoreButton.isEnabled = false
        leftPlayerGamePointButton.isHidden = false
        leftPlayerGamePointButton.isEnabled = true
    }
    
    func openRightGamePointButton(){
        rightPlayerAddScoreButton.isHidden = true
        rightPlayerAddScoreButton.isEnabled = false
        rightPlayerGamePointButton.isHidden = false
        rightPlayerGamePointButton.isEnabled = true
    }
    
    func closeLeftGamePointButton(){
        leftPlayerAddScoreButton.isHidden = false
        leftPlayerAddScoreButton.isEnabled = true
        leftPlayerGamePointButton.isHidden = true
        leftPlayerGamePointButton.isEnabled = false
    }
    
    func closeRightGamePointButton(){
        rightPlayerAddScoreButton.isHidden = false
        rightPlayerAddScoreButton.isEnabled = true
        rightPlayerGamePointButton.isHidden = true
        rightPlayerGamePointButton.isEnabled = false
    }

    func leftPlayerDistinguish(){
//如果左方選手首字跟左邊場地上圓形標誌相同，代表左方選手是player1，讓player1後方的分數顯示左方選手的分數，得分時顯示黃色點點得到發球權
        if leftPlayerWord == leftLowerLable.text{
            player1Score.text = "\(leftPlayerScoreCount)"
            player1Serve.isHidden = false
            player2Serve.isHidden = true
            getScoreSequence.append("Player1")
//如果左方選手首字跟左邊場地上圓形標誌不同，代表左方選手是player2，讓player2後方的分數顯示左方選手的分數，得分顯時顯示黃色點點得到發球權
        }else if leftPlayerWord != leftLowerLable.text{
            player2Score.text = "\(leftPlayerScoreCount)"
            player1Serve.isHidden = true
            player2Serve.isHidden = false
            getScoreSequence.append("Player2")
            }
        //print(getScoreSequence)
        
    }
    
    func rightPlayerDistinguish(){
//如果右方選手首字跟右邊場地上圓形標誌相同，代表右方選手是player2，讓player2後方的分數顯示右方選手的分數，得分時顯示黃色點點得到發球權
        if rightPlayerWord == rightLowerLable.text{
            player2Score.text = "\(rightPlayerScoreCount)"
            player2Serve.isHidden = false
            player1Serve.isHidden = true
            getScoreSequence.append("Player2")
//如果右方選手首字跟右邊場地上圓形標誌不同，代表右方選手是player1，讓player1後方的分數顯示右方選手的分數，得分時顯示黃色點點得到發球權
        }else if rightPlayerWord != rightLowerLable.text{
            player1Score.text = "\(rightPlayerScoreCount)"
            player1Serve.isHidden = false
            player2Serve.isHidden = true
            getScoreSequence.append("Player1")
            }
        //print(getScoreSequence)
    }
    
    func leftPlayerWinDistinguish(){
//如果左方選手首字跟左邊場地上圓形標誌相同，代表左方選手是player1，讓player1贏的局數+1
        if leftPlayerWord == leftLowerLable.text{
            if player1WinCount == 0{
                player1WinCount += 1
                player1Serve.isHidden = false
                player2Serve.isHidden = true
                nextGame()
            }else if player1WinCount == 1{
                player1WinCount += 1
            }
            player1WinMatchLable.text = "\(player1WinCount)"
//如果左方選手首字跟左邊場地上圓形標誌不同，代表左方選手是player2，讓player2贏的局數+1
        }else if leftPlayerWord != leftLowerLable.text{
            if player2WinCount == 0{
                player2WinCount += 1
                player1Serve.isHidden = true
                player2Serve.isHidden = false
                nextGame()
            }else if player2WinCount == 1{
                player2WinCount += 1
            }
            player2WinMatchLable.text = "\(player2WinCount)"
        }
    }
    
    func rightPlayerWinDistinguish(){
//如果右方選手首字跟右邊場地上圓形標誌相同，代表右方選手是player2，讓player2贏的局數+1
        if rightPlayerWord == rightLowerLable.text{
            if player2WinCount == 0{
                player2WinCount += 1
                player1Serve.isHidden = true
                player2Serve.isHidden = false
                nextGame()
            }else if player2WinCount == 1{
                player2WinCount += 1
            }
            player2WinMatchLable.text = "\(player2WinCount)"
//如果右方選手首字跟右邊場地上圓形標誌不同，代表右方選手是player1，讓player1贏的局數+1
        }else if rightPlayerWord != rightLowerLable.text{
            if player1WinCount == 0{
                player1WinCount += 1
                player1Serve.isHidden = false
                player2Serve.isHidden = true
                nextGame()
            }else if player1WinCount == 1{
                player1WinCount += 1
            }
            player1WinMatchLable.text = "\(player1WinCount)"
        }
    }
    
    
    @IBAction func leftPlayerAddScore(_ sender: Any) {
//左方選手得分時，中間的黃色發球圓點顯示在左方
        leftPlayerServe.isHidden = false
        rightPlayerServe.isHidden = true
//左方選手得分時，更換場地中間的發球方向圖片
//得分前的分數為偶數，下一球站奇數位發球，發球方向是左上到右下，圓形標誌跟著在左上顯示
        if leftPlayerScoreCount % 2  == 0{
            serveDirectionImageView.image = UIImage(named: "leftOdd")
            leftLowerView.isHidden = true
            leftUpVIew.isHidden = false
            rightLowerView.isHidden = false
            rightUpView.isHidden = true
//得分前的分數為奇數，下一球站偶數位發球，發球方向是左下到右上，圓形標誌跟著在左下顯示
        }else if leftPlayerScoreCount % 2 == 1{
            serveDirectionImageView.image = UIImage(named: "leftEven")
            leftLowerView.isHidden = false
            leftUpVIew.isHidden = true
            rightLowerView.isHidden = true
            rightUpView.isHidden = false
        }

//判斷左方選手分數落在哪個區間執行相對應的動作
//分數小於19的話，按按鈕count+1
        if leftPlayerScoreCount < 19{
            leftPlayerScoreCount += 1
            leftPlayerDistinguish()
        }else if leftPlayerScoreCount == 19{
            leftPlayerScoreCount += 1
            leftPlayerDistinguish()
//分數等於19分，加分後為20分，判斷是否進入賽末點
            if leftPlayerWord == leftLowerLable.text{
                if player1WinCount == 1{
                    openLeftGamePointBurron()
                }
            }else if leftPlayerWord != leftLowerLable.text{
                if player2WinCount == 1{
                    openLeftGamePointBurron()
                }
//如果右方選手已經達20分，加分後進入Deuce狀態
            }
            if rightPlayerScoreCount == 20{
                closeLeftGamePointButton()
                closeRightGamePointButton()
            }
//分數等於20時，先判斷左邊選手的分數-右邊選手的分數是否大於0，是的話表示左方選手贏得這一局;如果<0，加分後進入Deuce狀態，如果右方選手也是20分，加分後繼續Deuce
        }else if leftPlayerScoreCount == 20{
            if leftPlayerScoreCount - rightPlayerScoreCount >= 1{
                leftPlayerScoreCount += 1
                leftPlayerDistinguish()
                leftPlayerWinDistinguish()
            }else if leftPlayerScoreCount - rightPlayerScoreCount < 0{
                leftPlayerScoreCount += 1
                leftPlayerDistinguish()
                closeLeftGamePointButton()
                closeRightGamePointButton()
            }else if rightPlayerScoreCount == 20{
                leftPlayerScoreCount += 1
                leftPlayerDistinguish()
//判斷是否進入賽末點
                if leftPlayerWord == leftLowerLable.text{
                    if player1WinCount == 1{
                        openLeftGamePointBurron()
                    }
                }else if leftPlayerWord != leftLowerLable.text{
                    if player2WinCount == 1{
                        openLeftGamePointBurron()
                    }
                }
            }
//分數介在21~27時，如果左邊選手的分數-右邊選手的分數=0，代表加分後還是Deuce狀態，按按鈕count+1
        }else if leftPlayerScoreCount < 28{
            if leftPlayerScoreCount - rightPlayerScoreCount == 0{
                leftPlayerScoreCount += 1
                leftPlayerDistinguish()
//判斷是否進入賽末點
                if leftPlayerWord == leftLowerLable.text{
                    if player1WinCount == 1{
                        openLeftGamePointBurron()
                    }
                }else if leftPlayerWord != leftLowerLable.text{
                    if player2WinCount == 1{
                        openLeftGamePointBurron()
                    }
                }
                
//分數介在21~27時，如果左邊選手的分數-右邊選手的分數<0，加分後繼續Deuce
            }else if leftPlayerScoreCount - rightPlayerScoreCount < 0{
                leftPlayerScoreCount += 1
                leftPlayerDistinguish()
                closeLeftGamePointButton()
                closeRightGamePointButton()
//分數介在21~27時，如果左邊選手的分數-右邊選手的分數=1，加分後贏得這回合比賽
            }else if leftPlayerScoreCount - rightPlayerScoreCount == 1{
                leftPlayerScoreCount += 1
                leftPlayerDistinguish()
                leftPlayerWinDistinguish()
            }
//如果分數到達28分，判斷是否進入賽末點
        }else if leftPlayerScoreCount == 28{
            leftPlayerScoreCount += 1
            leftPlayerDistinguish()
            if leftPlayerWord == leftLowerLable.text{
                if player1WinCount == 1{
                    openLeftGamePointBurron()
                }
            }else if leftPlayerWord != leftLowerLable.text{
                if player2WinCount == 1{
                    openLeftGamePointBurron()
                }
            }
//如果分數到達29分，加分後比賽結束
        }else if leftPlayerScoreCount == 29{
            leftPlayerScoreCount += 1
            leftPlayerDistinguish()
            leftPlayerWinDistinguish()
        }
//分數顯示
        leftPlayerScore.text = "\(leftPlayerScoreCount)"
        rightPlayerScore.text = "\(rightPlayerScoreCount)"
    }
    

    @IBAction func rightPlayerAddScore(_ sender: Any) {
//右方選手得分時，中間的黃色發球圓點顯示在右方
        leftPlayerServe.isHidden = true
        rightPlayerServe.isHidden = false
        
//右方選手得分時，更換場地中間的發球方向圖片
//得分前的分數為偶數，下一球站奇數位發球，發球方向是右下到左上，圓形標誌跟著在右下顯示
        if rightPlayerScoreCount % 2  == 0{
            serveDirectionImageView.image = UIImage(named: "rightOdd")
            rightLowerView.isHidden = false
            rightUpView.isHidden = true
            leftLowerView.isHidden = true
            leftUpVIew.isHidden = false
//得分前的分數為奇數，下一球站偶數位發球，發球方向是右上到左下，圓形標誌跟著在右上顯示
        }else if rightPlayerScoreCount % 2 == 1{
            serveDirectionImageView.image = UIImage(named: "rightEven")
            rightLowerView.isHidden = true
            rightUpView.isHidden = false
            leftLowerView.isHidden = false
            leftUpVIew.isHidden = true
        }
//判斷右方選手分數落在哪個區間執行相對應的動作
//分數小於19的話，按按鈕count+1
        if rightPlayerScoreCount < 19{
            rightPlayerScoreCount += 1
            rightPlayerDistinguish()
//分數等於19時，加分後為20分，判斷是否進入賽末點
        }else if rightPlayerScoreCount == 19{
            rightPlayerScoreCount += 1
            rightPlayerDistinguish()
            if rightPlayerWord == rightLowerLable.text{
                if player2WinCount == 1{
                    openRightGamePointButton()
                }
            }else if rightPlayerWord != rightLowerLable.text{
                if player1WinCount == 1{
                    openRightGamePointButton()
                }
//如果左方選手已達20分，加分後進入Deuce狀態
            }
            if leftPlayerScoreCount == 20{
                closeRightGamePointButton()
                closeLeftGamePointButton()
            }
//分數等於20時，先判斷右邊選手的分數-左邊選手的分數是否大於0，是的話表示右方選手贏得這一局;如果<0，加分後繼續進入Deuce狀態;如果左方選手也是20分，繼續Deuce狀態，判斷是否進入賽末點
        }else if rightPlayerScoreCount == 20{
            if rightPlayerScoreCount - leftPlayerScoreCount >= 1{
                rightPlayerScoreCount += 1
                rightPlayerDistinguish()
                rightPlayerWinDistinguish()
            }else if rightPlayerScoreCount - leftPlayerScoreCount < 0{
                rightPlayerScoreCount += 1
                rightPlayerDistinguish()
                 closeLeftGamePointButton()
                closeRightGamePointButton()
            }else if leftPlayerScoreCount == 20{
                rightPlayerScoreCount += 1
                rightPlayerDistinguish()
//判斷是否進入賽末點
                if rightPlayerWord == rightLowerLable.text{
                    if player2WinCount == 1{
                        openRightGamePointButton()
                    }
                }else if rightPlayerWord != rightLowerLable.text{
                    if player1WinCount == 1{
                        openRightGamePointButton()
                    }
                }
            }
//分數介在21~27時，如果右邊選手的分數-左邊選手的分數==0，代表加分後還是Deuce狀態
        }else if rightPlayerScoreCount < 28{
            if rightPlayerScoreCount - leftPlayerScoreCount == 0{
                rightPlayerScoreCount += 1
                rightPlayerDistinguish()
//判斷是否進入賽末點
                if rightPlayerWord == rightLowerLable.text{
                    if player2WinCount == 1{
                        openRightGamePointButton()
                    }
                }else if rightPlayerWord != rightLowerLable.text{
                    if player1WinCount == 1{
                        openRightGamePointButton()
                    }
                }
//分數介在21~27時，如果右邊選手的分數-左邊選手的分數<0，加分後繼續進入Deuce狀態
            }else if rightPlayerScoreCount - leftPlayerScoreCount < 0{
                rightPlayerScoreCount += 1
                rightPlayerDistinguish()
                closeLeftGamePointButton()
                closeRightGamePointButton()
//分數介在21~27時，如果右邊選手的分數-左邊選手的分數=1，加分後贏得這局比賽
            }else if rightPlayerScoreCount - leftPlayerScoreCount == 1{
                rightPlayerScoreCount += 1
                rightPlayerDistinguish()
                rightPlayerWinDistinguish()
            }
//如果分數是28分，加分後為29分，判斷是否進入賽末點
        }else if rightPlayerScoreCount == 28{
            rightPlayerScoreCount += 1
            rightPlayerDistinguish()
            if rightPlayerWord == rightLowerLable.text{
                if player2WinCount == 1{
                    openRightGamePointButton()
                }
            }else if rightPlayerWord != rightLowerLable.text{
                if player1WinCount == 1{
                    openRightGamePointButton()
                }
            }
//如果分數是29分，加分後贏得這局比賽
        }else if rightPlayerScoreCount == 29{
            rightPlayerScoreCount += 1
            rightPlayerDistinguish()
            rightPlayerWinDistinguish()
        }
            
//分數顯示
        rightPlayerScore.text = "\(rightPlayerScoreCount)"
        leftPlayerScore.text = "\(leftPlayerScoreCount)"
            
    }

//左方選手賽末點的執行
    @IBAction func leftPlayerAddLastPoint(_ sender: Any) {
        leftPlayerScoreCount += 1
        leftPlayerScore.text = "\(leftPlayerScoreCount)"
        leftPlayerDistinguish()
        leftPlayerWinDistinguish()
        
    }
//右方選手賽末點的執行
    @IBAction func rightPlayerAddLastPoint(_ sender: Any) {
        rightPlayerScoreCount += 1
        rightPlayerScore.text = "\(rightPlayerScoreCount)"
        rightPlayerDistinguish()
        rightPlayerWinDistinguish()
    }
    
    
    @IBAction func rewind(_ sender: Any) {
//暫停時間，隱藏stop按鈕及功能，顯示start按鈕及功能
        timer?.invalidate()
        startButton.isHidden = false
        startButton.isEnabled = true
        stopButton.isHidden = true
        stopButton.isEnabled = false
//宣告whoGetsLastScore變數，儲存從getScoreSequence取出的最後一個值，用來判斷按下rewind按鈕前最後一分由誰獲得，該扣誰的分數
        let whoGetsLastScore = getScoreSequence.popLast()
//宣告whoGetsPreviousScore變數，儲存前面取出值後的陣列中再取出的最後一個值，用來判斷按下rewind按鈕前的最後一次發球是誰發，場地上的發球方向及圓形標誌顯示的位置應該如何顯示
        let whoGetsPreviousScore = getScoreSequence.popLast()
//如果whoGetsLastScore的值是Player1，代表誤判的分數是由Player1獲得，先判斷Player1在場上是左方還是右方選手，再扣除對應的分數
        if whoGetsLastScore == "Player1"{
            if leftPlayerWord == leftLowerLable.text{ //左方選手為Player1
                leftPlayerScoreCount -= 1
                player1Score.text = "\(leftPlayerScoreCount)"
                leftPlayerScore.text = "\(leftPlayerScoreCount)"
            }else if leftPlayerWord != leftLowerLable.text{ //右方選手為player1
                rightPlayerScoreCount -= 1
                player1Score.text = "\(rightPlayerScoreCount)"
                rightPlayerScore.text = "\(rightPlayerScoreCount)"
            }
//如果whoGetsLastScore的值是Player2，代表誤判的分數是由Player2獲得，先判斷Player2在場上是左方還是右方選手，再扣除對應的分數
        }else if whoGetsLastScore == "Player2"{
            if leftPlayerWord == leftLowerLable.text{ //右方選手為Player2
                rightPlayerScoreCount -= 1
                player2Score.text = "\(rightPlayerScoreCount)"
                rightPlayerScore.text = "\(rightPlayerScoreCount)"
            }else if leftPlayerWord != leftLowerLable.text{ //左方選手為Player2
                leftPlayerScoreCount -= 1
                player2Score.text = "\(leftPlayerScoreCount)"
                leftPlayerScore.text = "\(leftPlayerScoreCount)"
            }
        }
//如果whoGetsPreviousScore的值是Player1，代表誤判分數的那個回合是由Player1發球，黃色圓點應顯示在Player1名稱後方
        if whoGetsPreviousScore == "Player1"{
            player1Serve.isHidden = false
            player2Serve.isHidden = true
//判斷Player1在場上是左方還是右方選手，決定黃色圓點應顯示在左邊還是右邊;接著進一步判斷發球當時分數是奇數還是偶數，決定發球的方向及圓形標誌顯示的位置
            if leftPlayerWord == leftLowerLable.text{
//左方選手為Player1，黃色圓點應顯示在左邊
                leftPlayerServe.isHidden = false
                rightPlayerServe.isHidden = true
                if leftPlayerScoreCount % 2 == 0{
//若發球時的分數為偶數，方向是左下到右上
                    leftLowerView.isHidden = false
                    leftUpVIew.isHidden = true
                    rightLowerView.isHidden = true
                    rightUpView.isHidden = false
                    serveDirectionImageView.image = UIImage(named: "leftEven")
                }else if leftPlayerScoreCount % 2 == 1{
//若發球時的分數為奇數，方向是左上到右下
                    leftLowerView.isHidden = true
                    leftUpVIew.isHidden = false
                    rightLowerView.isHidden = false
                    rightUpView.isHidden = true
                    serveDirectionImageView.image = UIImage(named: "leftOdd")
                }
            }else if leftPlayerWord != leftLowerLable.text{
//右方選手為Player1，黃色圓點應顯示在右邊
                leftPlayerServe.isHidden = true
                rightPlayerServe.isHidden = false
                if rightPlayerScoreCount % 2 == 0{
//若發球時的分數為偶數，方向是右上到左下
                    leftLowerView.isHidden = false
                    leftUpVIew.isHidden = true
                    rightLowerView.isHidden = true
                    rightUpView.isHidden = false
                    serveDirectionImageView.image = UIImage(named: "rightEven")
                }else if rightPlayerScoreCount % 2 == 1{
//若發球時的分數為奇數，方向是右下到左上
                    leftLowerView.isHidden = true
                    leftUpVIew.isHidden = false
                    rightLowerView.isHidden = false
                    rightUpView.isHidden = true
                    serveDirectionImageView.image = UIImage(named: "rightOdd")
                }
            }
//判斷完後把多取出來的值補回陣列中，才不會影響後續的判斷結果
            getScoreSequence.append("Player1")
//如果whoGetsPreviousScore的值是Player2，代表誤判分數的那個回合是由Player2發球，黃色圓點應顯示在Player2名稱後方
        }else if whoGetsPreviousScore == "Player2"{
            player1Serve.isHidden = true
            player2Serve.isHidden = false
            if leftPlayerWord == leftLowerLable.text{
//右方選手為Player2，黃色圓點應顯示在右邊
                leftPlayerServe.isHidden = true
                rightPlayerServe.isHidden = false
                if rightPlayerScoreCount % 2 == 0{
//發球時的分數為偶數，方向是右上到左下
                    leftLowerView.isHidden = false
                    leftUpVIew.isHidden = true
                    rightLowerView.isHidden = true
                    rightUpView.isHidden = false
                    serveDirectionImageView.image = UIImage(named: "rightEven")
                }else if rightPlayerScoreCount % 2 == 1{
//發球時的分數為奇數，方向是右下到左上
                    leftLowerView.isHidden = true
                    leftUpVIew.isHidden = false
                    rightLowerView.isHidden = false
                    rightUpView.isHidden = true
                    serveDirectionImageView.image = UIImage(named: "rightOdd")
                }
            }else if leftPlayerWord != leftLowerLable.text{
//左方選手為Player2，黃色圓點應顯示在左邊
                leftPlayerServe.isHidden = false
                rightPlayerServe.isHidden = true
                if leftPlayerScoreCount % 2 == 0{
//發球時的分數為偶數，方向是左下到右上
                    leftLowerView.isHidden = false
                    leftUpVIew.isHidden = true
                    rightLowerView.isHidden = true
                    rightUpView.isHidden = false
                    serveDirectionImageView.image = UIImage(named: "leftEven")
                }else if leftPlayerScoreCount % 2 == 1{
//發球時的分數為奇數，方向是左上到右下
                    leftLowerView.isHidden = true
                    leftUpVIew.isHidden = false
                    rightLowerView.isHidden = false
                    rightUpView.isHidden = true
                    serveDirectionImageView.image = UIImage(named: "leftOdd")
                }
            }
//判斷完後把多取出來的值補回陣列中，才不會影響後續的判斷結果
            getScoreSequence.append("Player2")
        }
    }
    

//按reset按鈕後，回到初始狀態，時間歸，顯示start案紐
    @IBAction func reset(_ sender: Any) {
        initialUI()
        timer?.invalidate()
        counter = 0
        timeLabel.text = "00:00:00"
    }

//若獲勝選手為左方選手，傳輸獲勝者的資料到下一頁
    @IBSegueAction func showWinner(_ coder: NSCoder) -> AlertViewController? {
        var winnerPersonName: String!
        let winnerPerson = String(getScoreSequence.popLast()!)
        if winnerPerson == "Player1"{
            winnerPersonName = player1Name ?? "Player1"
        }else if winnerPerson == "Player2"{
            winnerPersonName = player2Name ?? "Player2"
        }
        let leftWinner = winnerPersonName
        let Controller = AlertViewController(coder: coder)
        Controller?.winnerName = leftWinner
        return Controller
    }

//若獲勝選手為右方選手，傳輸獲勝者的資料到下一頁
    @IBSegueAction func showRightWinner(_ coder: NSCoder) -> AlertViewController? {
        var winnerName: String!
        let winnerPerson = String(getScoreSequence.popLast()!)
        if winnerPerson == "Player1"{
            winnerName = player2Name ?? "Player2"
        }else if winnerPerson == "Player2"{
            winnerName = player1Name ?? "Player1"
        }
        let rightWinner = winnerName
        let Controller = AlertViewController(coder: coder)
        Controller?.winnerName = rightWinner
        return Controller
    }
    

}
