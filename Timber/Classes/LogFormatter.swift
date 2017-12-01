//
//  LogFormatter.swift
//  Logger
//
//  Created by Max Kramer on 09/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import Foundation

/// Generates a log message formatted in accordance with the specified LogFormat
open class LogFormatter {
    
    /// The log format to be used
    open let logFormat: LogFormat
    
    /// The current log level
    open let logLevel: Logger.LogLevel
    
    /// The filePath of the initial log caller
    open let filePath: String
    
    /// Determines the line in the source code of the caller.
    open let line: Int
    
    /// Determines the column in the source code of the caller.
    open let column: Int
    
    /// Determines the function that triggered the call.
    open let function: String
    
    /// The log message as a string
    open let message: String
    
    /// Sets the terminator of a log line in the console.
    open let terminator: String
    
    /// The date/time of that the log request was made at
    open let date: Date = Date()
    
    /// The internal date formatter for the Attribute.date
    fileprivate let dateFormatter = DateFormatter()
    
    /**
     Initialises an instance of LogFormatter
     - Parameter format: The log format to be used
     - Parameter logLevel: The log level of the log message
     - Parameter filePath: The filePath of the initial log caller
     - Parameter line: The line in the source code of the caller.
     - Parameter column: The column in the source code of the caller.
     - Parameter function: The function that triggered the call.
     - Parameter message: The log message as a string
     - Parameter separator: The separator for consecutive statements
     - Parameter terminator: The terminator for each log line
     */
    
    public init(format: LogFormat, logLevel: Logger.LogLevel, filePath: String, line: Int, column: Int, function: String, message: String, terminator: String) {
        self.logFormat = format
        self.logLevel = logLevel
        self.filePath = filePath
        self.line = line
        self.column = column
        self.function = function
        self.message = message
        self.terminator = terminator
    }
    
    /**
     Concatenates the specified attributes in the LogFormat and generates the final log message
     - Returns: The final log message that will appear in the console/log file
     */
    open func formattedLogMessage() -> String {
        guard let attributes = logFormat.attributes, attributes.count > 0 else {
            return message
        }
        
        let convertedAttributes = attributes.map { attribute -> CVarArg in
            switch attribute {
            case .level:
                return readableLogLevel(logLevel)
            case .fileName(let fullPath, let fileExtension):
                return readableFileName(filePath, showFullPath: fullPath, showFileExtension: fileExtension)
            case .line:
                return readableLine(line)
            case .column:
                return readableColumn(column)
            case .function:
                return readableFunction(function)
            case .message:
                return readableMessage(message)
            case .date(let format):
                return readableDate(date, format: format)
            }
        }
        return String(format: logFormat.template + terminator, arguments: convertedAttributes)
    }
    
    /**
     Generates the string equivalent of the Log Level that will be used in the log message
     - Parameter logLevel: The log level that's going to be logged
     - Returns: A readable equivalent of the supplied log level
     */
    
    open func readableLogLevel(_ logLevel: Logger.LogLevel) -> String {
        return logLevel.description.uppercased()
    }
    
    /**
     Generates the readable file path/name that will be used in the log message
     - Parameter filePath: The full file path
     - Parameter showFullPath: Whether or not the full path should be shown
     - Parameter showFileExtension: Whether or not the file extension should be shown
     - Returns: A formatted version of the file path
     */
    
    open func readableFileName(_ filePath: String, showFullPath: Bool, showFileExtension: Bool) -> String {
        var fileName = filePath
        if !showFullPath {
            fileName = fileName.lastPathComponent
        }
        if !showFileExtension {
            fileName = fileName.stringByDeletingPathExtension
        }
        return fileName
    }
    
    /**
     Generates the string equivalent of the line that will be used in the log message
     - Parameter line: The line that's going to be logged
     - Returns: A readable equivalent of the supplied line
     */
    
    open func readableLine(_ line: Int) -> String {
        return String(line)
    }
    
    /**
     Generates the string equivalent of the column that will be used in the log message
     - Parameter column: The column that's going to be logged
     - Returns: A readable equivalent of the supplied column
     */
    
    open func readableColumn(_ column: Int) -> String {
        return String(column)
    }
    
    /**
     Generates the string equivalent of the function that will be used in the log message
     - Parameter function: The function that's going to be logged
     - Returns: A readable equivalent of the supplied function
     */
    
    open func readableFunction(_ function: String) -> String {
        return function
    }
    
    /**
     Generates the string equivalent of the message that will be used in the log message
     - Parameter message: The message that's going to be logged
     - Returns: A formatted version of the supplied message
     */
    
    open func readableMessage(_ message: String) -> String {
        return message
    }
    
    /**
     Generates the formatted equivalent of the date that will be used in the log message
     - Parameter date: The date that's going to be logged
     - Returns: A readable & formatted equivalent of the supplied date
     */
    
    open func readableDate(_ date: Date, format: String) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
