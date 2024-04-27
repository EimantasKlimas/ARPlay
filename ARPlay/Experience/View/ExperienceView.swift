import SwiftUI
import RealityKit
import ARKit

struct ExperienceView: View {
    @State private var isCameraLoaded = false
    
    var body: some View {
        ExperienceViewContainer(onCameraLoaded: {
            self.isCameraLoaded = true
        })
        .edgesIgnoringSafeArea(.all)
        .overlay(
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                .edgesIgnoringSafeArea(.all)
                .opacity(isCameraLoaded ? 0 : 1)
        )
        .tabItem {
            Label("Play", systemImage: "arcade.stick.console")
        }
    }
}

struct ExperienceViewContainer: UIViewRepresentable {
    var onCameraLoaded: (() -> Void)?
    
    func makeCoordinator() -> ExperienceCoordintor {
        ExperienceCoordintor(self)
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.session.delegate = context.coordinator
        context.coordinator.view = arView
        
        let anchor = AnchorEntity(
            .plane(
                .horizontal,
                classification: .any,
                minimumBounds: SIMD2<Float>(1, 1)
            )
        )
        createBox(arView: arView, anchor: anchor)
        context.coordinator.loadModels(at: anchor)
        arView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(context.coordinator.handleTap(_:))
            )
        )
        
        arView.scene.addAnchor(anchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func createBox(arView: ARView, anchor: AnchorEntity) {
        let material = SimpleMaterial(color: .black, isMetallic: true)
        let box = ModelEntity(
            mesh: MeshResource.generateBox(size: 0.1),
            materials: [material]
        )
        box.scale = simd_make_float3(1, 3, 1)
        box.position = simd_make_float3(1.4, 0, 1.4)
        arView.installGestures(.all, for: box)
        anchor.addChild(box)
    }
}

#Preview {
    DebugARView(debugOption: .scene)
}

