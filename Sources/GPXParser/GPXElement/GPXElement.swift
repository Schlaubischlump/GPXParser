//
//  GPXElement.swift
//  GPXParser
//
//  Created by David Klopp on 16.12.20.
//

import CoreLocation
import Foundation

// MARK: - Base class

/// Abstract base class that all kind of subgroups have in common.
public class GPXElement {
    /// The XML Tag used to identify this kind of element.
    class var tag: String {
        fatalError("Must be overriden by a subclass")
    }

    /// This gpx element properties.
    public var properties: [String: Any] = [:]
    /// The name property all elements share.
    public var name: String? {
        properties["name"] as? String
    }
}

// MARK: - Protocols

/// The outermost group of a gpx element. e.g a track
public protocol GPXGroup: GPXElement {
    // Reserved for lates usage
}

/// The segement e.g. track segement
public protocol GPXSegment: GPXElement {
    // Reserved for lates usage
}

/// Protocol for all kinds of GPX points.
public protocol GPXPoint: GPXElement {
    init()
    init(coordinate: CLLocationCoordinate2D, properties: [String: Any])
    var coordinate: CLLocationCoordinate2D { get }
}

/// Default implementation for GPXPoint requirements.
public extension GPXPoint {
    var coordinate: CLLocationCoordinate2D {
        properties["coordinate"] as! CLLocationCoordinate2D
    }

    init(coordinate: CLLocationCoordinate2D, properties: [String: Any] = [:]) {
        self.init()
        self.properties = properties
        self.properties["coordinate"] = coordinate
    }

    var description: String {
        let name = name ?? "nil"
        return "\(Self.self)(coordinate: \(coordinate), name: " + name + ")"
    }
}
