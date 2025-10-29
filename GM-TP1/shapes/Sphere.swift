//
//  Sphere.swift
//  GM-TP1
//
//  Created by Max PRUDHOMME on 20/10/2025.
//

import SceneKit
import SwiftUI
import simd

class Sphere {
    let center: SCNVector3
    let radius: Float
    let faceCount: Int
    let meridianCount: Int

    init(center: SCNVector3 = SCNVector3(0, 0, 0), radius: Float = 1.0, faceCount: Int = 12, meridianCount: Int = 6) {
        self.center = center
        self.radius = radius
        self.faceCount = max(faceCount, 3)
        self.meridianCount = max(meridianCount, 2)
    }

    func makeSphere() -> SCNNode {
        let parent = SCNNode()

        var vertices: [SIMD3<Float>] = []
        var indices: [UInt16] = []

        let c = SIMD3<Float>(
            Float(center.x),
            Float(center.y),
            Float(center.z)
        )

        for j in 0...meridianCount {
            let v = Float(j) / Float(meridianCount)
            let theta = v * Float.pi
            let y = c.y + radius * cos(theta)
            let r = radius * sin(theta)

            for i in 0...faceCount {
                // longitude (0 → 2π)
                let u = Float(i) / Float(faceCount)
                let phi = u * 2 * Float.pi
                let x = c.x + r * cos(phi)
                let z = c.z + r * sin(phi)
                vertices.append(SIMD3<Float>(x, y, z))
            }
        }

        let ringVertices = faceCount + 1
        for j in 0..<meridianCount {
            for i in 0..<faceCount {
                let i0 = UInt16(j * ringVertices + i)
                let i1 = UInt16(i0 + 1)
                let i2 = UInt16(i0 + UInt16(ringVertices))
                let i3 = UInt16(i2 + 1)

                indices.append(contentsOf: [i0, i2, i1])
                indices.append(contentsOf: [i1, i2, i3])
            }
        }

        let normals: [SIMD3<Float>] = vertices.map { normalize($0 - c) }

        let meshNode = Mesh.makeNode(
            vertices: vertices,
            normals: normals,
            indices: indices
        )

        parent.addChildNode(meshNode)
        return parent
    }
}
