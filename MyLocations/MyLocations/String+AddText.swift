//
//  String+AddText.swift
//  MyLocations
//
//  Created by Louis Parton on 2/19/23.
//

import Foundation

extension String {
  mutating func add(
    text: String?,
    separatedBy separator: String = ""
  ) {
    if let text = text {
      if !isEmpty {
        self += separator
      }
      self += text
    }
  }
}
