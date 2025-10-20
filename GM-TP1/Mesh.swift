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
    static func makeNode(
        vertices: [SIMD3<Float>],
        normals: [SIMD3<Float>]? = nil,
        indices: [UInt16]
    ) -> SCNNode {
        let vsrc = SCNGeometrySource(
            vertices: vertices.map { SCNVector3($0.x, $0.y, $0.z) }
        )
        let nrm = normals ?? Array(repeating: [0, 0, 1], count: vertices.count)
        let nsrc = SCNGeometrySource(
            normals: nrm.map { SCNVector3($0.x, $0.y, $0.z) }
        )

        let indicesData = indices.withUnsafeBufferPointer { buffer in
            Data(buffer: buffer)
        }

        let elem = SCNGeometryElement(
            data: indicesData,
            primitiveType: .triangles,
            primitiveCount: indices.count / 3,
            bytesPerIndex: MemoryLayout<UInt16>.size
        )

        // black wire
        let wire = SCNGeometry(sources: [vsrc, nsrc], elements: [elem])
        let wireMat = SCNMaterial()
        wireMat.fillMode = .lines
        wireMat.lightingModel = .constant
        #if os(macOS)
        wireMat.diffuse.contents = NSColor.black
        #else
        wireMat.diffuse.contents = UIColor.black
        #endif
        wireMat.isDoubleSided = true
        wire.materials = [wireMat]

        // white fill
        let base = wire.copy() as! SCNGeometry
        let fillMat = SCNMaterial()
        fillMat.lightingModel = .constant
        #if os(macOS)
        fillMat.diffuse.contents = NSColor.white
        #else
        fillMat.diffuse.contents = UIColor.white
        #endif
        fillMat.isDoubleSided = true
        base.materials = [fillMat]

        let parent = SCNNode()
        parent.addChildNode(SCNNode(geometry: wire))
        
        let fillNode = SCNNode(geometry: base)
        fillNode.scale = SCNVector3(0.997, 0.997, 0.997)
        parent.addChildNode(fillNode)
        
        return parent
    }
}
