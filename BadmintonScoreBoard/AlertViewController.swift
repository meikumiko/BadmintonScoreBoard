//
//  AlertViewController.swift
//  BadmintonScoreBoard
//
//  Created by Hsiao-Han Chi on 2022/4/17.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet weak var winnerNameLable: UILabel!
    var winnerName: String!
    
    func showWinner(){
        let winner = winnerName ?? "winner"
        winnerNameLable.text = winner
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showWinner()
        

        // Do any additional setup after loading the view.
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
