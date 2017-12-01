//
//  Logger.swift
//  Logger
//
//  Created by Max Kramer on 09/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

/// Logger; a small logging framework to help you debug your app and filter your logs

open class Logger {
    
    /// Determines whether or not the logger is enabled
    open var enabled: Bool = true
    
    /// Sets the minimum log level of the logger.
    open var minLevel: LogLevel
    
    /// Sets the terminator of a log line in the console.
    open var terminator: String = "\n"
    
    /// Sets the separator of elements in the log message.
    open var separator: String = ", "
    
    /// Sets how the log message should be formatted.
    /// See the class for more info.
    open var logFormat: LogFormat
    
    /// More useful for testing purposes; will perform the log to a pipe or console on the current thread
    open var useCurrentThread: Bool = false
    
    /// Sets the pipe used for output. Default (nil) refers to the console
    open var pipe: Pipe?
    
    /// Keeps track of the minimum log level for each file
    fileprivate var logLevels = [String: LogLevel]()
    
    /** The queue that the logs will take place on
     Log formatting could be an quite expensive feature and should not block the main thread
     Logging itself has no need to be done on the main thread either.
     The queue is serial as that's the way in which your logs should appear
     
     debug(a), debug(b), debug(c) should show as:
     
     a
     b
     c
     
     Which may certainly not be the case in a concurrent queue as the blocks are run asynchronously.
     */
    
    fileprivate let logQueue = DispatchQueue(label: "logger.queue", attributes: [])
    
    /// The shared instance of the Logger preventing the user from needing to create
    /// a new instance of `Logger` everytime that a message should be logged
    open static var shared = Logger()
    
    // MARK: Custom initialiser
    
    /**
     Creates an instance of the `Logger` class
     - Parameter minLevel: The minimum log level of the logger. See `Logger+LogLevels` for more info
     - Parameter logFormat: The format in which the log message should be generated
     */
    
    public init(minLevel: LogLevel = .debug, logFormat: LogFormat = LogFormat.defaultLogFormat) {
        self.minLevel = minLevel
        self.logFormat = logFormat
    }
    
    // MARK: Register a specific log level for a file
    
    /**
     Registers the file of the caller to a specific minimum log level
     - Parameter level: the minimum log level to be associated with the file
     - Parameter filePath: **Should not be overwritten**. It's used to determine the filename of the caller
     */
    
    open func registerFile(_ level: LogLevel, filePath: String = #file) {
        let fileName = filePath.lastPathComponent.stringByDeletingPathExtension
        logLevels[fileName] = level
    }
    
    // MARK: Log functions
    
    /**
     Logs a message with a specific log level
     - Parameter level: The minimum log level to be associated with the message
     - Parameter message: A series of objects to be logged
     - Parameter filePath: Determines the file path of the caller
     - Parameter line: Determines the line in the source code of the caller
     - Parameter column: Determines the column in the source code of the caller
     - Parameter function: Determines the function that triggered the call
     */
    
    open func log(_ level: LogLevel, message: [CVarArg], filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        guard enabled == true else {
            return
        }
        
        let logAllowed = level >= minLevel
        
        let fileName = filePath.lastPathComponent.stringByDeletingPathExtension
        let fileLevelLog = logLevels[fileName]
        
        guard (fileLevelLog != nil && level >= fileLevelLog!) || (fileLevelLog == nil && logAllowed == true) else {
            return
        }
        
        let formatBlock = {
            let logFormatter = LogFormatter(format: self.logFormat, logLevel: level, filePath: filePath, line: line, column: column, function: function, message: message.reduce("", { (combinator, obj) in
                if combinator.characters.count == 0 {
                    return String(describing: obj)
                }
                return combinator + self.separator + String(describing: obj)
            }), terminator: self.terminator)
            
            let logMessage = logFormatter.formattedLogMessage()
            
            if let pipe = self.pipe {
                self.logTo(pipe, message: logMessage)
            }
            else {
                // The separator and terminator are automatically set with the log formatter
                print(logMessage, separator: "", terminator: "")
            }
        }
        
        if useCurrentThread {
            formatBlock()
        }
        else {
            logQueue.async(execute: formatBlock)
        }
    }
    
    /**
     Logs the message to the supplied pipe
     - Parameter pipe: An NSPipe that the data will be written to
     - Parameter message: The formatted message to be logged
     */
    
    internal func logTo(_ pipe: Pipe, message: String) {
        let fh = pipe.fileHandleForWriting
        guard let data = message.data(using: String.Encoding.utf8) else {
            return
        }
        fh.write(data)
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
    
    open func debug(_ message: CVarArg..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.debug, message: message, filePath: filePath, line: line, column: column, function: function)
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
    
    open func trace(_ message: CVarArg..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.trace, message: message, filePath: filePath, line: line, column: column, function: function)
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
    
    open func info(_ message: CVarArg..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.info, message: message, filePath: filePath, line: line, column: column, function: function)
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
    
    open func warn(_ message: CVarArg..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.warn, message: message, filePath: filePath, line: line, column: column, function: function)
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
    
    open func error(_ message: CVarArg..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.error, message: message, filePath: filePath, line: line, column: column, function: function)
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
    
    open func fatal(_ message: CVarArg..., filePath: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.fatal, message: message, filePath: filePath, line: line, column: column, function: function)
    }
}
