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
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    var operandStack = [Double]()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        println("digit = \(digit)")
        if userIsInTheMiddleOfTypingANumber {
            if digit != "." || display.text!.rangeOfString(".") == nil {
                display.text = display.text! + digit
            }
        }
        else {
            display.text = digit == "." ? "0." : digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
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
            displayValue = operation(arg1, arg2)
            enter()
        }
    }
    
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }

    func performOperation(operation: () -> Double) {
        displayValue = operation()
        enter()
    }
}