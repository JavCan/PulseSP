import SwiftUI
import CoreGraphics
import CoreText

public struct FontRegistration {
    public static func registerFonts() {
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        
        print("--- Font Registration Debug ---")
        print("Bundle URL: \(bundleURL.path)")
        
        // Search for all .ttf and .otf files in the bundle
        let enumerator = fileManager.enumerator(at: bundleURL, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles])
        
        var fontsFound = 0
        while let fileURL = enumerator?.nextObject() as? URL {
            let ext = fileURL.pathExtension.lowercased()
            if ext == "ttf" || ext == "otf" {
                fontsFound += 1
                print("Found font file: \(fileURL.lastPathComponent)")
                
                var error: Unmanaged<CFError>?
                if !CTFontManagerRegisterFontsForURL(fileURL as CFURL, .process, &error) {
                    let errorDescription = error?.takeRetainedValue().localizedDescription ?? "unknown error"
                    print("  ! Error registering \(fileURL.lastPathComponent): \(errorDescription)")
                } else {
                    print("  ✓ Successfully registered: \(fileURL.lastPathComponent)")
                }
            }
        }
        
        if fontsFound == 0 {
            print("  ! No font files (.ttf or .otf) found in the bundle.")
        }
        
        // List registered fonts for "Comfortaa" to see the actual names
        print("\nChecking available 'Comfortaa' fonts:")
        for family in UIFont.familyNames.sorted() {
            if family.contains("Comfortaa") {
                print("Family: \(family)")
                for name in UIFont.fontNames(forFamilyName: family) {
                    print("  - Font Name: \(name)")
                }
            }
        }
        print("-------------------------------")
    }
}
