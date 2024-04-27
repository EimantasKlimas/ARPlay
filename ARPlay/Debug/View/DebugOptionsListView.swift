import SwiftUI
import RealityKit
import ARKit

struct DebugOptionListView: View {
    let viewModel: DebugOptionListViewModel = .init()
    
    var body: some View {
        NavigationStack {
            List(viewModel.debugOptions) { debugOption in
                
                NavigationLink("Go to \(debugOption.rawValue)", value: debugOption)
            }
            .navigationTitle("AR Debug Options")
            .navigationDestination(for: DebugOption.self) { option in
                DebugARView(
                    debugOption: option
                )
            }
        }
        .ignoresSafeArea()
        .tabItem {
            Label("Debug", systemImage: "sun.max.circle.fill")
        }
    }
}

#Preview {
    DebugOptionListView()
}
