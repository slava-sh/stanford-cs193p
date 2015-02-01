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
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        
        set(optionalNewValue) {
            userIsInTheMiddleOfTypingANumber = false
            if let newValue = optionalNewValue {
                display.text = "= \(newValue)"
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
        println("digit = \(digit)")
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
            performOperation { -$0 }
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

    var operandStack = [Double]()

    @IBAction func enter() {
        if let value = displayValue {
            operandStack.append(value)
            println("operandStack = \(operandStack)")
        }
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        let operation = sender.currentTitle!
        switch operation {
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $0 - $1 }
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $0 / $1 }
        case "π": performOperation { M_PI }
        case "√": performOperation { sqrt($0) }  // TODO: handle the negative case
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            let arg2 = operandStack.removeLast()
            let arg1 = operandStack.removeLast()
            setResult(operation(arg1, arg2))
        }
    }
    
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            setResult(operation(operandStack.removeLast()))
        }
    }

    func performOperation(operation: () -> Double) {
        setResult(operation())
    }
    
    func setResult(result: Double) {
        operandStack.append(result)
        println("operandStack = \(operandStack)")
        displayValue = result
    }
    
    @IBAction func reset() {
        operandStack.removeAll()
        println("operandStack = \(operandStack)")
        displayValue = nil
    }
}