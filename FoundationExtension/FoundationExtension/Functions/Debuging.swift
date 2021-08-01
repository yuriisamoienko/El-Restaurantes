//
//  Debugging.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 29.07.2021.
//

import Foundation

public func isDebuggerAttached() -> Bool {
    if debuggerAttached == false {
        var info = kinfo_proc()
        var mib : [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        assert(junk == 0, "sysctl failed")
        debuggerAttached = (info.kp_proc.p_flag & P_TRACED) != 0
    }
    return debuggerAttached
}

public func isDevEnvironment() -> Bool {
    var result = true
    #if !DEBUG
    if isDebuggerAttached() == false {
        result = false
    }
    #endif
    return result
}

fileprivate var debuggerAttached = false
