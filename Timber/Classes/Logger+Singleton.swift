//
//  Logger+Singleton.swift
//  Logger
//
//  Created by Max Kramer on 10/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

extension Logger {
    
    /**
     Sets the format of the global logger
     - Parameter format: The specific LogFormat to be used. Defaults to `LogFormat.defaultLogFormat`
     */
    
    public class func setFormat(_ format: LogFormat = LogFormat.defaultLogFormat) {
        shared.logFormat = format
    }
    
    /**
     Enables/disables the global logger.
     - Parameter enabled: `TRUE` to enable, `FALSE` to disable.
     */
    
    public class func setEnabled(_ enabled: Bool) {
        shared.enabled = enabled
    }
    
    /**
     Sets the minimum log level of the global logger
     - Parameter minLevel: The min log level to be used.
     */
    
    public class func setMinLevel(_ minLevel: LogLevel) {
        shared.minLevel = minLevel
    }
    
    /**
     Sets the terminator of a log line in the console. Typically "\n"
     - Parameter terminator: Typically "\n".
     */
    
    public class func setTerminator(_ terminator: String) {
        shared.terminator = terminator
    }
    
    /**
     Sets the separator of elements in the log message. Typically ", "
     - Parameter terminator: Typically "\n".
     */
    
    public class func setSeparator(_ separator: String) {
        shared.separator = separator
    }
    
    /**
     Registers the file of the caller to a specific minimum log level
     - Parameter level: the minimum log level to be associated with the file
     - Parameter filePath: **Should not be overwritten**. It's used to determine the filename of the caller
     */
    
    public class func registerFile(_ level: LogLevel, filePath: String = #file) {
        shared.registerFile(level, filePath: filePath)
    }
    
    /**
     Triggers a log with under the debug log level
     
     **Other than `message` these parameters should not be overwritten as they provide insight as to which file, line, column and function led to the call. If they are, then the LogFormat may not return the correct values thus the log message's format will not be expected.**
     - Parameter message: A series of objects to be logged.
     - Parameter filePath: Determines the file path of the caller.
     - Parameter line: Determines the line in the source code of the caller.
     - Parameter column: Determines the column in the source code of the caller.
     - Parameter function: Determines the function that triggered the call.
     */
    
    public class func debug(_ message: CVarArg..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        shared.log(.debug, message: message, filePath: filePath, line: line, column: column, function: function)
    }
    
    /**
     Triggers a log with under the trace log level
     
     **Other than `message` these parameters should not be overwritten as they provide insight as to which file, line, column and function led to the call. If they are, then the LogFormat may not return the correct values thus the log message's format will not be expected.**
     - Parameter message: A series of objects to be logged.
     - Parameter filePath: Determines the file path of the caller.
     - Parameter line: Determines the line in the source code of the caller.
     - Parameter column: Determines the column in the source code of the caller.
     - Parameter function: Determines the function that triggered the call.
     */
    
    public class func trace(_ message: CVarArg..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        shared.log(.trace, message: message, filePath: filePath, line: line, column: column, function: function)
    }
    
    /**
     Triggers a log with under the info log level
     
     **Other than `message` these parameters should not be overwritten as they provide insight as to which file, line, column and function led to the call. If they are, then the LogFormat may not return the correct values thus the log message's format will not be expected.**
     - Parameter message: A series of objects to be logged.
     - Parameter filePath: Determines the file path of the caller.
     - Parameter line: Determines the line in the source code of the caller.
     - Parameter column: Determines the column in the source code of the caller.
     - Parameter function: Determines the function that triggered the call.
     */
    
    public class func info(_ message: CVarArg..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        shared.log(.info, message: message, filePath: filePath, line: line, column: column, function: function)
    }
    
    /**
     Triggers a log with under the warn log level
     
     **Other than `message` these parameters should not be overwritten as they provide insight as to which file, line, column and function led to the call. If they are, then the LogFormat may not return the correct values thus the log message's format will not be expected.**
     - Parameter message: A series of objects to be logged.
     - Parameter filePath: Determines the file path of the caller.
     - Parameter line: Determines the line in the source code of the caller.
     - Parameter column: Determines the column in the source code of the caller.
     - Parameter function: Determines the function that triggered the call.
     */
    
    public class func warn(_ message: CVarArg..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        shared.log(.warn, message: message, filePath: filePath, line: line, column: column, function: function)
    }
    
    /**
     Triggers a log with under the error log level
     
     **Other than `message` these parameters should not be overwritten as they provide insight as to which file, line, column and function led to the call. If they are, then the LogFormat may not return the correct values thus the log message's format will not be expected.**
     - Parameter message: A series of objects to be logged.
     - Parameter filePath: Determines the file path of the caller.
     - Parameter line: Determines the line in the source code of the caller.
     - Parameter column: Determines the column in the source code of the caller.
     - Parameter function: Determines the function that triggered the call.
     */
    
    public class func error(_ message: CVarArg..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        shared.log(.error, message: message, filePath: filePath, line: line, column: column, function: function)
    }
    
    /**
     Triggers a log with under the fatal log level
     
     **Other than `message` these parameters should not be overwritten as they provide insight as to which file, line, column and function led to the call. If they are, then the LogFormat may not return the correct values thus the log message's format will not be expected.**
     - Parameter message: A series of objects to be logged.
     - Parameter filePath: Determines the file path of the caller.
     - Parameter line: Determines the line in the source code of the caller.
     - Parameter column: Determines the column in the source code of the caller.
     - Parameter function: Determines the function that triggered the call.
     */
    
    public class func fatal(_ message: CVarArg..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        shared.log(.fatal, message: message, filePath: filePath, line: line, column: column, function: function)
    }
}
