//
//  MapViewUtils.swift
//  MyCity
//
//  Created by Mitchelle Korir on 14/12/2021.
//

import Foundation
import GoogleMaps

extension GMSMapView {
    func mapStyle(withFilename name: String, andType type: String) {
        do {
            if let styleURL = Bundle.main.url(forResource: name, withExtension: type) {
                self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
        } catch {
        }
    }}

class MapViewUtils {
    func delay(seconds: Double, completion:@escaping ()->()) {
        let when = DispatchTime.now() + seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            completion()
        }
    }
}
