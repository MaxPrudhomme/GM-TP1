//
//  Q2.swift
//  GM-TP1
//
//  Created by Max PRUDHOMME on 20/10/2025.
//

import simd
import SwiftUI
import SceneKit

func Q2A() -> SCNNode {
    let cylinder: Cylinder = .init(faceCount: 10, height: 3, meridians: 2)
    
    return cylinder.makeCylinder()
}
