//
//  KNeighborsTests.swift
//  KNeighbors
//
//  Created by Mathew Kirby on 11/04/24.
//

@testable import KNeighbors
import XCTest

final class KDTreeTests: XCTestCase {
    func testConstructionBasic() throws {
        let points = [
            [2.1, 3.2],
            [5.4, 1.3],
            [9.6, 7.5],
            [4.8, 9.1],
            [8.0, 2.7]
        ]
        let kdTree = constructKDTree(points: points)

        let target = [5.0, 5.0]
        var neighbors: [(point: [Double], distance: Double)] = []

        nearestNeighborsSearch(node: kdTree, target: target, n: 2, neighbors: &neighbors)

        print("Nearest neighbors to \(target):")
        for (point, dist) in neighbors {
            print("Point: \(point) - Distance: \(dist)")
        }
    }
    
    func testConstruction4D() throws {
        let points4D = [[2.0, 3.0, 1.0, 4.0], [5.0, 4.0, 2.0, 3.0], [9.0, 6.0, 3.0, 2.0], [4.0, 7.0, 4.0, 1.0], [8.0, 1.0, 5.0, 5.0], [7.0, 2.0, 6.0, 6.0]]
        let kdTree4D = constructKDTree(points: points4D)
        let target4D = [9.0, 2.0, 3.0, 4.0]
        var neighbors: [(point: [Double], distance: Double)] = []
        nearestNeighborsSearch(node: kdTree4D, target: target4D, n: 5, neighbors: &neighbors)

        print("Nearest neighbors to \(target4D):")
        for (point, dist) in neighbors {
            print("Point: \(point) - Distance: \(dist)")
        }
    }
    
    func testCorrectness4D() throws {
        let points4D = [[2.0, 3.0, 1.0, 4.0], [5.0, 4.0, 2.0, 3.0], [9.0, 6.0, 3.0, 2.0], [4.0, 7.0, 4.0, 1.0], [8.0, 1.0, 5.0, 5.0], [7.0, 2.0, 6.0, 6.0]]
        let kdTree4D = constructKDTree(points: points4D)
        let target4D = [9.0, 2.0, 3.0, 4.0]
        var neighbors: [(point: [Double], distance: Double)] = []
        nearestNeighborsSearch(node: kdTree4D, target: target4D, n: 5, neighbors: &neighbors)

        let distancesFromPythonKDTree = [2.64575131, 4.12310563, 4.47213595, 4.69041576, 7.34846923]
        
        let computedDistances = neighbors.map { $0.distance }.sorted()
        
        // Check if the computed distances are close to the expected distances
        for (computed, expected) in zip(computedDistances, distancesFromPythonKDTree) {
            XCTAssertEqual(computed, expected, accuracy: 0.1, "Distance \(computed) is not close enough to expected \(expected)")
        }
    }
    
    func testKNeighborsRegressorBasic() throws {
        let features = [[2.0, 3.0, 1.0], [5.0, 4.0, 2.0], [9.0, 6.0, 3.0], [4.0, 7.0, 4.0], [8.0, 1.0, 5.0], [7.0, 2.0, 6.0]]
        let targets = [4.0, 3.0, 2.0, 1.0, 5.0, 6.0]
        let input = [9.0, 2.0, 3.0]
        let model = KNeighborsRegressor<Double>()
        model.fit(xRows: features, y: targets)
        let predictions = model.predict(xRows: [input])
        XCTAssert(predictions?.first! == 3.4)
    }
}

