import SwiftUI
import RealityKit
import ARKit


class DebugCoordinator: NSObject, ARSessionDelegate {
    var parent: DebugARViewContainer
    
    init(_ parent: DebugARViewContainer) {
        self.parent = parent
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        if camera.trackingState == .normal {
            parent.onCameraLoaded?()
        }
    }
}
