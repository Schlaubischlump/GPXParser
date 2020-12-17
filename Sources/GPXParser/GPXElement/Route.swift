//
//  Route.swift
//  GPXParser
//
//  Created by David Klopp on 16.12.20.
//

import Foundation

/// Struct to represent a complete track.
public final class Route: GPXElement, GPXGroup {
    override class var tag: String {
        return "rte"
    }

    /// List with all routepoints.
    public var routepoints: [RoutePoint] = []
}

/// Struct to represent a track point.
public final class RoutePoint: GPXElement, GPXPoint, GPXSegment {
    override class var tag: String {
        return "rtept"
    }
}
