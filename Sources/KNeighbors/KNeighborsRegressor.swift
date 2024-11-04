//
//  KNeighborsRegressor.swift
//  KNeighbors
//
//  Created by Mathew Kirby on 11/04/24.
//

import Foundation

class KNeighborsRegressor<F: BinaryFloatingPoint> {
    var tree: KDTreeNode<F>?
    var targetValues: [F] = []
    var k: Int
    
    init(k: Int = 5) {
        self.k = k
    }
    
    func fit(xRows: [[F]], y: [F]) {
        // Associate each point with its corresponding target value
        let points = zip(xRows, y).map { (features, target) -> [F] in
            features + [target]
        }
        
        // Construct kd-tree using the feature-target pairs
        tree = constructKDTree(points: points)
    }
    
    func predict(xRows: [[F]]) -> [F]? {
        var predictions: [F] = []
        
        for point in xRows {
            var neighbors: [(point: [F], distance: F)] = []
            
            // Find the k nearest neighbors for the given point
            nearestNeighborsSearch(node: tree, target: point, n: k, neighbors: &neighbors)
            
            // Extract the target values of the neighbors
            let neighborValues = neighbors.compactMap { neighbor in
                neighbor.point.last
            }
            
            guard !neighborValues.isEmpty else {
                return nil
            }
            
            // Calculate the average and append to predictions
            let average = F(neighborValues.reduce(0, +) / F(neighborValues.count))
            predictions.append(average)
        }
        
        return predictions
    }
    
    func fit(xColumns: [[F]], y: [F]) {
        let xRows = xColumns.transposed
        fit(xRows: xRows, y: y)
    }
    
    func predict(xColumns: [[F]]) -> [F]? {
        let xRows = xColumns.transposed
        return predict(xRows: xRows)
    }
}
