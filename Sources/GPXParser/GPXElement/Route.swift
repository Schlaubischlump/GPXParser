//
//  Route.swift
//  GPXParser
//
//  Created by David Klopp on 16.12.20.
//

import Foundation

/// Struct to represent a complete track.
final class Route: GPXElement, GPXGroup {
    override class var tag: String {
        return "rte"
    }

    /// List with all routepoints.
    var routepoints: [RoutePoint] = []
}

/// Struct to represent a track point.
final class RoutePoint: GPXElement, GPXPoint, GPXSegment {
    override class var tag: String {
        return "rtept"
    }
}
