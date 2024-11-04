//
//  KDTree.swift
//  KNeighbors
//
//  Created by Mathew Kirby on 11/04/24.
//

import Foundation

class KDTreeNode<F: BinaryFloatingPoint> {
    var point: [F]
    var left: KDTreeNode?
    var right: KDTreeNode?
    
    init(point: [F], left: KDTreeNode? = nil, right: KDTreeNode? = nil) {
        self.point = point
        self.left = left
        self.right = right
    }
}

func constructKDTree<F: BinaryFloatingPoint>(points: [[F]], depth: Int = 0) -> KDTreeNode<F>? {
    if points.isEmpty {
        return nil
    }
    
    let k = points[0].count
    let axis = depth % k
    
    let sortedPoints = points.sorted { $0[axis] < $1[axis] }
    let medianIndex = sortedPoints.count / 2
    
    let node = KDTreeNode(
        point: sortedPoints[medianIndex],
        left: constructKDTree(points: Array(sortedPoints[0..<medianIndex]), depth: depth + 1),
        right: constructKDTree(points: Array(sortedPoints[medianIndex + 1..<sortedPoints.count]), depth: depth + 1)
    )
    
    return node
}

func nearestNeighborsSearch<F: BinaryFloatingPoint>(node: KDTreeNode<F>?, target: [F], n: Int, depth: Int = 0, neighbors: inout [(point: [F], distance: F)]) {
    guard let node = node else { return }
    
    let k = target.count
    let axis = depth % k
    
    // Calculate distance from target to the current node's point
    let dist = distance(node.point, target)
    
    // Maintain max-heap of closest points, storing at most `n` neighbors
    if neighbors.count < n {
        neighbors.append((node.point, dist))
        neighbors.sort { $0.distance > $1.distance }
    } else if dist < neighbors.first!.distance {
        neighbors[0] = (node.point, dist)
        neighbors.sort { $0.distance > $1.distance }
    }
    
    // Choose the next branch based on the target's position relative to the splitting plane
    let nextBranch = (target[axis] < node.point[axis]) ? node.left : node.right
    let oppositeBranch = (target[axis] < node.point[axis]) ? node.right : node.left
    
    // Recursive search in the next branch
    nearestNeighborsSearch(node: nextBranch, target: target, n: n, depth: depth + 1, neighbors: &neighbors)
    
    // Check if we need to search the opposite branch
    if abs(target[axis] - node.point[axis]) < neighbors.first!.distance || neighbors.count < n {
        nearestNeighborsSearch(node: oppositeBranch, target: target, n: n, depth: depth + 1, neighbors: &neighbors)
    }
}

func distance<F: BinaryFloatingPoint>(_ point1: [F], _ point2: [F]) -> F {
    return zip(point1, point2).map { ($0 - $1) * ($0 - $1) }.reduce(0, +).squareRoot()
}