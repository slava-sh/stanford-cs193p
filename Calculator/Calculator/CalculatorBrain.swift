//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Slava Shklyaev on 2/1/15.
//  Copyright (c) 2015 Viacheslav Shklyaev. All rights reserved.
//

import Foundation

class CalculatorBrain: Printable {
    
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOp(String, Double -> Double)
        case BinaryOp(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let x): return "\(x)"
                case .UnaryOp(let op, _): return op
                case .BinaryOp(let op, _): return op
                }
            }
        }
    }
    
    private var knownOps = [String: Op]()
    private var opStack = [Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOp("+", +))
        learnOp(Op.BinaryOp("−", -))
        learnOp(Op.BinaryOp("×", *))
        learnOp(Op.BinaryOp("÷", /))
        learnOp(Op.UnaryOp("√" ,sqrt))
        learnOp(Op.UnaryOp("sin", sin))
        learnOp(Op.UnaryOp("cos", cos))
    }
    
    var description: String {
        get {
            return "\(opStack)";
        }
    }
    
    func pushOperand(operand: Double) {
        opStack.append(Op.Operand(operand))
    }
    
    func pushOperation(operation: String) {
        opStack.append(knownOps[operation]!)
        println("opStack = \(opStack)")
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left")
        return result
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOp(_, let operation):
                let opEvaluation = evaluate(remainingOps)
                if let arg = opEvaluation.result {
                    return (operation(arg), opEvaluation.remainingOps)
                }
            case .BinaryOp(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let arg1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let arg2 = op2Evaluation.result {
                        return (operation(arg1, arg2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
}