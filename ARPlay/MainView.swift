import SwiftUI


struct MainView: View {
    var body: some View {
        TabView {
            DebugOptionListView()
            ExperienceView()
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = .lightGray
        }

    }
}

#Preview {
    MainView()
}
