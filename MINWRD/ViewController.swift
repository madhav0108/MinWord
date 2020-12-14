//
//  ViewController.swift
//  MINWRD
//
//  Created by madhav sharma on 12/8/20.
//

import UIKit

class ViewController: UIViewController {
    
    var wrdHold = ""
    
    @IBOutlet weak var rndWrdLbl: UILabel!
    @IBOutlet weak var newRndWrd: UIButton!
    @IBOutlet weak var rndWrdInfo: UIButton!
    @IBOutlet weak var rndWrdDef: UILabel!
    @IBOutlet weak var rndWrdClue: UIButton!
    @IBOutlet weak var rndWrdSyn: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var guessCheckBtn: UIButton!
    
    @IBAction func guessChecking(_ sender: Any) {
        if guessTextField.text == wrdHold {
            guessTextField.layer.borderWidth = 2.0
            guessTextField.layer.borderColor = #colorLiteral(red: 0.3803921569, green: 0.768627451, blue: 0.3294117647, alpha: 1)
        } else {
            guessTextField.layer.borderWidth = 2.0
            guessTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4156862745, blue: 0.3725490196, alpha: 1)
        }
    }
    @IBAction func getRndWrdInfo(_ sender: Any) {
        //rndWrdSyn.isHidden = true
        rndWrdDef.isHidden = false
        let image = UIImage(systemName: "info.circle.fill")
        rndWrdInfo.setImage(image, for: .normal)
        
        let infoWrd = wrdHold
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
                                refDef = refDef.replacingOccurrences(of: "  ", with: " ")
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
        let image = UIImage(systemName: "lightbulb.fill")
        rndWrdClue.setImage(image, for: .normal)
        
        let synWrd = wrdHold
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
                                synCol = synCol.replacingOccurrences(of: "  ", with: " ")
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
        guessTextField.layer.cornerRadius = 5.0
        guessTextField.layer.borderWidth = 0.0
        guessTextField.text = ""
        let imageInfo = UIImage(systemName: "info.circle")
        rndWrdInfo.setImage(imageInfo, for: .normal)
        let imageClue = UIImage(systemName: "lightbulb")
        rndWrdClue.setImage(imageClue, for: .normal)
        
        let url = URL(string: "https://www.mit.edu/~ecprice/wordlist.10000")!
        
        let request = NSMutableURLRequest(url: url)
        
        URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var wordWithB = ""
            var word = ""
            var wordB = ""
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
                        wordB = words5[a]
                        //print("wordB: ",wordB)
                        
                        let wrdLen = wordB.count
                        //print("wrdLen: ",wrdLen)
                        let nBlanks = wrdLen/2 + 1
                        //print("nBlanks: ",nBlanks)
                        for _ in 0..<nBlanks {
                            let nWord = 0..<wrdLen
                            let b = Int.random(in: nWord)
                            //print("b: ",b)
                            let range = wordB.index(wordB.startIndex, offsetBy: b)..<wordB.index(wordB.startIndex, offsetBy: b+1)
                            //print("range: ",range)
                            if String(wordB[b]) != "-" {
                                let wrdWithB = wordB.replacingCharacters(in: range, with: "_")
                                wordB = wrdWithB
                                //print("wrdWithB: ",wrdWithB)
                                //print("wordB: ",wordB)
                            }
                        }
                        wordWithB = wordB
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.rndWrdLbl.text = wordWithB
                self.wrdHold = word
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guessTextField.layer.cornerRadius = 5.0
        guessTextField.text = ""
        guessTextField.rightViewMode = UITextField.ViewMode.always
        guessTextField.rightView = guessCheckBtn
        //rndWrdDef.isHidden = true
        //rndWrdSyn.isHidden = true
        getNewRndWrd(self)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    // Do any additional setup after loading the view.
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}



