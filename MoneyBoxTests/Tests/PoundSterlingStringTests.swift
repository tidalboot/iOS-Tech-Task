//
//  PoundSterlingStringTests.swift
//  MoneyBoxTests
//
//  Created by Nick Jones on 01/09/2023.
//

@testable import MoneyBox
import XCTest

final class PoundSterlingTests: XCTestCase {
    
    func testThatIntsAreCorrectlyFormatted() {
        XCTAssertEqual(1.toPoundSterlingString(), "£1")
        XCTAssertEqual(123.toPoundSterlingString(), "£123")
        XCTAssertEqual(9999.toPoundSterlingString(), "£9999")
        XCTAssertEqual(0.toPoundSterlingString(), "£0")
    }
    
    //If the server happens to send us nicely formatted amounts, great
    func testThatPreFormattedDoublesAreCorrectlyFormatted() {
        XCTAssertEqual(1.23.toPoundSterlingString(), "£1.23")
        XCTAssertEqual(12.31.toPoundSterlingString(), "£12.31")
        XCTAssertEqual(99.99.toPoundSterlingString(), "£99.99")
        XCTAssertEqual(0.01.toPoundSterlingString(), "£0.01")
    }
    
    //But if not we should still be able to handle them nicely
    func testThatDoublesWithTrailingDecimalsAreCorrectlyFormatted() {
        XCTAssertEqual(1.23001.toPoundSterlingString(), "£1.23")
        XCTAssertEqual(12.031.toPoundSterlingString(), "£12.03")
        XCTAssertEqual(99.900001.toPoundSterlingString(), "£99.90")
        XCTAssertEqual(0.010101.toPoundSterlingString(), "£0.01")
    }
}
