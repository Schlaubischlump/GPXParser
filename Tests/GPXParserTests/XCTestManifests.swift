//
//  XCTestManifests.swift
//  GPXParser
//
//  Created by David Klopp on 13.08.2026.
//

import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(GPXParserTests.allTests),
        ]
    }
#endif
