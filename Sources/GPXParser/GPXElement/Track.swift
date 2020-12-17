//
//  Track.swift
//  GPXParser
//
//  Created by David Klopp on 16.12.20.
//

import Foundation

/// Struct to represent a complete track.
public final class Track: GPXElement, GPXGroup {
    override class var tag: String {
        return "trk"
    }

    /// List with all segments
    var segments: [TrackSegment] = []
}

/// Struct to represent a track segment.
public final class TrackSegment: GPXElement, GPXSegment {
    override class var tag: String {
        return "trkseg"
    }

    /// List with all trackpoints in this segment.
    var trackpoints: [TrackPoint] = []
}

/// Struct to represent a track point.
public final class TrackPoint: GPXElement, GPXPoint {
    override class var tag: String {
        return "trkpt"
    }
}
