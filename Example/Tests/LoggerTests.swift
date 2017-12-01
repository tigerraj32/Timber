//
//  LoggerTests.swift
//  Demo
//
//  Created by Max Kramer on 23/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import XCTest
import Timber

class StubbedLogger: Logger {
    
    typealias LoggedBlock = (_ level: Logger.LogLevel, _ message: [CVarArg], _ filePath: String, _ line: Int, _ column: Int, _ function: String) -> ()
    
    let loggedBlock: LoggedBlock
    init(loggedBlock: @escaping LoggedBlock) {
        self.loggedBlock = loggedBlock
    }
    
    override func log(_ level: Logger.LogLevel, message: [CVarArg], filePath: String, line: Int, column: Int, function: String) {
        loggedBlock(level, message, filePath, line, column, function)
    }
}

class LoggerTests: XCTestCase {
    
    /*
     These tests make the assumption that the logger will indeed trigger print statements if a pipe is not used
     */
    
    func testInitialisers() {
        let logFormat = LogFormat.defaultLogFormat
        let logger1 = Logger(minLevel: .all, logFormat: logFormat)
        
        XCTAssertEqual(logger1.minLevel, Logger.LogLevel.all)
        XCTAssertEqual(logger1.logFormat, logFormat)
        
        let logger2 = Logger(minLevel: .debug)
        XCTAssertEqual(logger2.minLevel, Logger.LogLevel.debug)
    }
    
    func fulfillAfter(_ expectation: XCTestExpectation, time: Double = 4) {
        let delayTime = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            expectation.fulfill()
        }
    }
    
    func testDisabledLoggerDoesntLog() {
        let logger = Logger()
        let pipe = Pipe()

        logger.pipe = pipe
        logger.enabled = false
        logger.useCurrentThread = true

        let writtenData = "written data".data(using: String.Encoding.utf8)!
        logger.pipe!.fileHandleForWriting.write(writtenData)

        logger.debug("Test message")

        XCTAssertEqual(logger.pipe!.fileHandleForReading.availableData.count, writtenData.count)
    }
    
    func testSettingFileLogLevelDoesntReceiveLog() {
        let logger = Logger()
        let pipe = Pipe()
        
        logger.pipe = pipe
        logger.useCurrentThread = true
        
        logger.registerFile(.fatal)
        
        let writtenData = "written data".data(using: String.Encoding.utf8)!
        logger.pipe!.fileHandleForWriting.write(writtenData)
        
        logger.error("This should not be logged")
        
        XCTAssertEqual(logger.pipe!.fileHandleForReading.availableData.count, writtenData.count)
    }
    
    func testSettingFileLogLevelReceivesLog() {
        let pipe = Pipe()
        let localLogger = Logger()
        
        localLogger.pipe = pipe
        pipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        expectation(forNotification: NSNotification.Name.NSFileHandleDataAvailable, object: pipe.fileHandleForReading) { notification -> Bool in
            guard let fh = notification.object as? FileHandle else {
                return false
            }
            
            let data = fh.availableData
            XCTAssertTrue(data.count > 0)
            XCTAssertTrue(String(data: data, encoding: String.Encoding.utf8)!.contains("This should be logged"))
            
            return true
        }
        
        localLogger.registerFile(.error)
        
        // Log some data
        localLogger.error("This should be logged")
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5) { _ in }
    }
    
    func performTestWithExpectedLogLevel(_ expectedLogLevel: Logger.LogLevel) {
        let expectation = self.expectation(description: UUID().uuidString + ": \(expectedLogLevel)")
        
        let logMessage = UUID().uuidString
        
        let localLogger = StubbedLogger(loggedBlock: { level, message, _, _, _, _ in
            XCTAssertEqual(level, expectedLogLevel)
            XCTAssertEqual(message.first as? String, logMessage)
            expectation.fulfill()
        })
        
        switch expectedLogLevel {
        case .debug:
            localLogger.debug(logMessage)
            break
        case .error:
            localLogger.error(logMessage)
            break
        case .fatal:
            localLogger.fatal(logMessage)
            break
        case .info:
            localLogger.info(logMessage)
            break
        case .trace:
            localLogger.trace(logMessage)
            break
        case .warn:
            localLogger.warn(logMessage)
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
