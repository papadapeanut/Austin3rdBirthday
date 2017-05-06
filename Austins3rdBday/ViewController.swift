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
    @IBOutlet weak var btn_submit: UIButton!
    
    
    //Variable declarations
    var qNum=Int()
    var question=String()
    var numberOfQuestions=Int()
    var picLocation=Array<URL>()
    let happyBday="Happy 3rd Birthday Austin!"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Intialize picLocation array to create URLs for pictures
        buildImageArray()
        
        //intialize question number variable to 1
        qNum = 1
        
        //Get number of Questions
        numberOfQuestions = picLocation.count
        
        //Intial question variable
        question = "Question " + String(qNum)
        
        //Set question Label
        lbl_question.text = happyBday
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //Pass the number of the image in the array to fetch
    func fetchImage(imageNumber: Int){
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
    

    //Action take when submit button clicked
    @IBAction func clickSubmit(_ sender: UIButton) {
        if qNum <= numberOfQuestions {
            fetchImage(imageNumber: qNum-1)
            qNum+=1
            lbl_question.text=String(qNum)
        }
        else{
            //WHATEVER HAPPENS WHEN AUSTIN WINS GOES HERE
            lbl_question.text="Winner Winner Chicken Dinner"
        }

    }
    
    
    //Action taken when clue button clicked
    @IBAction func clickButton(_ sender: UIButton) {
        
    }
    
    //builds array of URL to images
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
    
        
        
        
//****//
    }
}

