//
//  Array+Ext.swift
//  KNeighbors
//
//  Created by Mathew Kirby on 11/04/24.
//

import Foundation

extension Array where Element: Collection, Element.Index == Int, Element.Element: BinaryFloatingPoint {
    var transposed: [[Element.Element]] {
        guard let firstRow = self.first else { return [] }
        
        return (0..<firstRow.count).map { index in
            self.map { $0[index] }
        }
    }
}