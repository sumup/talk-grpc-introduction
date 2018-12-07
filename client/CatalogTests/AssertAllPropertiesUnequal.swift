//
//  AssertAllPropertiesUnequal.swift
//  sumuppayTests
//
//  Created by Hagi on 04.01.18.
//  Copyright © 2018 SumUp Payments Ltd. All rights reserved.
//

import XCTest

/**
 *   Iterates over all properties of the objects' class
 *   and verifies that all properties' values are unequal
 *   between the two instances.
 *
 *   Also verifies that both objects are indeed of the same
 *   type.
 *
 *   Properties are compared using isEqual: if their type
 *   inherits from NSObject, else their debugDescription
 *   is compared. `assertAllPropertiesUnequal(…)` is not
 *   called recursively.
 *
 *   Only properties introduced by the most specific class
 *   are checked, not properties defined by the superclass.
 *
 */
func assertAllPropertiesUnequal<T: NSObject>(lhs: T, rhs: T) {
    XCTAssertFalse(lhs === rhs, "Instances are identical")
    XCTAssertNotEqual(lhs, rhs, "Instances are equal")

    guard let lhsClass = object_getClass(lhs), let rhsClass = object_getClass(rhs) else {
        XCTFail("Cannot retrieve class information")
        return
    }

    // generics allow different subclasses of a common superclass
    XCTAssertTrue(lhsClass == rhsClass, "Instances have different runtime types")

    let lhsProperties = ISHPropertiesForClass(lhsClass)
    let rhsProperties = ISHPropertiesForClass(rhsClass)

    XCTAssertEqual(lhsProperties, rhsProperties, "Available properties of instances differ")

    lhsProperties.forEach { keyValuePair in
        guard let key = keyValuePair.key as? String else {
            XCTFail("Property key is not a string: \(keyValuePair.key)")
            return
        }

        let lhsValue = lhs.value(forKey: key)
        let rhsValue = rhs.value(forKey: key)

        if let lhsObject = lhsValue as? NSObject, let rhsObject = rhsValue as? NSObject {
            XCTAssertNotEqual(lhsObject, rhsObject, "Value of '\(key)' is equal in both instances of \(lhsClass).")
        } else {
            // there is no easy way to compare two Any's in Swift so we use the debugDescription
            XCTAssertNotEqual(lhsValue.debugDescription, rhsValue.debugDescription, "Value of '\(key)' is equal in both instances of \(lhsClass).")
        }
    }
}
