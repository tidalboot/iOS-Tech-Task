//
//  TokenExpirationTests.swift
//  MoneyBoxTests
//
//  Created by Nick Jones on 01/09/2023.
//

@testable import MoneyBox
import XCTest

final class TimeTests: XCTestCase {
    
    func testThatFivesMinutesHasPassed_WhenFiveMinutesHasPassed() {
        let oldDate = Date(timeInterval: -300, since: Date())
        XCTAssertTrue(Date().hasFiveMinutesPassedSinceDate(oldDate), "date checker incorrectly believes five minutes has not passed")
    }
    
    func testThatFivesMinutesHasNotPassed_WhenFiveMinutesHasNotPassed() {
        let oldDate = Date(timeInterval: -5, since: Date())
        XCTAssertFalse(Date().hasFiveMinutesPassedSinceDate(oldDate), "date checker incorrectly believes five minutes has passed")
    }
}
