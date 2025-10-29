//
//  Cone.swift
//  GM-TP1
//
//  Created by Max PRUDHOMME on 29/10/2025.
//

import SceneKit
import simd

class Cone {
    let radiusTop: Float
    let radiusBottom: Float
    let height: Float
    let faceCount: Int
    let meridians: Int

    init(radiusBottom: Float = 1.0, radiusTop: Float = 0.0, height: Float = 1.0, faceCount: Int = 12, meridians: Int = 1) {
        self.radiusBottom = max(radiusBottom, 0)
        self.radiusTop = max(radiusTop, 0)
        self.height = height
        self.faceCount = max(faceCount, 3)
        self.meridians = max(meridians, 1)
    }

    private func makeDisc(center: SCNVector3, radius: Float) -> SCNNode {
        guard radius > 0 else {
            let node = SCNNode()
            node.position = center
            return node
        }

        var vertices: [SIMD3<Float>] = [SIMD3<Float>(Float(center.x), Float(center.y), Float(center.z))]
        var indices: [UInt16] = []

        for i in 0..<faceCount {
            let angle = Float(i) / Float(faceCount) * 2 * .pi
            let x = Float(center.x) + radius * cos(angle)
            let z = Float(center.z) + radius * sin(angle)
            vertices.append(SIMD3<Float>(x, Float(center.y), z))
        }

        for i in 1...faceCount {
            let next = (i % faceCount) + 1
            indices.append(0)
            indices.append(UInt16(i))
            indices.append(UInt16(next))
        }

        return Mesh.makeNode(vertices: vertices, indices: indices)
    }

    private func makeFaces() -> [SCNNode] {
        var faces: [SCNNode] = []

        for i in 0..<meridians {
            let y0 = -height / 2 + Float(i) * (height / Float(meridians))
            let y1 = -height / 2 + Float(i + 1) * (height / Float(meridians))

            let t0 = Float(i) / Float(meridians)
            let t1 = Float(i + 1) / Float(meridians)
            let r0 = mix(radiusBottom, radiusTop, t0)
            let r1 = mix(radiusBottom, radiusTop, t1)

            for j in 0..<faceCount {
                let angle0 = Float(j) / Float(faceCount) * 2 * .pi
                let angle1 = Float(j + 1) / Float(faceCount) * 2 * .pi

                let bl = SIMD3<Float>(r0 * cos(angle0), y0, r0 * sin(angle0))
                let br = SIMD3<Float>(r0 * cos(angle1), y0, r0 * sin(angle1))

                let tl = SIMD3<Float>(r1 * cos(angle0), y1, r1 * sin(angle0))
                let tr = SIMD3<Float>(r1 * cos(angle1), y1, r1 * sin(angle1))

                let vertices: [SIMD3<Float>] = [bl, tl, br, br, tl, tr]
                let indices: [UInt16] = [0, 1, 2, 3, 4, 5]

                let mesh = Mesh.makeNode(vertices: vertices, indices: indices)
                faces.append(mesh)
            }
        }

        return faces
    }

    func makeCone() -> SCNNode {
        let parent = SCNNode()

        let topCenter = SCNVector3(0, height / 2, 0)
        let bottomCenter = SCNVector3(0, -height / 2, 0)

        let topDisc = makeDisc(center: topCenter, radius: radiusTop)
        let bottomDisc = makeDisc(center: bottomCenter, radius: radiusBottom)

        parent.addChildNode(bottomDisc)
        parent.addChildNode(topDisc)

        let faces = makeFaces()
        for f in faces {
            parent.addChildNode(f)
        }

        return parent
    }

    private func mix(_ a: Float, _ b: Float, _ t: Float) -> Float {
        return a * (1 - t) + b * t
    }
}
