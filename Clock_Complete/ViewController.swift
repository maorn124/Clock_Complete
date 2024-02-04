//
//  ViewController.swift
//  Clock3
//
//  Created by Maor Niv on 2/4/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var hoursTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let months:[String] = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"]
    var timer: Timer?
    var totalTimeInSeconds: Int = 0
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        CurrentTimeLabel()
        BackgroundImageForTime()
    }

    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        startTimer()
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        stopTimer()
    }
    
    func startTimer() {
        guard let hoursText = hoursTextField.text,
              let minutesText = minutesTextField.text,
              let hours = Int(hoursText),
              let minutes = Int(minutesText) else {
            // Handle invalid input
            return
        }
        
        totalTimeInSeconds = (hours * 3600) + (minutes * 60)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        countdownLabel.text = "Timer Stopped"
        playAudio()
    }

    @objc func updateTimer() {
        if totalTimeInSeconds > 0 {
            totalTimeInSeconds -= 1
            let hours = totalTimeInSeconds / 3600
            let minutes = (totalTimeInSeconds % 3600) / 60
            let seconds = totalTimeInSeconds % 60
            
            countdownLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            stopTimer()
        }
    }
    
    func CurrentTimeLabel() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            let date = Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            
            let currentTime = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            let calender = Calendar.current
            let month = calender.component(.month, from: date)
            let day = calender.component(.day, from: date)
            let monthWords = self.months[month - 1]
            
            var daystring = String(day)
            let lastChar = daystring.last!
            
            if lastChar == "1" {
                daystring = daystring + "st"
            }
            else if lastChar == "2" {
                daystring = daystring + "nd"
            }
            else if lastChar == "3" {
                daystring = daystring + "rd"
            }
            else {
                daystring = daystring + "th"
            }
            
            let year = calender.component(.year, from: date)
            let currentDate = "\(monthWords) \(daystring), \(year)"
            
            self.timeLabel.text = currentTime
            self.dateLabel.text = currentDate
            
        }
    }
    func BackgroundImageForTime() {
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            
            var imageName: String
            
            if hour >= 6 && hour < 18 {
                imageName = "morning"
            } else {
                imageName = "evening"
            }
            let backgroundImage = UIImage(named: imageName)
            view.backgroundColor = UIColor(patternImage: backgroundImage!)
    }
    func playAudio() {
        guard let url = Bundle.main.url(forResource: "Fitz And The Tantrums - Spark [Official Audio].mp3", withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
        }
    }

}


