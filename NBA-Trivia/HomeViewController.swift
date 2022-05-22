//
//  HomeViewController.swift
//  NBA-Trivia
//
//  Created by Dorel Saig on 22/05/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    var lastScore:String?
    @IBOutlet weak var panel_LBL_lstscore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastScore = readStringDataFromPref(key: DataManager().LAST_SCORE_PREF_KEY)
        panel_LBL_lstscore.text = "Last score: \(lastScore ?? "0")"
    }
    
    func readStringDataFromPref(key: String) -> String {
        if UserDefaults.standard.string(forKey: key) == nil{
            return ""
        } else {
            return UserDefaults.standard.string(forKey: key)!
        }
    }
    
    @IBAction func startClicked(_ sender: Any) {
        performSegue(withIdentifier: "con", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dv = segue.destination as? ViewController {
            dv.lastScore = lastScore
        }
    }
}
