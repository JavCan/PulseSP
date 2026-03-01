import SwiftUI

enum TabItem: Int {
    case home
    case breathe
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem

    var body: some View {
        HStack {
            tabButton(
                tab: .home,
                systemImage: "house.fill"
            )

            Divider()
                .frame(height: 50)
                .background(Color.Clay)
                .padding(.horizontal, 15)

            tabButton(
                tab: .breathe,
                systemImage: "leaf.fill"
            )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 32)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.PalidSand)
        )
        .padding(.horizontal, 20)
    }

    private func tabButton(tab: TabItem, systemImage: String) -> some View {
        Button {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
        } label: {
            Image(systemName: systemImage)
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(
                    selectedTab == tab
                    ? Color.Clay
                    : Color.Clay.opacity(0.5)
                )
                .frame(maxWidth: .infinity)
        }
    }
}
