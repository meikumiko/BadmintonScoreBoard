//
//  FirstpageViewController.swift
//  BadmintonScoreBoard
//
//  Created by Hsiao-Han Chi on 2022/4/8.
//

import UIKit

class FirstpageViewController: UIViewController {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }
    
    @IBOutlet weak var player1TextField: UITextField!
    @IBOutlet weak var player2TextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBSegueAction func showResult(_ coder: NSCoder) -> MatchViewController? {
        
        let player1Name = String(player1TextField.text!)
        let player2Name = String(player2TextField.text!)
        //目的地controller
        let controller = MatchViewController(coder: coder)
        controller?.player1Name = player1Name
        //前面的player1Name是目的地controller中設定的變數，後面的player1Name是這裡儲存字串的常數
        controller?.player2Name = player2Name
        return controller
    }
    
    @IBAction func DismissKeyBoard(_ sender: Any) {
    }
    @IBAction func DismissKeyBoard2(_ sender: Any) {
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
