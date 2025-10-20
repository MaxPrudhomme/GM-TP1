//
//  GeometryPreview.swift
//  GM-TP1
//
//  Created by Max PRUDHOMME on 20/10/2025.
//


import SwiftUI
import SceneKit

struct GeometryPreview: View {
    var geometryBuilder: (() -> SCNGeometry?)? = nil

    var body: some View {
        SceneView(
            scene: makeScene(),
            options: [.allowsCameraControl, .autoenablesDefaultLighting]
        )
        .frame(width: 512, height: 512)
    }

    private func makeScene() -> SCNScene {
        let scene = SCNScene()

        // If we have geometry, attach it to a node
        if let geometry = geometryBuilder?() {
            let node = SCNNode(geometry: geometry)
            scene.rootNode.addChildNode(node)
        }

        // Minimal camera
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 4)
        scene.rootNode.addChildNode(cameraNode)

        return scene
    }
}
