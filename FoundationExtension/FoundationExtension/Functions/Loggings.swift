//
//  Loggings.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 29.07.2021.
//

import Foundation

//usage: fatalErrorEx(_ message: String)
//it show more precise error on IDE when crash with fatalError
public func fatalErrorEx(_ message: String, file: String = #file, line: UInt = #line, function: String = #function) -> Never {
    let fullMessage = funcLog(error: nil, file: file, line: line, function: function) + message
    return fatalError(fullMessage, file: "", line: line)
}

//usage: fatalMistake(_ message: String)
//usage: fatalMistake(_ message text: String, _ condition: Bool)
public func fatalMistake(_ message: String, condition: Bool = true, file: String = #file, line: UInt = #line, function: String = #function) {
    if condition == false {
        return
    }
    printFuncLog(message, isError: true, file: file, line: line, function: function)
    if enableFatalMistake == false {
        return
    }
    fatalErrorEx(message, file: file, line: line, function: function)
}

public func fatalMistake(_ error: Error, condition: Bool = false, file: String = #file, line: UInt = #line, function: String = #function) {
    fatalMistake(error.localizedDescription, file: file, line: line, function: function)
}

//call it 'funcLog(error)'
public func funcLog(error: Error?, file: String = #file, line: UInt = #line, function: String = #function) -> String {
    var fileName = file
    if let value = file.split(separator: "/").last {
        fileName = String(value)
    }
    return "\(fileName):\(line) : \(function) : error: " + (error?.localizedDescription ?? "")
}

public func printFuncLog(error: Error?, file: String = #file, line: UInt = #line, function: String = #function) {
    let value = funcLog(error: error, file: file, line: line, function: function)
    printIt(value, isError: true)
}

//call it 'funcLog()'; use directly in function, not in closure - otherwise you'll get the closure info; use with 'showProgrammErrorAlert'
public func funcLog(file: String = #file, line: UInt = #line, function: String = #function) -> String {
    let result = "\(file):\(line) : \(function) : "
    return result
}

//call it 'printFuncLog()' or 'printFuncLog("some_value")'
public func printFuncLog(_ withString: String = "", file: String = #file, line: UInt = #line, function: String = #function) {
    printFuncLog(withString, isError: false, file: file, line: line, function: function)
}

fileprivate func printFuncLog(_ withString: String = "", isError: Bool, file: String = #file, line: UInt = #line, function: String = #function) {
    let value = funcLog(file: file, line: line, function: function)
    printIt(value + " " + withString, isError: isError)
}

fileprivate func printIt(_ value: String, isError: Bool) {
    if isDevEnvironment() == true {
        print(value)
    }
}

fileprivate let enableFatalMistake: Bool = isDebuggerAttached()
