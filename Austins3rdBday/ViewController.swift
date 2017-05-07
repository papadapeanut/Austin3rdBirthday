//
//  ViewController.swift
//  Austins3rdBday
//
//  Created by Jason Moore on 5/3/17.
//  Copyright © 2017 Jason Moore. All rights reserved.
//

import UIKit




class ViewController: UIViewController {
    
    //UI elements
    @IBOutlet weak var lbl_question: UILabel!
    @IBOutlet weak var btn_clue: UIButton!
    @IBOutlet weak var clueImage: UIImageView!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var btn_submit: UIButton!
    
    
    
    //Variable declarations
    var qNum=Int()
    var question=String()
    var numberOfQuestions=Int()
    var picLocation=Array<URL>()
    var playerPicLocation=Array<URL>()
    let happyBday="Happy 3rd Birthday Austin!"
    var answers: [String] = ["Mater", "Lightning", "Blaze", "Pickle", "Darington", "Stripes", "Thomas", "Percy"]
    
    

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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
            
            let alertController = UIAlertController(title: "Good Job Austin!", message: "", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
                alert -> Void in
                
                let ClueTextField = alertController.textFields![0] as UITextField
                
                self.checkPassword(thePassword: ClueTextField.text!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                
            })
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Clue Password"
            }
            
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    

    


    //Action taken when clue button clicked
    @IBAction func clickButton(_ sender: UIButton) {
       
    }
    
    func checkPassword(thePassword: String){
        let rightPassword = answers[qNum]
        print("The Actual Password is " + rightPassword)
        print("The Inputted Password was " + thePassword)
       
        //This isn't Working ----*****----
        if thePassword == rightPassword {
            let alertController = UIAlertController(title: "You got it!", message: "", preferredStyle: .alert)
        
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("you have pressed OK button");
                self.getQuestion()
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
        
    // Create image from URL
    //var myImage =  UIImage(data: NSData(contentsOfURL: imageURLs[0])!)
    
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


