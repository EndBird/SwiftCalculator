//
//  ViewController.swift
//  Calculator
//
//  Created by Minh Huynh on 2016-06-28.
//  Copyright © 2016 Minh Huynh. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var getUserTypingStatus: Bool {
        get {
        return userIsInMiddleOfTypingANum}
    }
    private var brain: CalcBrain = CalcBrain()
    @IBOutlet private weak var display: UILabel!
    var tailHistoryEntry = CalcBrain.UserHistory.alCurrHis("0", "", "")
    var tailHistoryEntry1: CalcBrain.UserHistory? = CalcBrain.UserHistory.alCurrHis("0", "", "")
    var historyArray: [String] = []
    var userIsInMiddleOfTypingANum: Bool = false
    private var dotIsSet: Bool = false
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if justPerformedEnteredBinary == false {
        brain.description = " "
        }
        if userIsInMiddleOfTypingANum {
            let textCurrentlyInDisplay = display!.text!
            if digit == "." && dotIsSet == false {
                dotIsSet = true
                self.display!.text = textCurrentlyInDisplay + digit
                if tailHistoryEntry1 != nil {
                tailHistoryEntry =
                    CalcBrain.UserHistory.currHis(self.display!.text!, "", tailHistoryEntry1)
                
                }
                
                else {
                tailHistoryEntry =
                    CalcBrain.UserHistory.alCurrHis(self.display!.text!, "", "")
                }
                if historyArray != [] {
                    historyArray[historyArray.count-1] = self.display!.text!}
            
            }
            else if digit == "." && dotIsSet == true {
                return;
            }
            else {
                self.display!.text = textCurrentlyInDisplay + digit
                if tailHistoryEntry1 != nil {
                    tailHistoryEntry =
                        CalcBrain.UserHistory.currHis(self.display!.text!, "", tailHistoryEntry1)
                    
                }
                    
                else {
                    tailHistoryEntry =
                        CalcBrain.UserHistory.alCurrHis(self.display!.text!, "", "")
                }
                if historyArray != [] {
                    historyArray[historyArray.count-1] = self.display!.text!}

            }
        
        }
        else { //he's typing a new num
            if digit == "." && dotIsSet == false {
                display!.text = display!.text! + digit
                dotIsSet = true
            }
            else {
                if digit == "." {
                    return;
                }
                else {
                    tailHistoryEntry1 = tailHistoryEntry
                    tailHistoryEntry = CalcBrain.UserHistory.currHis(String(digit), "", tailHistoryEntry)
                    display!.text = digit;
                    dotIsSet = false
                    historyArray = []
                    historyArray = brain.traverseHistory(tailHistoryEntry, historyArray: historyArray)
                    let check = brain.historyArrayCheck(historyArray)
                    if check == false{
                    historyArray = []
                    tailHistoryEntry = CalcBrain.UserHistory.alCurrHis(digit, "", "")
                    tailHistoryEntry1 = nil
                    }
                
                }}
        }
        userIsInMiddleOfTypingANum = true
        brain.usertyping = true
        
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
        display.text = String(newValue)
        
        }
    }
    var savedProgram: CalcBrain.PropertyList?
    @IBAction func restore() {
        
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
        
    }
    @IBAction func save() {
        savedProgram = brain.program
        
    }
    var justPerformedEnteredBinary = true
    var justClickedMem = false
       @IBAction private func performOperation(sender: UIButton) {
        
        let mathematical = sender.currentTitle
        if mathematical != "Mem"    {
            if brain.checkOperation1(String(brain.description[brain.description.endIndex.predecessor()])) == false {
                
                if userIsInMiddleOfTypingANum {
                brain.description = brain.description + " " + String(displayValue) + " " + mathematical!
                    
                }
                else {
                
                brain.description.removeAtIndex(brain.description.endIndex.predecessor())
                brain.description.insert(mathematical![mathematical!.startIndex], atIndex: brain.description.endIndex)
                }
                if mathematical! == "=" { justPerformedEnteredBinary = false}
                else if mathematical! == "Pi" {justPerformedEnteredBinary = false}
                else if mathematical! == "e" {justPerformedEnteredBinary = false}
                else if mathematical! != "✕" && mathematical! != "x^y" && mathematical! != "÷" && mathematical! != "+"
                    
                    && mathematical! != "-" {justPerformedEnteredBinary = false}
                else {justPerformedEnteredBinary = true}
            }
            else if mathematical! == "=" {
                justPerformedEnteredBinary = false
                if  brain.checkOperation1(String(brain.description[brain.description.endIndex.predecessor()])) == false {
                    brain.description = brain.description + " " + String(displayValue) + mathematical!
                    
                }
                
            }
            else if mathematical! == "Pi" {
                justPerformedEnteredBinary = false
                brain.description = " Pi"
                
            }
                
            else if mathematical! == "e" {
                justPerformedEnteredBinary = false
                brain.description = " e"
            }
            else if mathematical! != "✕" && mathematical! != "x^y" && mathematical! != "÷" && mathematical! != "+"
            
            && mathematical! != "-" {
                justPerformedEnteredBinary = false
                brain.description = brain.description + " " + mathematical! + String(displayValue)
            
            }
            
            else {
            brain.description = brain.description + " " + String(displayValue) + " " + mathematical!
            justPerformedEnteredBinary = true
            
            }

            
            tailHistoryEntry = CalcBrain.UserHistory.currHis("", mathematical!, tailHistoryEntry)
            historyArray = []
        historyArray = brain.traverseHistory(tailHistoryEntry, historyArray: historyArray) }
        //if brain.checkOperation(mathematical!) == false && mathematical != "Mem" {
            //brain.description = brain.description + " ..."
            
        //}

        if userIsInMiddleOfTypingANum {
        brain.setOperand(displayValue)
            
            
            
            

        }
        // else if sender.currentTitle == "Pi" {
            //userIsInMiddleOfTyping = true
            //brain.performOperation(mathematical!)
            //displayValue = brain.result
            //return;
        
        //}
        
        userIsInMiddleOfTypingANum = false //he typed in a operation
        brain.usertyping = true
        if  mathematical != nil && mathematical != "Mem" { //fix the issues around constant operations.
           brain.performOperation(mathematical!)
            
        }
        dotIsSet = true

        //var count: Int = historyArray.count - 1
        if mathematical == "Mem"  {
            if justClickedMem {
            display!.text = String(brain.result)
            justClickedMem = false
            }
            //if brain.latestEquation != nil {
                ///display.text = brain.latestEquation
                
                
                //return;
            //}
            //else {return;}
            
            //var count: Int = historyArray.count - 1
           
            //display!.text = ""
            //while count >= 0 {
                //display!.text = historyArray[count] + " " + display!.text!
                //count = count - 1
            //}
            else {
            justClickedMem = true
                display!.text = brain.description}
        
        }
        else {
            self.displayValue = brain.result
            //if brain.checkOperation(mathematical!) {
            //tailHistoryEntry = CalcBrain.UserHistory.currHis(String(brain.result), "", tailHistoryEntry)
            //historyArray = []
            //historyArray = brain.traverseHistory(tailHistoryEntry, historyArray: historyArray)
           // let check = brain.historyArrayCheck(historyArray)
            //if check == false {
            //    historyArray = []
            //    tailHistoryEntry = CalcBrain.UserHistory.alCurrHis(String(brain.result), "", "")
                
                
             //   }
            
            
            
          //  }
        
        }
        brain.usertyping = false
        
        
    }
    
    
}

