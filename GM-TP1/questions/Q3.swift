//
//  Q3.swift
//  GM-TP1
//
//  Created by Max PRUDHOMME on 29/10/2025.
//

import simd
import SwiftUI
import SceneKit

func Q3() -> SCNNode {
    let sphere: Sphere = .init(radius: 1.0, faceCount: 32, meridianCount: 16)
    
    return sphere.makeSphere()
}
