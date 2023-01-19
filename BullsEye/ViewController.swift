//
//  ViewController.swift
//  BullsEye
//
//  Created by Louis Parton on 1/17/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var slider: UISlider!
    
    @IBOutlet var targetLabel: UILabel!
    
    @IBOutlet var roundLabel: UILabel!
    
    var targetValue = 0
    
    var currentValue = 0
    
    var score = 0
    
    var round = 0
    
    func startNewRound() {
        round += 1
        targetValue = Int.random(in: 1...100)
        currentValue = 50
        slider.value = Float(currentValue)
        updateLabels()
    }
    @IBAction func startNewGame() {
        score = 0
        round = 0
        startNewRound()
          let transition = CATransition()
          transition.type = CATransitionType.fade
          transition.duration = 1
          transition.timingFunction = CAMediaTimingFunction(
            name: CAMediaTimingFunctionName.easeOut)
          view.layer.add(transition, forKey: nil)
    }
    func updateLabels() {
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
    }
        override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
            let thumbImageNormal = UIImage(named: "SliderThumb-Normal")!
            slider.setThumbImage(thumbImageNormal, for: .normal)

            let thumbImageHighlighted = UIImage(
              named: "SliderThumb-Highlighted")!
            slider.setThumbImage(thumbImageHighlighted, for: .highlighted)

            let insets = UIEdgeInsets(
              top: 0,
              left: 14,
              bottom: 0,
              right: 14)

            let trackLeftImage = UIImage(named: "SliderTrackLeft")!
            let trackLeftResizable = trackLeftImage.resizableImage(
              withCapInsets: insets)
            slider.setMinimumTrackImage(trackLeftResizable, for: .normal)

            let trackRightImage = UIImage(named: "SliderTrackRight")!
            let trackRightResizable = trackRightImage.resizableImage(
              withCapInsets: insets)
            slider.setMaximumTrackImage(trackRightResizable, for: .normal)
    }

    @IBAction func showAlert(){
        let difference = abs(targetValue - currentValue)
        let points = 100 - difference
        let message: String
        // checks if the value is double or not
        var doubleValue = 0
        if points == 100{
            doubleValue = doubleValue + 1
            score += 200
        } else{
            score += points
        }
        
        let title: String
        if difference == 0 {
            title = "Perfect!"
        }
        else if difference < 5 {
            title = "You almost had it!"
        }
        else if difference < 10 {
            title = "Pretty good!"
        }
        else {
            title = "Not even close..."
        }
        // alerts that you got 200 points if you had a perfect guess
        if doubleValue == 1{
            message = "You scored 200 points"
        }
        // standard message for anything besides a perfect guess
        else {
            message = "You scored \(points) points"
        }
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)

        let action = UIAlertAction(
            title: "OK",
            style: .default,
            handler: { _ in
                self.startNewRound()
            })

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = lroundf(slider.value)
    }
}

