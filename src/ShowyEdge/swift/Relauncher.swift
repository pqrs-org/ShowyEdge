import AppKit
import Foundation

struct Relauncher {
    static func relaunch() {
        do {
            print("relaunch")

            let process = Process()
            process.executableURL = Bundle.main.executableURL
            try process.run()
            NSApplication.shared.terminate(self)
        } catch {
            print("Process.run error: \(error)")
        }
    }
}
