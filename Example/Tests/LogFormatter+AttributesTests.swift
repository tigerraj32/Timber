//
//  LogFormatter+AttributesTests.swift
//  Demo
//
//  Created by Max Kramer on 23/06/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import XCTest
import Timber

class LogFormatter_AttributesTests: XCTestCase {
    func testEquatable() {
        XCTAssertEqual(LogFormatter.Attributes.level, LogFormatter.Attributes.level)
        XCTAssertEqual(LogFormatter.Attributes.fileName(fullPath: true, fileExtension: true), LogFormatter.Attributes.fileName(fullPath: true, fileExtension: true))
        XCTAssertEqual(LogFormatter.Attributes.date(format: "HH:mm:ss"), LogFormatter.Attributes.date(format: "HH:mm:ss"))
        
        XCTAssertNotEqual(LogFormatter.Attributes.level, LogFormatter.Attributes.message)
        XCTAssertNotEqual(LogFormatter.Attributes.fileName(fullPath: true, fileExtension: true), LogFormatter.Attributes.fileName(fullPath: false, fileExtension: true))
        XCTAssertNotEqual(LogFormatter.Attributes.date(format: "HH:mm:ss"), LogFormatter.Attributes.date(format: "hH:mm:ss"))
        XCTAssertNotEqual(LogFormatter.Attributes.fileName(fullPath: true, fileExtension: true), LogFormatter.Attributes.function)
    }
}
