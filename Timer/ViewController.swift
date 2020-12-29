//
//  ViewController.swift
//  Timer
//
//  Created by Vladimir Stepanchikov on 12.01.2020.
//  Copyright © 2020 Vladimir Stepanchikov. All rights reserved.
//

import Cocoa
import MediaPlayer

class Audio {
    static let sharedInstance = Audio()
    
    var player: AVPlayer!

    func playSound () {
        let url = URL(fileURLWithPath: Bundle.main.path(forSoundResource: NSSound.Name ("Sound.m4a"))!)
        player = AVPlayer(url: url)
        player.play()
    }
}

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        labelTime.font = NSFont.monospacedDigitSystemFont(ofSize: 50, weight: .bold)
        
        slider.integerValue = savedTime
        time = slider.integerValue
        showTime()
        
        NotificationCenter.default.addObserver(forName: NSWindow.didResizeNotification, object: nil, queue: OperationQueue.main) { (Notification) in
            
            self.labelTime.font = NSFont.monospacedDigitSystemFont(ofSize: self.view.bounds.size.height / 10 * 2, weight: .bold)
            
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    var time: Int = 62
    
    func showTime() {
        let min: Int = time / 60
        let sec: Int = time - (min * 60)
        
        var minStr = "\(min)"
        var secStr = "\(sec)"
        
        if min < 10 {
            minStr = "0"+minStr
        }
        if sec < 10 {
            secStr = "0"+secStr
        }
        
        labelTime.stringValue = "\(minStr):\(secStr)"
    }
    

    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var labelTime: NSTextField!
    @IBOutlet weak var buttonStart: NSButton!
    @IBOutlet weak var buttonReset: NSButton!
    
    var timer: Timer?
    
    
    @IBAction func pushStartAction(_ sender: Any) {
        self.slider.isEnabled = false
        
        if timer == nil {
            buttonStart.title = "Pause"
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                self.time = self.time - 1
                self.slider.integerValue = self.time
                self.showTime()
                
                if self.time == -1 {
                    Audio.sharedInstance.playSound()
                    self.pushResetAction(self)
                }
            }
        } else {
            buttonStart.title = "Continue"
            timer?.invalidate()
            timer = nil
        }
    }
    
    @IBAction func pushResetAction(_ sender: Any) {
        
        buttonStart.title = "Start"
        
        timer?.invalidate()
        timer = nil
        time = savedTime
        showTime()
        
        self.slider.isEnabled = true
        slider.integerValue = savedTime
        
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        time = slider.integerValue
        savedTime = slider.integerValue
        showTime()
    }
    
}

var savedTime: Int {
    get {
        let st = UserDefaults.standard.integer(forKey: "savedTime")
        if st == 0 {
            return 60
        } else {
            return st
        }
    }
    
    set {
        UserDefaults.standard.set(newValue, forKey: "savedTime")
        UserDefaults.standard.synchronize()
    }
}

