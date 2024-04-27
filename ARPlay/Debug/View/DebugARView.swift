import SwiftUI
import RealityKit
import ARKit

struct DebugARView: View {
    var debugOption: DebugOption
    @State private var isCameraLoaded = false
    
    var body: some View {
        DebugARViewContainer(debugOption: debugOption, onCameraLoaded: {
            self.isCameraLoaded = true
        })
        .edgesIgnoringSafeArea(.all)
        .overlay(
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                .edgesIgnoringSafeArea(.all)
                .opacity(isCameraLoaded ? 0 : 1)
        )
    }
}

struct DebugARViewContainer: UIViewRepresentable {
    var debugOption: DebugOption
    var onCameraLoaded: (() -> Void)?
    
    func makeCoordinator() -> DebugCoordinator {
        DebugCoordinator(self)
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.session.delegate = context.coordinator
        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        arView.debugOptions = debugOption.getDebugConfiguration
        
        if debugOption == .geometry {
            let anchor = AnchorEntity(
                .plane(
                    .horizontal,
                    classification: .any,
                    minimumBounds: SIMD2<Float>(0.1, 0.1)
                )
            )
            
            arView.scene.addAnchor(anchor)
        }
                
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    DebugARView(debugOption: .scene)
}
