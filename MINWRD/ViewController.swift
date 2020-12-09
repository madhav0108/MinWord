//
//  ViewController.swift
//  MINWRD
//
//  Created by madhav sharma on 12/8/20.
//

import UIKit

class ViewController: UIViewController {
    
    var infoCount = 0
    
    @IBOutlet weak var rndWrdLbl: UILabel!
    @IBOutlet weak var newRndWrd: UIButton!
    @IBOutlet weak var rndWrdInfo: UIButton!
    @IBOutlet weak var rndWrdDef: UILabel!
    
    @IBAction func getRndWrdInfo(_ sender: Any) {
        
        rndWrdDef.isHidden = false
        
        let infoWrd = rndWrdLbl.text!
        let url = URL(string: "https://www.dictionary.com/browse/" + infoWrd)!
        
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var refDef = ""
            
            if let error = error {
                print(error)
            } else {
                if let unwrappedData = data {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    var stringSeperator = "<meta name=\"description\" content=\""
                    if let defExtra = dataString?.components(separatedBy: stringSeperator) {
                        print(defExtra)
                        if defExtra.count > 1 {
                            stringSeperator = "definition, "
                            let defLilExtra = defExtra[1].components(separatedBy: stringSeperator)
                            if defLilExtra.count > 1 {
                                stringSeperator = "See more.\">"
                                let defCollection = defLilExtra[1].components(separatedBy: stringSeperator)
                                if defCollection.count > 1 {
                                    stringSeperator = " "
                                    let def = defCollection[0].components(separatedBy: stringSeperator)
                                    if def.count > 18 {
                                        for i in 0..<17 {
                                            refDef.append(def[i])
                                            refDef.append(" ")
                                        }
                                        refDef.append("...")
                                    } else {
                                        for i in 0..<def.count {
                                            refDef.append(def[i])
                                            refDef.append(" ")
                                        }
                                    }
                                }
                                //print(def)
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.sync {
                self.rndWrdDef.text = refDef
            }
        }
        task.resume()
    }
    
    @IBAction func getNewRndWrd(_ sender: Any) {
        
        rndWrdInfo.isHidden = false
        rndWrdDef.isHidden = true
        
        let url = URL(string: "https://www.mit.edu/~ecprice/wordlist.10000")!
        
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var word = ""
            var words5 = [String]()
            
            if let error = error {
                print(error)
            } else {
                if let unwrappedData = data {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    let stringSeperator = "\n"
                    if let words = dataString?.components(separatedBy: stringSeperator) {
                        //print(words)
                        for wrd in words {
                            if wrd.count >= 5 {
                                words5.append(wrd)
                            }
                        }
                        //print(words.count)
                        //print(words5.count)
                        let n = words5.count
                        let numbs = 0..<n
                        let a = Int.random(in: numbs)
                        word = words5[a]
                    }
                }
            }
            DispatchQueue.main.sync {
                self.rndWrdLbl.text = word
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if infoCount == 0 {
            rndWrdInfo.isHidden = true
            rndWrdDef.isHidden = true
        }
    }
    
    // Do any additional setup after loading the view.
}




