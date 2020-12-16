# GPXParser

[![License: GNU Affero General Public license version 3](https://img.shields.io/badge/License-AGPLv3-blue.svg)](https://opensource.org/licenses/agpl-3.0)

A simple GPX file parser written in Swift, which only depends on Foundation and CoreLocation. This parser is published under the GNU Affero General Public license. The main purpose of this parser is to extract way-points, route-points or track-points from a GPX file. All remaining metadata for these points is places inside a `properties` dictionary. No further parsing is performed for nested data structures.

```Swift
let url = URL(...)
let parser = try GPXParser(file: url)
parser.parse { result in
	switch result {
	case .success():
		// The way-points
		let waypoints = parser.waypoints
		// All route-points from all routes combined
		let routepoints = parser.routes.flatMap { route in 
			route.routepoints 
		}
		// All track-points from all track segments for each track combined
      		let trackepoints = parser.tracks.flatMap { track in 
      			track.segments.flatMap { segment
      				segment.trackpoints 
      			}
      		}
	case .failure(let error):
		print("Error parsing the gpx file!")
	}
} catch (let error) {
	print("Error opening the gpx file!")
}
```
