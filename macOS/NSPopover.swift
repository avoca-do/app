import AppKit

extension NSPopover {
    var view: NSView {
        contentViewController!.view
    }
}
