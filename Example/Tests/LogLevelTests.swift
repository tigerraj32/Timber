//
//  LogLevelTests.swift
//  Demo
//
//  Created by Max Kramer on 10/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import XCTest
import Timber

class LogLevelTests: XCTestCase {
    func testEquality() {
        
        let all = Logger.LogLevel.all
        let off = Logger.LogLevel.off
        
        XCTAssertNotEqual(all, off)
        XCTAssertFalse(all == off)
        
        XCTAssertTrue(all == Logger.LogLevel.all)
        XCTAssertTrue(all == all)
        XCTAssertTrue(off == Logger.LogLevel.off)
        XCTAssertTrue(off == off)
        XCTAssertTrue(all != off)
    }
    
    func testLessThan() {
        let all = Logger.LogLevel.all
        let off = Logger.LogLevel.off
        
        XCTAssertTrue(all < off)
        XCTAssertFalse(off < all)
        XCTAssertTrue(all <= off)
    }
    
    func testMoreThan() {
        let all = Logger.LogLevel.all
        let off = Logger.LogLevel.off
        
        XCTAssertTrue(off > all)
        XCTAssertTrue(off >= all)
        XCTAssertFalse(all >= off)
    }
    
    func testStringConvertible() {
        let values = ["All", "Debug", "Trace", "Info", "Warn", "Error", "Fatal", "Off"]
        
        for i in 0..<values.count {
            XCTAssertEqual(Logger.LogLevel(rawValue: i)?.description, values[i])
        }
    }
    
    func testLogPriorities() {
        //        ALL < DEBUG < TRACE < INFO < WARN < ERROR < FATAL < OFF.
        XCTAssertTrue(
            Logger.LogLevel.all < Logger.LogLevel.debug &&
                Logger.LogLevel.debug < Logger.LogLevel.trace &&
                Logger.LogLevel.trace < Logger.LogLevel.info &&
                Logger.LogLevel.info < Logger.LogLevel.warn &&
                Logger.LogLevel.warn < Logger.LogLevel.error &&
                Logger.LogLevel.error < Logger.LogLevel.fatal &&
                Logger.LogLevel.fatal < Logger.LogLevel.off)
    }
    
}
