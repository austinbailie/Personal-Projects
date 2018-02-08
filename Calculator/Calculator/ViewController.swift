//
//  ViewController.swift
//  Calculator
//
//  Created by Austin Bailie on 2016-04-14.
//  Copyright © 2016 Austin Bailie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //=========================================================================================================
    // MY VARIABLES (DOWN)
    //=========================================================================================================

    @IBOutlet var answerField: UILabel! //"Outlet" variable for answerfield, "outlet" makes it accesible by the GUI
    
    @IBOutlet var operatorField: UILabel!
    
    var decimalSet: Bool = true                 // Your common varaibles (down)
    
    var num: String = ""
    
    var num2: String = ""
    
    var percent: String = ""
    
    var negative: String = ""
    
    var answer: Float = 0
    
    //=========================================================================================================
    // PRE-SET CODE (DOWN)
    //=========================================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //=========================================================================================================
    // MY CODE (DOWN)
    //=========================================================================================================

    @IBAction func buttonTapped(theButton: UIButton) {
       
        if answerField.text == "0" {                        // "@IBAction" can be compared to "ButtonClicked" in C#
            answerField.text = theButton.titleLabel!.text   // This void assigns all number buttons to answerfield.
            
        } else {
            answerField.text = answerField.text! + theButton.titleLabel!.text!
            
        }
    }
    
    @IBAction func minusTapped(theButton: UIButton) {
        print("Minus Tapped")
        decimalSet = true
        
        if operatorField.text == "" {           // All operator functions check to see if there is still-
           operatorField.text = "-"             // another operator in use before applying its own operator.
           num = answerField.text!              // <- Assigns first number to be used in calculation.
           answerField.text = "0"
        } else {
           equalTapped(nil)                   // If another operator is in use, it will set answerfield back to zero-
           operatorField.text = "-"           // and change the operator.
        }
        
        if answerField.text != "0" {          // Allows for multiple calculations before pressing equals.
            num = answerField.text!
            answerField.text = "0"
        }

                
    }
    
    @IBAction func plusTapped(theButton: UIButton) {
        print("Plus Tapped")
        decimalSet = true                           // Same as minus function
        
        if operatorField.text == "" {
            operatorField.text = "+"
            num = answerField.text!
            answerField.text = "0"
        } else {
            equalTapped(nil)
            operatorField.text = "+"
        }
        
        if answerField.text != "0" {
            num = answerField.text!
            answerField.text = "0"
        }

       
    }
    
    @IBAction func multTapped(theButton: UIButton) {
        print("Multiply Tapped")
        decimalSet = true                           // Same as minus function
        
        if operatorField.text == "" {
            operatorField.text = "x"
            num = answerField.text!
            answerField.text = "0"
        } else {
            equalTapped(nil)
            operatorField.text = "x"
        }
        
        if answerField.text != "0" {
            num = answerField.text!
            answerField.text = "0"
        }
   
    }
    
    @IBAction func divTapped(theButton: UIButton) {
        print("Divide Tapped")
        decimalSet = true                           // Same as minus function
        
        if operatorField.text == "" {
            operatorField.text = "÷"
            num = answerField.text!
            answerField.text = "0"
        } else {
            equalTapped(nil)
            operatorField.text = "÷"
        }
        
        if answerField.text != "0" {
            num = answerField.text!
            answerField.text = "0"
        }

        
    }
    
    @IBAction func negTapped(_:AnyObject) {
        
        operatorField.text = "+/-"                  // Sets operator.
        
        negative = answerField.text!
        
        let firstNeg = Float(negative)              // Converts string to float.
        
        var finalNeg: Float = 0
        
        if firstNeg == nil {                        // If varaible returns "nil", error code stops a crash.
            showError()
            return
        }
        
        
        finalNeg = 0 - firstNeg!                    // Sets choosen number to negative.
        
        answerField.text = String(finalNeg)         // Converts answer back to string to be displayed in answerfield.
        
        if operatorField.text == "+/-" {            // Sets the now negative number as part of a calculation.
            num = String(finalNeg)
            operatorField.text = ""
            
        }
    }
    
    @IBAction func percentTapped(_:AnyObject) {
        
        operatorField.text = "%"                        // Same as negative function.
        
        percent = answerField.text!
      
        let firstPercent = Float(percent)
        
        var finalPercent: Float = 0
        
        if firstPercent == nil {
            showError()
            return
        }
        
        finalPercent = firstPercent! / 100
        
        answerField.text = String(finalPercent)
        
        if operatorField.text == "%" {
            num = String(finalPercent)
            operatorField.text = ""
            
        }
        
    }
    
    @IBAction func decimalTapped(theButton: UIButton) {
        
        if decimalSet == true {                         // Only allows one decimal to be present in the answerfield.
            
            answerField.text = answerField.text! + "."
        }
        
        decimalSet = false
        
    }
    
    @IBAction func clearTapped(_:AnyObject) {
        answerField.text = "0"                          // Sets all varaibles back to nil when cleared.
        operatorField.text = ""
        num = ""
        decimalSet = true
    }
        
    @IBAction func equalTapped(_:AnyObject?) {
        
        let firstNum = Float(num)                        // Converts from string to float.
        let secondNum = Float(answerField.text!)        //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        decimalSet = true
        
        if firstNum == nil {                            // If varaible returns "nil", run error sequence.
            showError()
            return
        }
        
        if secondNum == nil {
            showError()
            return
        }

        
        if operatorField.text == "-" {                  // When equal is tapped, this checks what operator is in use-
                                                        // and then does the corresponding calculation.
            answer = firstNum! - secondNum!
            
        }else if operatorField.text == "+" {
            
            answer = firstNum! + secondNum!
            
        }else if operatorField.text == "x" {
           
            answer = firstNum! * secondNum!
            
        }else if operatorField.text == "÷" {
            
            answer = firstNum! / secondNum!
        
        
        }else {
            showError()
            return
            
        }
        
        
       
        answerField.text = String(answer)                   // Converts answer back to string.
        operatorField.text = ""
        num = ""
        print("Equals: ", answer)                           // Prints in the debug area.
        
    }
    
    func showError() {                                     // Error sequence.
        print("NON-FATAL ERROR, RETURNED NIL")
        answerField.text = "0"
        
        
    }
    
    
}

