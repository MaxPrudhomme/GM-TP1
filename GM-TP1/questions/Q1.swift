//
//  Q1.swift
//  GM-TP1
//
//  Created by Max PRUDHOMME on 20/10/2025.
//

import simd
import SwiftUI
import SceneKit

func Q1A() -> SCNNode {
    // Since 2D, just ignore the third dimension for now
    let vertices: [SIMD3<Float>] = [
        [0, 1, 0],
        [1, 1, 0],
        [0, 0, 0]
    ]
    
    let indices: [UInt16] = [0, 1, 2]
    return Mesh.makeNode(vertices: vertices, indices: indices)
}

func Q1B() -> SCNNode {
    let parent = SCNNode()
    
    let a = Mesh.makeNode(
        vertices: [
            [0, 1, 0],
            [1, 1, 0],
            [0, 0, 0]]
        , indices: [0, 1, 2])
    
    let b = Mesh.makeNode(
        vertices: [
            [1, 1, 0],
            [1, 0, 0],
            [0, 0, 0]]
        , indices: [0, 1, 2])
    
    parent.addChildNode(a)
    parent.addChildNode(b)
    
    return parent
}

func Q1C() -> SCNNode {
    let parent = SCNNode()
    
    let length: Int = 3
    let height: Int = 2
    
    for x in 0..<length {
        for y in 0..<height {
            let bl = SIMD3<Float>(Float(x),   Float(y),   0.0)
            let br = SIMD3<Float>(Float(x+1), Float(y),   0.0)
            let tl = SIMD3<Float>(Float(x),   Float(y+1), 0.0)
            let tr = SIMD3<Float>(Float(x+1), Float(y+1), 0.0)

            let vertices: [SIMD3<Float>] = [bl, tl, br, br, tl, tr]
            let indices: [UInt16] = [0, 1, 2, 3, 4, 5]

            let mesh = Mesh.makeNode(vertices: vertices, indices: indices)
            parent.addChildNode(mesh)
        }
    }
    
    return parent
}
