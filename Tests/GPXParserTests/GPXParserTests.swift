import XCTest
@testable import GPXParser

/// Amount of waypoints, routerpoints and trackpoints for each file.
let solutionDict = [
    "BrittanyJura/Campsites/filtered-brittany-jura-archies_fr.gpx": (788, 0, 0),
    "BrittanyJura/Dole_Langres.gpx": (2, 0, 5513),
    "Campsites/CampingMunicipal/ILE_DE_FRANCE.kml.gpx": (5, 0, 0),
    "BrittanyJura/SimplifiedGpx/Basel_St-Brevin_Eurovelo6_1.gpx": (0, 1459, 0),
    "BrittanyJura/SimplifiedGpx/Reims-VitryLeFrancois.gpx_0.gpx": (0, 344, 0),
    "Campsites/CampingMunicipal/PICARDIE.kml.gpx": (15, 0, 0),
    "BrittanyJura/SimplifiedGpx/Ouistreham_Caen.gpx_0.gpx": (0, 83, 0),
    "BrittanyJura/SimplifiedGpx/MoselradwegAusWiki_1.gpx": (0, 693, 0),
    "Campsites/CampingMunicipal/CHAMPAGNE-ARDENNES.kml.gpx": (27, 0, 0),
    "BrittanyJura/Ouistreham_Caen.gpx": (2, 0, 461),
    "BrittanyJura/SimplifiedGpx/Basel_St-Brevin_Eurovelo6_4.gpx": (0, 1750, 0),
    "RoscoffCoastal/Trebeurden_Lannion_parcours13.2RE.gpx": (0, 0, 271),
    "RoscoffCoastal/simplified/1_Roscoff_Morlaix_A_parcours.gpx": (0, 0, 1741),
    "Campsites/archies_fr.gpx": (9315, 0, 0),
    "Campsites/CampingMunicipal/FRANCHE_COMTE.kml.gpx": (34, 0, 0),
    "BrittanyJura/SimplifiedGpx/Newhaven_Brighton.gpx_0.gpx": (0, 113, 0),
    "Campsites/CampingMunicipal/MIDI_PYRENEES.kml.gpx": (146, 0, 0),
    "BrittanyJura/SimplifiedGpx/Basel_St-Brevin_Eurovelo6_5.gpx": (0, 1752, 0),
    "Campsites/CampingMunicipal/CORSE.kml.gpx": (4, 0, 0),
    "Campsites/CampingMunicipal/POITOU-CHARENTES.kml.gpx": (79, 0, 0),
    "BrittanyJura/Southampton_Portsmouth.gpx": (2, 0, 2182),
    "Campsites/CampingMunicipal/LORRAINE.kml.gpx": (17, 0, 0),
    "BrittanyJura/JuraRoute72011.gpx": (0, 0, 1414),
    "RoscoffCoastal/simplified/Trebeurden_Lannion_parcours13.2RE.gpx": (0, 0, 254),
    "BrittanyJura/Newhaven_Brighton.gpx": (2, 0, 820),
    "BrittanyJura/Reims-VitryLeFrancois.gpx": (0, 0, 524),
    "Campsites/CampingMunicipal/NORMANDIE.kml.gpx": (103, 0, 0),
    "Campsites/CampingMunicipal/AQUITAINE.kml.gpx": (79, 0, 0),
    "BrittanyJura/SimplifiedGpx/Southampton_Portsmouth.gpx_0.gpx": (0, 315, 0),
    "RoscoffCoastal/poi/archies_fr.filtered.gpx": (62, 0, 0),
    "BrittanyJura/Serqueaux_Dieppe.gpx": (2, 0, 1976),
    "Campsites/CampingMunicipal/ARDECHE_DROME.kml.gpx": (53, 0, 0),
    "BrittanyJura/SimplifiedGpx/Dole_Langres.gpx_0.gpx": (0, 730, 0),
    "BrittanyJura/SimplifiedGpx/Basel_St-Brevin_Eurovelo6.gpx_0.gpx": (0, 8049, 0),
    "RoscoffCoastal/Lannion_Plestin_parcours24.4RE.gpx": (0, 0, 381),
    "BrittanyJura/Dole_Salin-les-Bains.gpx": (2, 0, 2215),
    "BrittanyJura/SimplifiedGpx/MoselradwegAusWiki_3.gpx": (0, 914, 0),
    "Campsites/CampingMunicipal/BRETAGNE.kml.gpx": (189, 0, 0),
    "Campsites/CampingMunicipal/LANGUEDOC-ROUSSILLON.kml.gpx": (104, 0, 0),
    "BrittanyJura/SimplifiedGpx/Alt_Portsmouth.gpx_0.gpx": (0, 180, 0),
    "BrittanyJura/Alt_Portsmouth.gpx": (2, 0, 1219),
    "Campsites/CampingMunicipal/NORD-PAS_DE_CALAIS.kml.gpx": (38, 0, 0),
    "BrittanyJura/Campsites/filtered-brittany-jura-camping-municipal-france.gpx": (205, 0, 0),
    "RoscoffCoastal/parcours-morlaix-plougasnou.gpx": (0, 0, 1130),
    "RoscoffCoastal/Perros-Guirec_Trebeurden_parcours23.6RE.gpx": (0, 0, 566),
    "BrittanyJura/SimplifiedGpx/MoselradwegAusWiki.gpx_0.gpx": (0, 2416, 0),
    "BrittanyJura/SimplifiedGpx/Serqueaux_Dieppe.gpx_0.gpx": (0, 248, 0),
    "Campsites/CampingMunicipal/RHONE-ALPES.kml.gpx": (117, 0, 0),
    "RoscoffCoastal/1_Roscoff_Morlaix_A_parcours.gpx": (0, 0, 1741),
    "BrittanyJura/Basel_St-Brevin_Eurovelo6.gpx": (0, 0, 21240),
    "Campsites/CampingMunicipal/CENTRE.kml.gpx": (120, 0, 0),
    "BrittanyJura/SimplifiedGpx/JuraRoute72011.gpx_0.gpx": (0, 1249, 0),
    "Campsites/CampingMunicipal/AUVERGNE.kml.gpx": (126, 0, 0),
    "BrittanyJura/Salins-les-Bains_Fleurier.gpx": (2, 0, 3546),
    "RoscoffCoastal/simplified/Lannion_Plestin_parcours24.4RE.gpx": (0, 0, 358),
    "BrittanyJura/SimplifiedGpx/Courgenay_Ballon-DAlsace.gpx_0.gpx": (0, 734, 0),
    "BrittanyJura/MoselradwegAusWiki.gpx": (0, 0, 2954),
    "Campsites/CampingMunicipal/PACA.kml.gpx": (70, 0, 0),
    "Campsites/CampingMunicipal/camping-municipal-france.gpx": (1649, 0, 0),
    "RoscoffCoastal/simplified/parcours-morlaix-plougasnou.gpx": (0, 0, 1130),
    "Campsites/CampingMunicipal/PAYS-de-la-LOIRE.kml.gpx": (120, 0, 0),
    "BrittanyJura/SimplifiedGpx/Basel_St-Brevin_Eurovelo6_2.gpx": (0, 1706, 0),
    "Campsites/CampingMunicipal/ALSACE.kml.gpx": (32, 0, 0),
    "BrittanyJura/SimplifiedGpx/Dole_Salin-les-Bains.gpx_0.gpx": (0, 263, 0),
    "RoscoffCoastal/Plougasou-plestin-parcours.gpx": (0, 0, 934),
    "RoscoffCoastal/Roscoff_Perros-Guirec.gpx": (0, 0, 5023),
    "BrittanyJura/SimplifiedGpx/Basel_St-Brevin_Eurovelo6_3.gpx": (0, 1385, 0),
    "RoscoffCoastal/poi/brittany_municipal.filtered.gpx": (16, 0, 0),
    "BrittanyJura/SimplifiedGpx/MoselradwegAusWiki_2.gpx": (0, 810, 0),
    "BrittanyJura/Campsites/filtered-brittany-jura-archies_ch.gpx": (86, 0, 0),
    "Campsites/CampingMunicipal/LIMOUSIN.kml.gpx": (71, 0, 0),
    "BrittanyJura/Courgenay_Ballon-DAlsace.gpx": (2, 0, 4879),
    "Campsites/CampingMunicipal/BOURGOGNE.kml.gpx": (100, 0, 0),
    "BrittanyJura/SimplifiedGpx/Vitry-le-Francois_Langres.gpx_0.gpx": (0, 758, 0),
    "BrittanyJura/Vitry-le-Francois_Langres.gpx": (0, 0, 1688),
    "RoscoffCoastal/simplified/Plougasou-plestin-parcours.gpx": (0, 0, 934),
    "BrittanyJura/VoieVerteHauteVosges.gpx": (0, 0, 1298),
    "BrittanyJura/SimplifiedGpx/Salins-les-Bains_Fleurier.gpx_0.gpx": (0, 556, 0)
]

