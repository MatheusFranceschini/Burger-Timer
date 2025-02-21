//
//  ViewController.swift
//  Burger Timer
//
//  Created by Matheus Franceschini on 15/02/25.
//

import UIKit
import AVFAudio

class ViewController: UIViewController {
    @IBOutlet weak var burgerStatusMessageLabel: UILabel!
    @IBOutlet weak var burgerImageView: UIImageView!
    @IBOutlet weak var cookingTimeProgressView: UIProgressView!
    
    let burgerTime: [String: Int] = ["rare": 240, "medium": 360, "well-done": 480]
    
    var cookingPoint: String = ""
    var timer = Timer()
    var counter = 0
    var totalTime = 0
    var player = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
    }

    func setupGradientBackground() {
        let colorBottom: CGColor = CGColor(red: 91/255, green: 145/255, blue: 59/255, alpha: 1)
        let colorTop: CGColor = CGColor(red: 119/255, green: 178/255, blue: 84/255, alpha: 1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        timer.invalidate()
        player.pause()
        cookingPoint = ""
        burgerStatusMessageLabel.text = ""
        burgerImageView.image = UIImage()
        
        guard let buttonTitle = sender.titleLabel?.text else {
            print("Botão sem título")
            return
        }
        
        cookingPoint = buttonTitle
        totalTime = burgerTime[cookingPoint]!
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setupTimer), userInfo: nil, repeats: true)
    }
    
    @objc func setupTimer() {
        if totalTime >= counter {
            if totalTime == burgerTime[cookingPoint]! / 2 {
                burgerStatusMessageLabel.text = "Time to flip it!"
                playSound(name: "bell-sound")
            }
            cookingTimeProgressView.progress = 1.0 - (Float(Double(totalTime) / Double(burgerTime[cookingPoint]!)))
            totalTime -= 1
        } else {
            timer.invalidate()
            burgerStatusMessageLabel.text = "Enjoy your meal!"
            burgerImageView.image = UIImage(named: "hamburgers")
            playSound(name: "alarm-sound")
        }
    }
    
    func playSound(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else { return }
        
        do {
            try! player = AVAudioPlayer(contentsOf: url)
            player.play()
        }
        
    }

}

