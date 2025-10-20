//
//  Cylinder.swift
//  GM-TP1
//
//  Created by Max PRUDHOMME on 20/10/2025.
//

import SceneKit

class Cylinder {
    let radius: Float
    let faceCount: Int
    let height: Float
    let meridians: Int
    
    init(radius: Float = 1, faceCount: Int = 3, height: Float = 1, meridians: Int = 1) {
        self.radius = radius
        self.faceCount = max(faceCount, 3)
        self.height = height
        self.meridians = meridians
    }

    func makeDisc(center: SCNVector3) -> ([SIMD3<Float>], [UInt16]) {
        var vertices: [SIMD3<Float>] = [SIMD3<Float>(Float(center.x), Float(center.y), Float(center.z))]
        var indices: [UInt16] = []
        
        for i in 0..<faceCount {
            let angle = Float(i) / Float(faceCount) * 2 * .pi
            let x = Float(center.x) + radius * cos(angle)
            let z = Float(center.z) + radius * sin(angle)
            let y = center.y
            vertices.append(SIMD3<Float>(x, Float(y), z))
        }

        for i in 1...faceCount {
            let next = (i % faceCount) + 1
            indices.append(0)
            indices.append(UInt16(i))
            indices.append(UInt16(next))
        }

        return (vertices, indices)

    }
    
    func makeDiscs() -> [SCNNode] {
        let aCenter = SCNVector3(0, height / 2, 0)
        let bCenter = SCNVector3(0, -height / 2, 0)
        
        let (topVerts, topIndices) = makeDisc(center: aCenter)
        let (bottomVerts, bottomIndices) = makeDisc(center: bCenter)

        let topNode = Mesh.makeNode(vertices: topVerts, indices: topIndices)
        let bottomNode = Mesh.makeNode(vertices: bottomVerts, indices: bottomIndices)
        
        return [topNode, bottomNode]
    }
    
    func makeFaces() -> [SCNNode] {
        var faces: [SCNNode] = []
        
        for i in 0..<meridians {
            let y0 = -height / 2 + Float(i) * (height / Float(meridians))
            let y1 = -height / 2 + Float(i + 1) * (height / Float(meridians))
            
            for j in 0..<faceCount {
                let angle0 = Float(j) / Float(faceCount) * 2 * .pi
                let angle1 = Float(j+1) / Float(faceCount) * 2 * .pi
                
                let bl = SIMD3<Float>(radius * cos(angle0), y0, radius * sin(angle0))
                let br = SIMD3<Float>(radius * cos(angle1), y0, radius * sin(angle1))
                let tl = SIMD3<Float>(radius * cos(angle0), y1, radius * sin(angle0))
                let tr = SIMD3<Float>(radius * cos(angle1), y1, radius * sin(angle1))

                let vertices: [SIMD3<Float>] = [bl, tl, br, br, tl, tr]
                let indices: [UInt16] = [0, 1, 2, 3, 4, 5]

                let mesh = Mesh.makeNode(vertices: vertices, indices: indices)
                faces.append(mesh)
            }
        }
        
        return faces
    }
    
    func makeCylinder() -> SCNNode {
        let parent = SCNNode()
        
        let discs = makeDiscs()
        for disc in discs {
            parent.addChildNode(disc)
        }
        
        let faces = makeFaces()
        for face in faces {
            parent.addChildNode(face)
        }
        
        
        return parent
    }
}
