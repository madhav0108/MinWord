//
//  ViewController.swift
//  MINWRD
//
//  Created by madhav sharma on 12/8/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var rndWrdLbl: UILabel!
    @IBOutlet weak var newRndWrd: UIButton!
    @IBOutlet weak var rndWrdInfo: UIButton!
    @IBOutlet weak var rndWrdDef: UILabel!
    
    @IBAction func getRndWrdInfo(_ sender: Any) {
        let infoWrd = rndWrdLbl.text!
        let url = URL(string: "https://www.dictionary.com/browse/" + infoWrd)!
        
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var def = ""
            
            if let error = error {
                print(error)
            } else {
                if let unwrappedData = data {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    var stringSeperator = "<meta name=\"description\" content=\""
                    if let defExtra = dataString?.components(separatedBy: stringSeperator) {
                        print(defExtra)
                        if defExtra.count > 1 {
                            stringSeperator = "See more.\">"
                            let defCollection = defExtra[1].components(separatedBy: stringSeperator)
                            if defCollection.count > 1 {
                                def = defCollection[0]
                                //print(def)
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.sync {
                self.rndWrdDef.text = def
            }
        }
        task.resume()
    }
    @IBAction func getNewRndWrd(_ sender: Any) {
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
        
    }
    
    // Do any additional setup after loading the view.
}




