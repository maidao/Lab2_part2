//
//  ViewController.swift
//  LabWork2_collection
//
//  Created by Mai Dao on 10/14/16.
//  Copyright © 2016 Mai Dao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var collectionNames: UICollectionView!
    
    
    
    //@IBOutlet weak var CollectionCell_Id: UICollectionViewCell!
    
    
    var namesArray = [String]()
    var emoijArray = [String]()
    
    var eArray = [String]()
    var eExist = [String]()
    
    var timer:Timer! = nil
    
    func refresh () {
        submitToService(name: "", emoji: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        collectionNames.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return namesArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell_Id", for: indexPath) as! MyCollectionViewCell
        
        if let nameLabel = collectionViewCell.nameLabel
        {
            nameLabel.text = namesArray[indexPath.row]
        }
        
        if let emoijLabel = collectionViewCell.emojiLabel
        {
            emoijLabel.text = emoijArray[indexPath.row]
        }
        return collectionViewCell
    }
    
    
    
    func textFieldShouldBeginEditing(_ nameTextField: UITextField) -> Bool { print("textFieldShouldBeginEditing")
        nameTextField.backgroundColor = UIColor.yellow
        return true
    }
    func textFieldDidBeginEditing(_ nameTextField: UITextField) { print("textFieldDidBeginEditing")
    }
    func textFieldShouldEndEditing(_ nameTextField: UITextField) -> Bool { print("textFieldShouldEndEditing")
        nameTextField.backgroundColor = UIColor.white
        return true
    }
    func textFieldDidEndEditing(_ nameTextField: UITextField) {
        print("textFieldDidEndEditing") }
    
    func textFieldShouldReturn(_ nameTextField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        print("textField resignFirstResponder")
        
        let index = getRandom()
        if let text = nameTextField.text
        {
            submitToService(name:text, emoji:eArray[index])
        }
        
        collectionNames.reloadData()
        return true
    }

    

    func submitToService(name:String, emoji:String) {
        
        do
        {
            let stringUrl = "http://stephane.ayache.perso.luminy.univ-amu.fr/cgi-bin/serviceJson2.py?name=\(name)&emoji=\(emoji)"
            
            let encodedStringUrl = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            let myurl = URL(string: encodedStringUrl!)
            
            let   jsonString = try String(contentsOf: myurl!)
        
            let jsonData = jsonString.data(using: .utf8)
        
            let jsonJSON = try JSONSerialization.jsonObject(with: jsonData!, options: [])
        
            if let dictionary = jsonJSON as? [String: Any]
            {
          
                if let retrieved = dictionary["names"] as? [Any]
                {
                    namesArray = retrieved as! [String]
               
                    for (i, name) in namesArray.enumerated()
                    {
                        namesArray[i] = name.removingPercentEncoding!
                    }
                }
                
                if let retrieved = dictionary["emojis"] as? [Any]
                {
                    emoijArray = retrieved as! [String]
                    
                    for (i, name) in emoijArray.enumerated()
                    {
                        emoijArray[i] = name.removingPercentEncoding!
                    }
                }
                
            }
             collectionNames.reloadData()
        }
        catch
        {
            print("Error getting url content")
        }

        
        if (timer != nil) {timer.invalidate()}
        
        timer = Timer.scheduledTimer(timeInterval:10, target:self, selector:#selector(refresh), userInfo:nil, repeats:false)
        
        if (name != "") {
            
            nameTextField.text = ""
            nameTextField.isEnabled = true
            nameTextField.placeholder = "You already put your name"
        }
         eExist = eArray

    }
    
    func getRandom() -> Int
    {
        let a : UInt32 = 0
        let b : UInt32 = UInt32(eArray.count)
        var i : UInt32
        repeat {
            i = arc4random_uniform(b - a)
            let result = eExist.contains(eArray[Int(i)])
            print(result)
        } while (eExist.contains(eArray[Int(i)]) == true)
        
        return Int(i)
    }


}


    
    


