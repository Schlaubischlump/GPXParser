//
//  GPXError.swift
//  GPXParser
//
//  Created by David Klopp on 13.12.20.
//

import Foundation

/// Error while parsing a GPX file.
public enum GPXError: Error {
    case FileNotFound(_ message: String)
    case CreateParser(_ message: String)
    case UnknowParseError(_ message: String)
}
