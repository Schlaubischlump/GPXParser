//
//  GPXParser.swift
//  GPXParser
//
//  Created by David Klopp on 13.12.20.
//

import Foundation
import CoreLocation

public class GPXParser: NSObject, XMLParserDelegate {
    /// The GPX file to parse.
    public let file: URL

    /// True if the file is currently parsed.
    public private(set) var fileIsParsing: Bool = false

    /// True if the file is parsed.
    public private(set) var fileIsParsed: Bool = false

    /// List with all waypoints found inside the file.
    public private(set) var waypoints: [WayPoint] = []

    /// List with all tracks found inside the file.
    public private(set) var tracks: [Track] = []

    /// List with all routes found inside the file.
    public private(set) var routes: [Route] = []

    /// Internal XMLParser instance.
    private let parser: XMLParser

    // Stack which stores the currently parsed elements.
    private var stack: Stack<GPXElement>

    /// Partially found characters while parsing the file.
    private var foundCharacters: String = ""

    init(file: URL) throws {
        self.file = file

        // Make sure the file to parse exists.
        guard FileManager.default.fileExists(atPath: file.path) else {
            throw GPXError.FileNotFound(file.path)
        }

        // Create an XML parser.
        if let parser = XMLParser(contentsOf: file) {
            self.parser = parser
        } else {
            throw GPXError.CreateParser("Could not create XML parser.")
        }

        self.stack = Stack()

        // Init the class and assign the delegate.
        super.init()
        self.parser.delegate = self
    }

    /**
     Parse the specified GPX file.
     */
    func parse(_ completion: @escaping (Result<Void, Error>) -> Void)  {
        // Do not allow calling this function multiple times from different threads.
        // Do not allow calling this function more than once.
        guard !self.fileIsParsing, !self.fileIsParsed else { return }

        // We are currently parsing the file.
        self.fileIsParsing = true

        if self.parser.parse() {
            completion(.success(()))
        } else {
            let error = self.parser.parserError ?? GPXError.UnknowParseError("Could not parse file.")
            completion(.failure(error))
        }
    }

    // MARK: - XMLParserDelegate

    public func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {

        self.foundCharacters = ""

        switch elementName {
        case WayPoint.tag:
            guard let latStr = attributeDict["lat"], let longStr = attributeDict["lon"],
                  let lat = Double(latStr), let long = Double(longStr) else {
                break
            }
            let point = WayPoint(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
            self.stack.push(point)
        case Track.tag:
            // Create a new track.
            self.stack.push(Track())
        case TrackSegment.tag:
            // Create a new track segment.
            self.stack.push(TrackSegment())
        case TrackPoint.tag:
            // Create a new track point.
            guard let latStr = attributeDict["lat"], let longStr = attributeDict["lon"],
                  let lat = Double(latStr), let long = Double(longStr) else {
                break
            }
            let point = TrackPoint(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
            self.stack.push(point)
        case Route.tag:
            // Create a new route
            self.stack.push(Route())
        case RoutePoint.tag:
            // Create a new route point.
            guard let latStr = attributeDict["lat"], let longStr = attributeDict["lon"],
                  let lat = Double(latStr), let long = Double(longStr) else {
                break
            }
            let point = RoutePoint(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
            self.stack.push(point)
        default:
            break
        }
    }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string;
    }

    public func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {


        switch elementName {

        // Waypoint
        case WayPoint.tag:
            // Add a waypoint
            guard let waypoint = self.stack.pop() as? WayPoint else { break }
            self.waypoints.append(waypoint)

        // Route
        case Route.tag:
            // Add the complete route
            guard let route = self.stack.pop() as? Route else { break }
            self.routes.append(route)
        case RoutePoint.tag:
            // Add the trackpoint to the segment.
            guard let routepoint = self.stack.pop() as? RoutePoint else { break }
            let route = self.stack.peek() as? Route
            route?.routepoints.append(routepoint)

        // Track
        case Track.tag:
            // Add the complete track to the list and pop it from the stack.
            guard let track = self.stack.pop() as? Track else { break }
            self.tracks.append(track)
        case TrackSegment.tag:
            // Add the segment to the track.
            // Pop the segment from the stack.
            guard let segment = self.stack.pop() as? TrackSegment else { break }
            // Take a peek at the new top most element, the track.
            let group = self.stack.peek() as? Track
            group?.segments.append(segment)
        case TrackPoint.tag:
            // Add the trackpoint to the segment.
            guard let trackpoint = self.stack.pop() as? TrackPoint else { break }
            let segment = self.stack.peek() as? TrackSegment
            segment?.trackpoints.append(trackpoint)

        default:
            // TODO: We do currently not support nested datastructures. e.g extensions
            let element = self.stack.peek()
            element?.properties[elementName] = foundCharacters
        }

        self.foundCharacters = ""
    }

    public func parserDidEndDocument(_ parser: XMLParser) {
        self.fileIsParsed = true
        self.fileIsParsing = false
    }
}
