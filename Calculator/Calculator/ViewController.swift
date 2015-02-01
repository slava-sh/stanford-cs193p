//
//  ViewController.swift
//  Calculator
//
//  Created by Slava Shklyaev on 2/1/15.
//  Copyright (c) 2015 Viacheslav Shklyaev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stack: UILabel!
    @IBOutlet weak var input: UILabel!
    
    var brain = CalculatorBrain()
    var userIsInTheMiddleOfTypingANumber = false
    
    var inputValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(input.text!)?.doubleValue
        }
    }
    
    func startEditing() {
        userIsInTheMiddleOfTypingANumber = true
        input.text = "0"
    }

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if !userIsInTheMiddleOfTypingANumber {
            startEditing()
        }
        if input.text! == "0" && digit != "." {
            input.text = digit
        }
        else if digit != "." || input.text!.rangeOfString(".") == nil {
            input.text = input.text! + digit
        }
    }

    @IBAction func eraseLastDigit() {
        if !userIsInTheMiddleOfTypingANumber {
            startEditing()
        }
        input.text = countElements(input.text!) == 1 ? "0" : dropLast(input.text!)
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let value = inputValue {
            brain.pushOperand(value)
        }
        else {
            brain.pushOperand(input.text!)
        }
        renderBrain()
    }
    
    @IBAction func insertVariable(sender: UIButton) {
        input.text = sender.currentTitle!
        enter()
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        brain.pushOperation(sender.currentTitle!)
        renderBrain()
    }
    
    @IBAction func reset() {
        brain = CalculatorBrain()
        userIsInTheMiddleOfTypingANumber = false
        input.text = "0"
        renderBrain()
    }
    
    func renderBrain() {
        assert(!userIsInTheMiddleOfTypingANumber, "Rendering brain while typing")
        let result = brain.evaluate()
        stack.text = "\(brain)"
        if let value = result {
            input.text = "= \(value)"
        }
        else {
            input.text = "= nil"
        }
    }
}