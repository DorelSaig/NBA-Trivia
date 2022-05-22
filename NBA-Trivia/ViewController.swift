//
//  ViewController.swift
//  NBA-Trivia
//
//  Created by Dorel Saig on 21/05/2022.
//

import UIKit

class ViewController: UIViewController {
    
    let Url = "https://pastebin.com/raw/R194aafy"
    var dataManager:DataManager!
    
    @IBOutlet weak var buttonA1: UIButton!
    @IBOutlet weak var buttonA2: UIButton!
    @IBOutlet weak var buttonA3: UIButton!
    @IBOutlet weak var buttonA4: UIButton!
    
    @IBOutlet weak var panel_LBL_counter: UILabel!
    @IBOutlet weak var panel_LBL_score: UILabel!
    @IBOutlet weak var panel_IMG_q: UIImageView!
    @IBOutlet weak var panel_PRB_progress: UIProgressView!
    
    
    @IBOutlet weak var panel_IMG_0: UIImageView!
    @IBOutlet weak var panel_IMG_1: UIImageView!
    @IBOutlet weak var panel_IMG_2: UIImageView!
    
    var lives: [UIImageView]!
    var game_counter:Int = 1
    var score:Int = 0
    var live:Int = 3
    var buttons: [UIButton]!
    var currentq:Quastion!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dataManager = DataManager()
        dataManager.fetchFromServer(url: Url, delegate: self)
        
        initView()

        
    }
    
    func initView() {
        live = 3
        panel_LBL_score.text = "\(score)"
        panel_LBL_counter.text = "\(game_counter) / 15"
        lives = [panel_IMG_0, panel_IMG_1, panel_IMG_2]
        buttons = [buttonA1, buttonA2, buttonA3, buttonA4]
    }
    

    /*Next Q Logic*/
    
    func nextQuestion(){
        let q = dataManager.data?.allQuestions?[game_counter-1]
        panel_IMG_q.loadFrom(URLAddress: q?.imageUrl ?? "")
        
        currentq = q
        
        let a = dataManager.data?.allAnswers?.shuffled()
        buttons = buttons.shuffled()
        
        for i in 0...buttons.count-1 {
            if(a![i] == q?.answer){
                buttons[i].setTitle(a![i+1], for: .normal)
            } else {
            buttons[i].setTitle(a![i], for: .normal)
            }
            
        }
        
        buttons[0].setTitle(q?.answer, for: .normal)

    }
   
    
    /*Button Init*/
    
    @IBAction func btnA1Clicked(_ sender: Any) {
        checkAnswer(chosenAnswer: buttonA1.currentTitle!)
    }
    @IBAction func btnA2Clicked(_ sender: Any) {
        checkAnswer(chosenAnswer: buttonA2.currentTitle!)
    }
    @IBAction func btnA3Clicked(_ sender: Any) {
        checkAnswer(chosenAnswer: buttonA3.currentTitle!)
    }
    @IBAction func btnA4Clicked(_ sender: Any) {
        checkAnswer(chosenAnswer: buttonA4.currentTitle!)
    }
    
    
    /*Answer Logic*/
    
    func checkAnswer(chosenAnswer:String){
        if(chosenAnswer == currentq.answer){
            score+=1
            panel_LBL_score.text = "\(score)"
        }else {
            if (live >= 0){
                lives[live-1].isHidden = true
                live-=1
                
            }else{
                exit(0)
            }
        }
        
        panel_PRB_progress.progress = Float(game_counter)/Float(15)
        
        if (game_counter < 15){
            game_counter+=1
            panel_LBL_counter.text = "\(game_counter) / 15"
            nextQuestion()
        }else{
            
        }
    }
    
}



extension ViewController:Delegate_Data{
    
    func dataRecieved(model: MyData) {
        dataManager.setData(data: model)
        nextQuestion()
    }
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
}

