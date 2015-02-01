//
//  ViewController.swift
//  Calculator
//
//  Created by Slava Shklyaev on 2/1/15.
//  Copyright (c) 2015 Viacheslav Shklyaev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var brain = CalculatorBrain()
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        
        set(optionalNewValue) {
            userIsInTheMiddleOfTypingANumber = false
            if let newValue = optionalNewValue {
                display.text = "\(newValue)"
//                display.text = "= \(newValue)"
            }
            else {
                display.text = "0"
            }
        }
    }

    func editSignAbsoluteValue(block: (String, String) -> String) {
        let (sign, text) = display.text!.hasPrefix("-") ? ("-", dropFirst(display.text!)) : ("", display.text!)
        display.text = block(sign, text)
    }
    
    func editAbsoluteValue(block: String -> String) {
        editSignAbsoluteValue({ sign, text in sign + block(text) })
    }
    
    func startEditing() {
        display.text = "0"
        userIsInTheMiddleOfTypingANumber = true
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if !userIsInTheMiddleOfTypingANumber {
            startEditing()
        }
        editAbsoluteValue { text in
            var newText: String
            if text == "0" && digit != "." {
                newText = digit
            }
            else if digit != "." || text.rangeOfString(".") == nil {
                newText = text + digit
            }
            else {
                newText = text
            }
            return newText
        }
    }
    
    @IBAction func changeSign() {
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text!.hasPrefix("-") ? dropFirst(display.text!) : "-" + display.text!;
        }
        else {
//            performOperation { -$0 }
        }
    }
    
    @IBAction func eraseLastDigit() {
        if userIsInTheMiddleOfTypingANumber {
            editAbsoluteValue { text in countElements(text) == 1 ? "0" : dropLast(text) }
        }
        else {
            startEditing()
        }
    }

    @IBAction func enter() {
        if let value = displayValue {
            brain.pushOperand(value)
            displayValue = brain.evaluate()
        }
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        let operation = sender.currentTitle!
        brain.pushOperation(operation)
        displayValue = brain.evaluate()
    }
    
    @IBAction func reset() {
        brain = CalculatorBrain()
        display.text = "0"
    }
}