//
//  CalcBrain.swift
//  Calculator
//
//  Created by Minh Huynh on 2016-07-15.
//  Copyright © 2016 Minh Huynh. All rights reserved.
//

import Foundation


class CalcBrain {
    
    private var accumulator: Double = 0.0
    private var internalProgram = [AnyObject]()
    func setOperand(operand: Double) {
    accumulator = operand
    internalProgram.append(operand)}
    var description: String = "0 +"
    var justExecutedOperation = false
    
    var operations: Dictionary<String, Operation> = [
        "Pi": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "±": Operation.UnaryOperation({-$0}),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "x*x": Operation.UnaryOperation({$0 * $0}),
        "log10": Operation.UnaryOperation(log10),
        "x^3": Operation.UnaryOperation({$0 * $0 * $0}),
        "✕": Operation.BinaryOperation({$0 * $1}),
        "x^y": Operation.BinaryOperation({pow($0, $1)}),
        "÷": Operation.BinaryOperation({$0 / $1}),
        "+": Operation.BinaryOperation({$0 + $1}),
        "-": Operation.BinaryOperation({$0 - $1}),
        "=": Operation.Equals,
        "Mem": Operation.RevealMemory
    ]
    
    private var equationStored: String? = nil
    private var lastOperationSymbol = ""
    enum Operation { //why do we put things in enum?
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case RevealMemory
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        
        //enums can have funcs but not vars and cant have inheritence
        
        
    }
    
    ///func equationStoredFactory(justExecutedOperation: Bool,  firstOperandStore: String, secondOperandStore: String, accumulator: Double, lastOperationSymbol: String) -> String? {
        //equationStored = nil
        //if justExecutedOperation {
            //if lastOperationSymbol == "Pi" {
                //equationStored = "" + "Pi"
            //}
            //else if lastOperationSymbol == "e" {
           //     equationStored = "" + "e"
           // }
           // else if lastOperationSymbol == "√" {
           //     equationStored = "" + "√" + secondOperandStore
            //}
            //else if lastOperationSymbol == "±" {
            //    equationStored = "" + secondOperandStore
            //}
            //else if lastOperationSymbol == "cos" {
            //    equationStored = "" + "cos(" + secondOperandStore + ")"
           // }
           // else if lastOperationSymbol == "sin" {
           //     equationStored = "" + "sin(" + secondOperandStore + ")"
           // }
           // else if lastOperationSymbol == "x*x" {
           //     equationStored = "" + secondOperandStore + "*" + secondOperandStore
           // }
           // else if lastOperationSymbol == "log10" {
            //    equationStored = "" + "log10(" + secondOperandStore + ")"
            //}
            //else if lastOperationSymbol == "x^3" {
            //    equationStored = "" + secondOperandStore + "^3"
            //}
            //else if lastOperationSymbol == "✕" {
            //    equationStored = "" + firstOperandStore + "x" + secondOperandStore
            //}
            //else if lastOperationSymbol == "x^y" {
            //    equationStored = "" + firstOperandStore + "^" + secondOperandStore
            //}
            //else if lastOperationSymbol == "÷" {
            //    equationStored = "" + firstOperandStore + "÷" + secondOperandStore
            //}
            //else if lastOperationSymbol == "+" {
            //    equationStored = "" + firstOperandStore + "+" + secondOperandStore
            //}
            //else if lastOperationSymbol == "-" {
            //    equationStored = "" + firstOperandStore + "-" + secondOperandStore
            //}
            
            //return equationStored

        
        //}
       // else {equationStored = nil; return nil;}
    
  //  }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value; justExecutedOperation = true; firstOperandStore = ""; secondOperandStore = String(accumulator); lastOperationSymbol = symbol;
            case .UnaryOperation(let function): secondOperandStore = String(accumulator); accumulator = function(accumulator); justExecutedOperation = true; firstOperandStore = "";  lastOperationSymbol = symbol;
            case .BinaryOperation(let function):
                if usertyping == true && pending != nil {
                executePendingBinaryOperation()
                }
                pending =
                PendingBinaryOperationInfo(binaryFunction: function,
                    firstOperand: accumulator); firstOperandStore = String(accumulator); lastOperationSymbol = symbol;
            case .Equals:
                executePendingBinaryOperation(); justExecutedOperation = true; 
            case .RevealMemory: break //equationStoredFactory(justExecutedOperation, firstOperandStore: firstOperandStore, secondOperandStore: secondOperandStore, accumulator: accumulator, lastOperationSymbol: lastOperationSymbol); justExecutedOperation = false;
                            }
        }
    }
    var usertyping: Bool = false
    func checkOperation(symbol: String) -> Bool {
        
        if let operation = operations[symbol] {
            switch operation {
                case .Constant(let value):
                return true
                case .UnaryOperation(let function):
                return true
                case .Equals:
                return true
                default: return false
                
            }}
        return false
    }
    
    func checkOperation1(symbol: String) -> Bool? {
        
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                return true
            case .UnaryOperation(let function):
                return true
            case .Equals:
                return true
            default: return false
                
            }}
        return nil
    }

    var firstOperandStore = ""
    var secondOperandStore = ""
    
    private func executePendingBinaryOperation() {
        secondOperandStore = String(accumulator)
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
            
        }

    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    
    }
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {return internalProgram}
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    
                    }
                    else if let operation = op as? String {
                        performOperation(operation)
                    
                    }
                }
            
            
            }
        
        }
    
    }
    func clear() {
    accumulator = 0.0
    pending = nil
        internalProgram.removeAll()
    }
    //history functions begin here
    indirect enum UserHistory {
        case currHis(String, String, UserHistory?)
        case alCurrHis(String, String, String)
    
    }
    
    func traverseHistory(history: UserHistory, var historyArray: [String]) -> [String] {

        switch history {
        case let .alCurrHis(Operand, Operator, null):
            if Operand != "" {
                historyArray.append(Operand)
            }
        case let .currHis(Operand, Operator, historyTail):
            if Operand != "" {
                historyArray.append(Operand)
            }
            else {
                historyArray.append(Operator)
            }
            historyArray = traverseHistory(historyTail!, historyArray: historyArray)
    
        }
        
        return historyArray
    
    }
    //false means clear mem. true means don't.  
    func historyArrayCheck(historyArray: [String]) -> Bool {
        var i = 0
        let length = historyArray.count
        var elementBefore: Double?
        var elementAfter: Double?
        while i != length-2 {
            elementBefore = Double(historyArray[i])
            elementAfter = Double(historyArray[i+1])
            print(elementBefore)
            print(elementAfter)
            if elementBefore != nil && elementAfter != nil {
                print("suppeople")
                return false
                
            
            }
            i = i + 1
        }
        return true
    }
    
    //////////
    
    var latestEquation: String? {
        get {
            return equationStored }
    
    }
    
    var result: Double {
        get {
            return accumulator
        }
        
    }


}