/// Get the url to the test directory
func resourceURLInTestFolder(_ pathComponent: String) -> URL {
    let currentFileURL = URL(fileURLWithPath: "\(#file)", isDirectory: false)
    return currentFileURL
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent(pathComponent)
}

final class GPXParserTests: XCTestCase {
    func testGPXParser() {
        let sampleURL = resourceURLInTestFolder("Samples")
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: sampleURL.path)!

        for element in enumerator {
            guard let path = element as? String else {
                fatalError("Can not conervert object to path")
            }

            let url = sampleURL.appendingPathComponent(path)
            if url.pathExtension != "gpx" {
                continue
            }

            do {
                let parser = try GPXParser(file: url)
                parser.parse { result in
                    switch result {
                    case .success():
                        let waypoints = parser.waypoints
                        let routepoints = parser.routes.flatMap { $0.routepoints }
                        let trackepoints = parser.tracks.flatMap { $0.segments.flatMap { $0.trackpoints }}

                        // Just to be sure warn on empty files.
                        if waypoints.isEmpty && routepoints.isEmpty && trackepoints.isEmpty {
                            print("File: " + path + "\nWarning: GPX file seems to be Empty")
                        }

                        // Check if the counts match.
                        let (wCounts, rCounts, tCounts) = solutionDict[path] ?? (-1, -1, -1)
                        XCTAssertEqual(waypoints.count, wCounts)
                        XCTAssertEqual(routepoints.count, rCounts)
                        XCTAssertEqual(trackepoints.count, tCounts)
                    case .failure(let error):
                        fatalError("File: " + path + "\nParse error: " + error.localizedDescription)
                    }
                }
            } catch (let error) {
                fatalError("File: " + path + "\nOpening error: " + error.localizedDescription)
            }
        }

    }

    static var allTests = [
        ("testGPXParser", testGPXParser),
    ]
}
