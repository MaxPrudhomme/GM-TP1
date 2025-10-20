//
//  Mesh.swift
//  GM-TP1
//
//  Created by Max PRUDHOMME on 20/10/2025.
//

import SceneKit
import SwiftUI
import simd

enum Mesh {
    static func makeNode(vertices: [SIMD3<Float>],
                         normals: [SIMD3<Float>]? = nil,
                         indices: [UInt16]) -> SCNNode {
        let vsrc = SCNGeometrySource(vertices: vertices.map { SCNVector3($0.x, $0.y, $0.z) })
        let nrm = normals ?? Array(repeating: [0, 0, 1], count: vertices.count)
        let nsrc = SCNGeometrySource(normals: nrm.map { SCNVector3($0.x, $0.y, $0.z) })

        let indicesData = indices.withUnsafeBufferPointer { buffer in
            Data(buffer: buffer)
        }

        let elem = SCNGeometryElement(
            data: indicesData,
            primitiveType: .triangles,
            primitiveCount: indices.count / 3,
            bytesPerIndex: MemoryLayout<UInt16>.size
        )
        // base white fill
        let base = SCNGeometry(sources: [vsrc, nsrc], elements: [elem])
        let fillMat = SCNMaterial()
        fillMat.lightingModel = .constant
        fillMat.diffuse.contents = Color.white
        fillMat.isDoubleSided = true
        base.materials = [fillMat]

        // black wire overlay
        let wire = base.copy() as! SCNGeometry
        let wireMat = SCNMaterial()
        wireMat.fillMode = .lines
        wireMat.diffuse.contents = Color.black
        wireMat.isDoubleSided = true
        wire.materials = [wireMat]

        let parent = SCNNode()
        parent.addChildNode(SCNNode(geometry: base))
        let wnode = SCNNode(geometry: wire)
        wnode.position.z += 0.0005 // anti-flicker offset
        parent.addChildNode(wnode)
        return parent
    }
}
