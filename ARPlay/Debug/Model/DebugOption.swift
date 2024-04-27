import Foundation
import RealityKit

enum DebugOption: String, Identifiable {
    case scene = "Scene Debug"
    case anchor = "Anchor Debug"
    case geometry = "Anchor Geometry Debug"
    case origin = "Origin Debug"
    
    var getDebugConfiguration: ARView.DebugOptions {
        switch self {
        case .scene: .showSceneUnderstanding
        case .anchor: .showAnchorOrigins
        case .geometry: .showAnchorGeometry
        case .origin: .showWorldOrigin
        }
    }
    
    var id: Self {
        return self
    }
}
