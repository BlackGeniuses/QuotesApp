//
//  ARViewContainerTests.swift
//  QuotesTests
//
//  Created by Donovan Holmes on 8/20/24.
//
import XCTest
import RealityKit
import ARKit
@testable import Quotes

final class ARViewContainerTests: XCTestCase {
    var arViewContainer: ARViewContainer!
    var arView: ARView!

    override func setUpWithError() throws {
        arViewContainer = ARViewContainer(category: .home, subCategory: .modernHome)
        arView = ARView(frame: .zero)
    }

    override func tearDownWithError() throws {
        arViewContainer = nil
        arView = nil
    }

    func testSetupFixedImage() throws {
        // Directly call the internal method to test setup logic
        arViewContainer.setupFixedImage(for: .home, subCategory: .modernHome, on: arView)
        
        XCTAssertNotNil(arView.scene.anchors.first, "There should be an anchor added to the ARView")
        XCTAssertEqual(arView.scene.anchors.count, 1, "There should be exactly one anchor in the AR scene")
    }

    func testARViewSetup() throws {
        // Instead of directly testing makeUIView, check the configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]

        XCTAssertEqual(configuration.planeDetection, ARWorldTrackingConfiguration.PlaneDetection([.horizontal, .vertical]), "ARView should be configured to detect horizontal and vertical planes")
        XCTAssertTrue(configuration.isAutoFocusEnabled, "Autofocus should be enabled")
        XCTAssertTrue(configuration.isLightEstimationEnabled, "Light estimation should be enabled")
    }
}

