//
//  SegmentedControlUtils.swift
//  MyCity
//
//  Created by Mitchelle Korir on 14/12/2021.
//

import Foundation
import UIKit

enum ViewedSegment: Int {
    case listview
    case mapView
}

extension UISegmentedControl {
    func setTitleColor(_ color: UIColor, state: UIControl.State = .normal) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.foregroundColor] = color
        self.setTitleTextAttributes(attributes, for: state)
    }

}
