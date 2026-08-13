//
//  GPXParser.swift
//  GPXParser
//
//  Created by David Klopp on 13.12.20.
//

import CoreLocation
import Foundation

public class GPXParser: NSObject, XMLParserDelegate, @unchecked Sendable {
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

    /// Stack which stores the currently parsed elements.
    private var stack: Stack<GPXElement>

    /// Partially found characters while parsing the file.
    private var foundCharacters: String = ""

    /// The first XML element, used to reject well-formed non-GPX documents.
    private var documentElementName: String?

    public init(file: URL) throws {
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

        stack = Stack()

        // Init the class and assign the delegate.
        super.init()
        parser.delegate = self
    }

    /**
     Parse the specified GPX file.
     */
    public func parse(_ completion: @escaping (Result<Void, Error>) -> Void) {
        // Do not allow calling this function multiple times from different threads.
        // Do not allow calling this function more than once.
        guard !fileIsParsing, !fileIsParsed else { return }

        // We are currently parsing the file.
        fileIsParsing = true

        if parser.parse(), documentElementName == "gpx" {
            completion(.success(()))
        } else {
            let error = parser.parserError
                ?? GPXError.InvalidDocument("The document root must be a GPX element.")
            completion(.failure(error))
        }
    }

    /// Parse the document without exposing the parser's callback API to clients.
    ///
    /// XMLParser performs the parse synchronously. This overload presents that work
    /// as an async operation so applications can compose it with document pickers,
    /// route selection, and device RPC using structured concurrency.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func parse() async throws {
        try await withCheckedThrowingContinuation { continuation in
            parse { result in
                continuation.resume(with: result)
            }
        }
    }

    // MARK: - XMLParserDelegate

    public func parser(_: XMLParser,
                       didStartElement elementName: String,
                       namespaceURI _: String?,
                       qualifiedName _: String?,
                       attributes attributeDict: [String: String] = [:])
    {
        foundCharacters = ""

        if documentElementName == nil {
            documentElementName = elementName
        }

        switch elementName {
        case WayPoint.tag:
            guard let latStr = attributeDict["lat"], let longStr = attributeDict["lon"],
                  let lat = Double(latStr), let long = Double(longStr),
                  CLLocationCoordinate2DIsValid(.init(latitude: lat, longitude: long))
            else {
                break
            }
            let point = WayPoint(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
            stack.push(point)
        case Track.tag:
            // Create a new track.
            stack.push(Track())
        case TrackSegment.tag:
            // Create a new track segment.
            stack.push(TrackSegment())
        case TrackPoint.tag:
            // Create a new track point.
            guard let latStr = attributeDict["lat"], let longStr = attributeDict["lon"],
                  let lat = Double(latStr), let long = Double(longStr),
                  CLLocationCoordinate2DIsValid(.init(latitude: lat, longitude: long))
            else {
                break
            }
            let point = TrackPoint(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
            stack.push(point)
        case Route.tag:
            // Create a new route
            stack.push(Route())
        case RoutePoint.tag:
            // Create a new route point.
            guard let latStr = attributeDict["lat"], let longStr = attributeDict["lon"],
                  let lat = Double(latStr), let long = Double(longStr),
                  CLLocationCoordinate2DIsValid(.init(latitude: lat, longitude: long))
            else {
                break
            }
            let point = RoutePoint(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
            stack.push(point)
        default:
            break
        }
    }

    public func parser(_: XMLParser, foundCharacters string: String) {
        foundCharacters += string
    }

    public func parser(_: XMLParser,
                       didEndElement elementName: String,
                       namespaceURI _: String?,
                       qualifiedName _: String?)
    {
        switch elementName {
        // Waypoint
        case WayPoint.tag:
            // Add a waypoint
            guard let waypoint = stack.pop() as? WayPoint else { break }
            waypoints.append(waypoint)

        // Route
        case Route.tag:
            // Add the complete route
            guard let route = stack.pop() as? Route else { break }
            routes.append(route)

        case RoutePoint.tag:
            // Add the trackpoint to the segment.
            guard let routepoint = stack.pop() as? RoutePoint else { break }
            let route = stack.peek() as? Route
            route?.routepoints.append(routepoint)

        // Track
        case Track.tag:
            // Add the complete track to the list and pop it from the stack.
            guard let track = stack.pop() as? Track else { break }
            tracks.append(track)

        case TrackSegment.tag:
            // Add the segment to the track.
            // Pop the segment from the stack.
            guard let segment = stack.pop() as? TrackSegment else { break }
            // Take a peek at the new top most element, the track.
            let group = stack.peek() as? Track
            group?.segments.append(segment)

        case TrackPoint.tag:
            // Add the trackpoint to the segment.
            guard let trackpoint = stack.pop() as? TrackPoint else { break }
            let segment = stack.peek() as? TrackSegment
            segment?.trackpoints.append(trackpoint)

        default:
            // TODO: We do currently not support nested datastructures. e.g extensions
            let element = stack.peek()
            element?.properties[elementName] = foundCharacters
        }

        foundCharacters = ""
    }

    public func parserDidEndDocument(_: XMLParser) {
        fileIsParsed = true
        fileIsParsing = false
    }
}
