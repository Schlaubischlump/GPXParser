//
//  WayPoint.swift
//  GPXParser
//
//  Created by David Klopp on 13.12.20.
//

import Foundation
import CoreLocation

/// Struct to represent a waypoint.
public final class WayPoint: GPXElement, GPXPoint, GPXSegment, GPXGroup {
    override class var tag: String {
        return "wpt"
    }

    override public init() {
        super.init()
    }
}
