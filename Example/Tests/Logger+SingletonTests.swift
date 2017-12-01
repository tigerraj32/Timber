//
//  Logger+SingletonTests.swift
//  Demo
//
//  Created by Max Kramer on 02/07/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import XCTest
import Timber

class Logger_SingletonTests: XCTestCase {

    func testSetFormat() {
        let format = LogFormat(template: "%@ %@", attributes: [LogFormatter.Attributes.level, LogFormatter.Attributes.level])
        Logger.setFormat(format)
        
        XCTAssertEqual(Logger.shared.logFormat, format)
    }
    
    func testSetEnabled() {
        Logger.setEnabled(true)
        XCTAssertEqual(Logger.shared.enabled, true)
        
        Logger.setEnabled(false)
        XCTAssertEqual(Logger.shared.enabled, false)
    }
    
    func testSetMinLevel() {
        Logger.setMinLevel(.all)
        XCTAssertEqual(Logger.shared.minLevel, Logger.LogLevel.all)
        
        Logger.setMinLevel(.warn)
        XCTAssertEqual(Logger.shared.minLevel, Logger.LogLevel.warn)
    }
    
    func testSetTerminator() {
        let terminator = "\n"
        Logger.setTerminator(terminator)
        
        XCTAssertEqual(Logger.shared.terminator, terminator)
    }
    
    func testSetSeparator() {
        let separator = "\n"
        Logger.setSeparator(separator)
        
        XCTAssertEqual(Logger.shared.separator, separator)
    }
    
    func performTestWithExpectedLogLevel(_ expectedLogLevel: Logger.LogLevel) {
        let expectation = self.expectation(description: UUID().uuidString + ": \(expectedLogLevel)")
        
        let logMessage = UUID().uuidString
        
        let localLogger = StubbedLogger(loggedBlock: { level, message, _, _, _, _ in
            XCTAssertEqual(level, expectedLogLevel)
            XCTAssertEqual(message.first as? String, logMessage)
            expectation.fulfill()
        })
        
        Logger.shared = localLogger
        
        switch expectedLogLevel {
        case .debug:
            Logger.debug(logMessage)
            break
        case .error:
            Logger.error(logMessage)
            break
        case .fatal:
            Logger.fatal(logMessage)
            break
        case .info:
            Logger.info(logMessage)
            break
        case .trace:
            Logger.trace(logMessage)
            break
        case .warn:
            Logger.warn(logMessage)
            break
        default:
            expectation.fulfill()
            break
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testAllLogLevel() {
        performTestWithExpectedLogLevel(.all)
    }
    
    func testDebugLogLevel() {
        performTestWithExpectedLogLevel(.debug)
    }
    
    func testTraceLogLevel() {
        performTestWithExpectedLogLevel(.trace)
    }
    
    func testInfoLogLevel() {
        performTestWithExpectedLogLevel(.info)
    }
    
    func testWarnLogLevel() {
        performTestWithExpectedLogLevel(.warn)
    }
    
    func testErrorLogLevel() {
        performTestWithExpectedLogLevel(.error)
    }
    
    func testFatalLogLevel() {
        performTestWithExpectedLogLevel(.fatal)
    }
}
