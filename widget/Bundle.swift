import SwiftUI

@main struct Bundle: WidgetBundle {
    @WidgetBundleBuilder var body: some Widget {
        Cards()
        Progress()
        Activity()
    }
}
