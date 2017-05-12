//
//  ViewController.swift
//  Austins3rdBday
//
//  Created by Jason Moore on 5/3/17.
//  Copyright © 2017 Jason Moore. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import AudioToolbox

class ViewController: UIViewController {
    
    
    //UI elements
    @IBOutlet weak var lbl_question: UILabel!
    @IBOutlet weak var btn_clue: UIButton!
    @IBOutlet weak var clueImage: UIImageView!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var btn_playVideo: UIButton!
    @IBOutlet weak var lbl_hint: UILabel!
    @IBOutlet weak var btn_plane: UIButton!
    @IBOutlet weak var airplaneLeftConstraint: NSLayoutConstraint!

    
    
    //Variable declarations
    var playerController = AVPlayerViewController()
    var audioPlayer:AVAudioPlayer?
    var player:AVPlayer?
    var qNum = Int()
    var question = String()
    var numberOfQuestions = Int()
    var picLocation = Array<URL>()
    var playerPicLocation = Array<URL>()
    let happyBday = "Happy 3rd Birthday Austin!"
    var answers: [String] = ["","Mater", "Lightning", "Blaze", "Pickle", "Darington", "Stripes", "Thomas", "Percy"]
    var hints: [String] = ["", "Cars", "McQueen", "Let's..."]
    var videoWatched = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Intialize picLocation array to create URLs for pictures
        buildImageArray()
        buildPlayerImageArray()
        
        
        //intialize question number variable to 1
        qNum = 0
        
        //Get number of Questions
        numberOfQuestions = picLocation.count
        
        //Set question Label
        lbl_question.text = happyBday
        
        //Set lbl_hint for introduction view
        lbl_hint.text = "<--Click for hint"
        
