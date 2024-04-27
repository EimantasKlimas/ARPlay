import SwiftUI
import Combine
import RealityKit
import ARKit

class ExperienceCoordintor: NSObject, ARSessionDelegate {
    var cancelStore: Set<AnyCancellable> = .init()
    var parent: ExperienceViewContainer
    
    weak var view: ARView?

    init(_ parent: ExperienceViewContainer) {
        self.parent = parent
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let view, view.scene.anchors.first(where: { $0.name == "cosmonout"}) == nil else {
            return
        }
        
        let tapLocation = recognizer.location(in: view)
        let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first {
            let anchor = AnchorEntity(raycastResult: result)
            ModelEntity
                .loadAsync(named: "CosmonautSuit_en")
                .sink { _ in
                    print("Failed Loading Entity")
                } receiveValue: { entity in
                    entity.scale = simd_make_float3(0.5, 0.5, 0.5)
                    anchor.addChild(entity)
                    anchor.name = "cosmonout"
                    view.scene.addAnchor(anchor)
                }
                .store(in: &cancelStore)
        }
    }
    
    func loadModels(at anchor: AnchorEntity) {
        ModelEntity
            .loadAsync(named: "hab_en")
            .sink { loadCompletion in
                print("Failed Loading Entity 1")
            } receiveValue: { entity in
                entity.scale = simd_make_float3(1.2, 1.2, 1.2)
                anchor.addChild(entity)
            }.store(in: &cancelStore)
                
        ModelEntity
            .loadAsync(named: "LunarRover_English")
            .sink { _ in
                print("Failed Loading Entity 2")
            } receiveValue: { entity in
                entity.position = simd_make_float3(0, 0, 0.7)
                anchor.addChild(entity)
            }
            .store(in: &cancelStore)
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        if camera.trackingState == .normal {
            parent.onCameraLoaded?()
        }
    }
}
