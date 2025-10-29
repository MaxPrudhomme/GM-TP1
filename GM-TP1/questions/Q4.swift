//
//  Q4.swift
//  GM-TP1
//
//  Created by Max PRUDHOMME on 29/10/2025.
//

import simd
import SwiftUI
import SceneKit

func Q4() -> SCNNode {
    let cone: Cone = .init(radiusBottom: 1.0, radiusTop: 0.2, height: 2.0, faceCount: 24)
    
    return cone.makeCone()
}