        //Set introduction birthday balloons
        clueImage.image = #imageLiteral(resourceName: "happyBirthday")
        
       

    }
    
    //Play airplane sound and animate plane to leave the screen when airplane is pressed
    @IBAction func playPlaneSound(_ sender: UIButton) {
        
        playSound(soundName: "planeSound", fileExt: ".mp3")
        
        //Animation to move airplane off screen then return to original location
        let originalLocation = self.airplaneLeftConstraint.constant
        self.airplaneLeftConstraint.constant = -150
        UIView.animate(withDuration: 7, animations: {
            self.view.layoutIfNeeded()
        }) {_ in self.airplaneLeftConstraint.constant = originalLocation}
    }
    
    

    //Play mater sound when mater is pressed
    @IBAction func playMater(_ sender: Any) {
        playSound(soundName: "mater_KaChing", fileExt: ".mp3")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Function to show video player and play video
    func playVideo(theName: String, fileExt: String){
    
    let videoString:String? = Bundle.main.path(forResource: theName, ofType: fileExt)
    
    if let url = videoString {
        let videoURL = NSURL(fileURLWithPath: url)
        player = AVPlayer(url: videoURL as URL)
        playerController.player = self.player
        }
    }
    
    
    //function to play sound effect pass resource name & extension
    func playSound(soundName: String, fileExt: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: fileExt)!
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let audioPlayer = audioPlayer else { return }
            
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }

    
    

    //Pass the number of the image in the array to fetch --Pictures
    func FetchClueImage(imageNumber: Int){
        let thePicture = URL(string: picLocation[imageNumber].absoluteString)!
        
        let urlString = thePicture.absoluteString
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed fetching image:", error!)
                return
            }
            
            DispatchQueue.main.async {
                self.clueImage.image = UIImage(data: data!)
            }
            }.resume()
    }
    
    
    //Play Introduction Video on button press
    @IBAction func PlayVideo(_ sender: Any) {
        playVideo(theName: "Video", fileExt: ".mp4")
        self.present(self.playerController, animated: true, completion: {
            self.playerController.player = self.player
            self.player?.play()
            self.videoWatched = true
        })
    }
    
    
    
    //Pass the number of the image in the array to fetch -- Players
    func FetchPlayerImage(imageNumber: Int){
        let thePicture = URL(string: playerPicLocation[imageNumber].absoluteString)!
        
        let urlString = thePicture.absoluteString
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed fetching image:", error!)
                return
            }
            
            DispatchQueue.main.async {
                self.playerImage.image = UIImage(data: data!)
            }
            }.resume()
    }

    

    //Action take when submit button clicked
    @IBAction func clickSubmit(_ sender: UIButton) {
        if videoWatched == false{
            playVideo(theName: "Video", fileExt: ".mp4")
            self.present(self.playerController, animated: true, completion: {
                self.playerController.player = self.player
                self.player?.play()
                self.videoWatched = true
            })
        } else if qNum == 0 {
            getQuestion()
            
            //Disable intro video button and hide once game has started
            btn_playVideo.isEnabled = false
            btn_playVideo.isHidden = true
            
            //Disable airplane button and hide once game has started
            btn_plane.isEnabled = false
            btn_plane.isHidden = true
            
        }else{
            
            
            
            //Make sure hint label is empty when loading new question
            lbl_hint.text = ""
            
            let alertController = UIAlertController(title: "Assigning below", message: "", preferredStyle: .alert)
            
            // Background color.
            let backView = alertController.view.subviews.last?.subviews.last
            backView?.layer.cornerRadius = 10.0
            backView?.backgroundColor = UIColor.darkGray
            
            // Change Title With Color and Font:
            let myString  = "Enter Secret Code"
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Chalkboard SE", size: 24.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:0,length:myString.characters.count))
            alertController.setValue(myMutableString, forKey: "attributedTitle")
            
            let saveAction = UIAlertAction(title: "Submit", style: .default, handler: {
                alert -> Void in
                
                let ClueTextField = alertController.textFields![0] as UITextField
                
                self.checkPassword(thePassword: ClueTextField.text!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action : UIAlertAction!) -> Void in
                
            })
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Secret Password"
            }
            
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

    
    //Action taken when clue button clicked
    @IBAction func clickButton(_ sender: UIButton) {
        //Ignore click if on introduction screen
        if qNum != 0{
            lbl_hint.text = hints[qNum]
        }
    }
    
    //Check answers array that correct password was entered & display Alert message
    func checkPassword(thePassword: String){
        let rightPassword = answers[qNum]
        print("The Actual Password is " + rightPassword)
        print("The Inputted Password was " + thePassword)
       
        if thePassword == rightPassword {
            
            playSound(soundName: "blaze_horn", fileExt: ".mp3")
            
            let alertController = UIAlertController(title: "Assigning below", message: "", preferredStyle: .alert)
            
            // Background color.
            let backView = alertController.view.subviews.last?.subviews.last
            backView?.layer.cornerRadius = 10.0
            backView?.backgroundColor = UIColor.darkGray
            
            // Change Title With Color and Font:
            let myString  = "You got it!"
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Chalkboard SE", size: 24.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:0,length:myString.characters.count))
            alertController.setValue(myMutableString, forKey: "attributedTitle")

        
            let OKAction = UIAlertAction(title: "Click Here For Next Clue", style: .default) { (action:UIAlertAction!) in
                print("you have pressed OK button")
                self.getQuestion()
                }
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)

        }else{
            
            playSound(soundName: "miss", fileExt: ".mp3")
            
            let alertController = UIAlertController(title: "Assigning below", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            // Background color.
            let backView = alertController.view.subviews.last?.subviews.last
            backView?.layer.cornerRadius = 10.0
            backView?.backgroundColor = UIColor.darkGray
            
            // Change Title With Color and Font:
            let myString  = "Oops, Try Again!"
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Chalkboard SE", size: 24.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:0,length:myString.characters.count))
            alertController.setValue(myMutableString, forKey: "attributedTitle")
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("Incorrect Passcode entered")
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
        }
        
    }
    
    //Question flow & Check win logic
    func getQuestion(){
        if qNum == numberOfQuestions-1 {
            qNum+=1
            //Final Clue will be Display
            FetchClueImage(imageNumber: qNum-1)
            FetchPlayerImage(imageNumber: qNum-1)
            lbl_question.text="Final Clue"
            btn_submit.isEnabled=false
        }
        else{
            qNum+=1
            //Intial question variable
            question = "Clue #" + String(qNum)
            FetchClueImage(imageNumber: qNum-1)
            FetchPlayerImage(imageNumber: qNum-1)
            lbl_question.text=question}
    }
    
    
    
    
    
    //builds array of URL to images from images folder -- Clue pictures
    func buildImageArray(){
    if let path = Bundle.main.resourcePath {
    
    let imagePath = path + "/images"
    let url = NSURL(fileURLWithPath: imagePath)
    let fileManager = FileManager.default
    
    let properties = [URLResourceKey.localizedNameKey,
    URLResourceKey.creationDateKey, URLResourceKey.localizedTypeDescriptionKey]
    
    do {
    let imageURLs = try fileManager.contentsOfDirectory(at: url as URL, includingPropertiesForKeys: properties, options:FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
    
    print("image URLs: \(imageURLs)")
    
    picLocation = imageURLs
        
        
    } catch let error1 as NSError {
    print(error1.description)
    }
        }
}
        
    //builds array of URL to images from players folder -- player pictures
    func buildPlayerImageArray(){
        if let path = Bundle.main.resourcePath {
                
            let imagePath = path + "/players"
            let url = NSURL(fileURLWithPath: imagePath)
            let fileManager = FileManager.default
                
            let properties = [URLResourceKey.localizedNameKey,
                                  URLResourceKey.creationDateKey, URLResourceKey.localizedTypeDescriptionKey]
                
        do {
            let imageURLs = try fileManager.contentsOfDirectory(at: url as URL, includingPropertiesForKeys: properties, options:FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                    
                print("image URLs: \(imageURLs)")
                    
                playerPicLocation = imageURLs
                    
                // Create image from URL
                //var myImage =  UIImage(data: NSData(contentsOfURL: imageURLs[0])!)
                    
     } catch let error1 as NSError {
           print(error1.description)
        }
    }
}
    

    
    
        
        
        
//****//
}


