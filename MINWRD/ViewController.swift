//
//  ViewController.swift
//  MINWRD
//
//  Created by madhav sharma on 12/8/20.
//

import UIKit

class ViewController: UIViewController {
    
    var wrdLen = 0
    
    @IBOutlet weak var rndWrdLbl: UILabel!
    @IBOutlet weak var newRndWrd: UIButton!
    @IBOutlet weak var rndWrdInfo: UIButton!
    @IBOutlet weak var rndWrdDef: UILabel!
    @IBOutlet weak var rndWrdClue: UIButton!
    @IBOutlet weak var rndWrdSyn: UILabel!
    
    @IBAction func getRndWrdInfo(_ sender: Any) {
        //rndWrdSyn.isHidden = true
        rndWrdDef.isHidden = false
        
        let infoWrd = rndWrdLbl.text!
        let url = URL(string: "https://www.dictionary.com/browse/" + infoWrd)!
        
        let request = NSMutableURLRequest(url: url)
        
        URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var refDef = ""
            
            if let error = error {
                print("error: ", error)
            } else {
                if let unwrappedData = data {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    if dataString!.contains("No results found for ") {
                        refDef.append("No definitions found")
                    } else {
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
                                            refDef.append(def[17])
                                            refDef.append("...")
                                        } else {
                                            for i in 0..<def.count {
                                                refDef.append(def[i])
                                                refDef.append(" ")
                                            }
                                        }
                                    }
                                }
                                refDef = refDef.replacingOccurrences(of: "&#39;", with: "'")
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.sync {
                self.rndWrdDef.text = refDef
            }
        }.resume()
    }
    
    @IBAction func getRndWrdClue(_ sender: Any) {
        //rndWrdDef.isHidden = true
        rndWrdSyn.isHidden = false
        
        let synWrd = rndWrdLbl.text!
        let url = URL(string: "https://www.thesaurus.com/browse/" + synWrd)!
        
        let request = NSMutableURLRequest(url: url)
        
        URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var synCol = ""
            
            if let error = error {
                print("error: ", error)
            } else {
                if let unwrappedData = data {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    if dataString!.contains("Did you mean") {
                        synCol.append("No clues found")
                    } else {
                        var stringSeperator = "<a font-weight=\"inherit\" href=\"/browse/"
                        if let synExtra = dataString?.components(separatedBy: stringSeperator) {
                            print(synExtra.count)
                            if synExtra.count > 1 {
                                if synExtra.count > 5 {
                                    for syn in 1..<5 {
                                        stringSeperator = "\" data-linkid=\"nn1ov4\""
                                        let refSyn = synExtra[syn].components(separatedBy: stringSeperator)
                                        synCol.append(refSyn[0])
                                        synCol.append(", ")
                                        //print(synCol)
                                    }
                                    let refSyn = synExtra[5].components(separatedBy: stringSeperator)
                                    synCol.append(refSyn[0])
                                } else {
                                    let range = synExtra.count
                                    let rangeLim = range - 1
                                    for syn in 1..<rangeLim {
                                        stringSeperator = "\" data-linkid=\"nn1ov4\""
                                        let refSyn = synExtra[syn].components(separatedBy: stringSeperator)
                                        synCol.append(refSyn[0])
                                        synCol.append(", ")
                                        print(synCol)
                                    }
                                    let refSyn = synExtra[rangeLim].components(separatedBy: stringSeperator)
                                    synCol.append(refSyn[0])
                                }
                                synCol = synCol.replacingOccurrences(of: "%20", with: " ")
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.sync {
                self.rndWrdSyn.text = synCol
            }
        }.resume()
    }
    
    
    @IBAction func getNewRndWrd(_ sender: Any) {
        rndWrdDef.isHidden = true
        rndWrdSyn.isHidden = true
        
        let url = URL(string: "https://www.mit.edu/~ecprice/wordlist.10000")!
        
        let request = NSMutableURLRequest(url: url)
        
        URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var word = ""
            var words5 = [String]()
            
            if let error = error {
                print("error: ", error)
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
                        //let wordLen = word.count
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.rndWrdLbl.text = word
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //rndWrdDef.isHidden = true
        //rndWrdSyn.isHidden = true
        getNewRndWrd(self)
        
    }
    
    // Do any additional setup after loading the view.
}




