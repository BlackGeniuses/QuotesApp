//
//  ARExperience.swift
//  Quotes
//
//  Created by Donovan Holmes on 8/19/24.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARViewContainer: UIViewRepresentable {
    let category: ARCategory
    let subCategory: ARSubCategory
    
    class Coordinator {
        var cancellables = Set<AnyCancellable>()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configure AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.isAutoFocusEnabled = true
        configuration.environmentTexturing = .automatic
        configuration.isLightEstimationEnabled = true
        
        arView.session.run(configuration)
        
        setupFixedImage(for: category, subCategory: subCategory, on: arView)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Handle updates if needed
    }
    
     func setupFixedImage(for category: ARCategory, subCategory: ARSubCategory, on arView: ARView) {
        guard let texture = try? TextureResource.load(named: subCategoryTextureName(subCategory: subCategory)) else {
            print("Failed to load texture")
            return
        }
        
        // Create a plane with the texture and provide a base color (e.g., white)
        var material = SimpleMaterial(color: .white, isMetallic: false)
        material.baseColor = .texture(texture)
        
        let plane = ModelEntity(mesh: .generatePlane(width: 1.0, height: 1.0), materials: [material])
        
        // Create an anchor that always follows the camera
        let cameraAnchor = AnchorEntity(.camera)
        
        // Position the plane in front of the camera
        plane.position = SIMD3<Float>(0, 0, -1.0) // 1 meter in front of the camera
        
        // Add the plane to the camera anchor
        cameraAnchor.addChild(plane)
        
        // Add the camera anchor to the scene
        arView.scene.addAnchor(cameraAnchor)
    }
    
    private func subCategoryTextureName(subCategory: ARSubCategory) -> String {
        switch subCategory {
        case .modernHome:
            return "AdobeStock_233536756"
        case .classicHome:
            return "AdobeStock_322882600_Preview"
        case .jeep:
            return "AdobeStock_190484165_Preview"
        case .modernOffice:
            return "AdobeStock_616064905_Preview"
        case .classicOffice:
            return "AdobeStock_81620385_Preview"
        case .modernCloset:
            return "AdobeStock_432447573_Preview"
        }
    }
}


enum ARCategory: String, CaseIterable, Identifiable {
    case home = "Future Home"
    case car = "Future Car"
    case office = "Boss Up"
    case closet = "Change Clothes"

    var id: String { self.rawValue }

    var displayName: String {
        return self.rawValue
    }

    var systemImageName: String {
        switch self {
        case .home:
            return "house"
        case .car:
            return "car"
        case .office:
            return "viewfinder"
        case .closet:
            return "water"
        }
    }
}

enum ARSubCategory: String, CaseIterable, Identifiable {
    case modernHome = "Modern Home"
    case classicHome = "Classic Home"
    case jeep = "Panoramic Jeep"
    case modernOffice = "Modern Office"
    case classicOffice = "Classic Office"
    case modernCloset = "Modern Closet"

    var id: String { self.rawValue }

    var displayName: String {
        return self.rawValue
    }

    var systemImageName: String {
        switch self {
        case .modernHome:
            return "house.fill"
        case .classicHome:
            return "house"
        case .jeep:
            return "jeep"
        case .modernOffice:
            return "desk.fill"
        case .classicOffice:
            return "building.2"
        case .modernCloset:
            return "shirt.fill"
        }
    }
}
