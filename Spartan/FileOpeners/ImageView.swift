//
//  ImageView.swift
//  Spartan
//
//  Created by RealKGB on 4/8/23.
//

import SwiftUI
import UIKit

struct ImageView: View {
    @Binding var imagePath: String
    @Binding var imageName: String
    
    @State private var infoShow = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let image = UIImage(contentsOfFile: imagePath + imageName) {
                GeometryReader { geo in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width+50, height: geo.size.height+50)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        .background(UIKitTapGesture(action: {
                            infoShow = true
                        }))
                }
            } else {
                Text(NSLocalizedString("IMAGE_ERROR", comment: "Honey begins when our valiant Pollen Jocks bring the nectar to the hive."))
            }
        }
        .sheet(isPresented: $infoShow) {
            let (width, height, fileSize, encoder) = getImageInfo(from: imagePath + imageName) ?? (0, 0, 0, "?")
            VStack{
                Text(imagePath + imageName)
                    .if(UserDefaults.settings.bool(forKey: "sheikahFontApply")) { view in
                        view.scaledFont(name: "BotW Sheikah Regular", size: 40)
                    }
                    .font(.system(size: 40))
                    .multilineTextAlignment(.center)
                Text(NSLocalizedString("DIMENSIONS", comment: "Our top-secret formula") + String(width) + "x" + String(height))
                    .if(UserDefaults.settings.bool(forKey: "sheikahFontApply")) { view in
                        view.scaledFont(name: "BotW Sheikah Regular", size: 40)
                    }
                Text(NSLocalizedString("INFO_SIZE", comment: "is automatically color-corrected, scent-adjusted and bubble-contoured") + String(fileSize) + " " + NSLocalizedString("BYTES", comment: "into this soothing sweet syrup"))
                    .if(UserDefaults.settings.bool(forKey: "sheikahFontApply")) { view in
                        view.scaledFont(name: "BotW Sheikah Regular", size: 40)
                    }
                Text(NSLocalizedString("IMAGE_ENCODING", comment: "with its distinctive golden glow you know as...") + encoder)
                    .if(UserDefaults.settings.bool(forKey: "sheikahFontApply")) { view in
                        view.scaledFont(name: "BotW Sheikah Regular", size: 40)
                    }
                Button(action: {
                    infoShow = false
                }) {
                    Text(NSLocalizedString("DISMISS", comment: "Honey!"))
                        .if(UserDefaults.settings.bool(forKey: "sheikahFontApply")) { view in
                            view.scaledFont(name: "BotW Sheikah Regular", size: 40)
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func getImageInfo(from filePath: String) -> (width: Int, height: Int, size: Int, encoding: String)? {
        guard let imageSource = CGImageSourceCreateWithURL(URL(fileURLWithPath: filePath) as CFURL, nil) else {
            return nil
        }

        let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, propertiesOptions) as? [CFString: Any] else {
            return nil
        }

        let fileSize = (try? FileManager.default.attributesOfItem(atPath: filePath)[.size] as? Int) ?? 0
        let width = properties[kCGImagePropertyPixelWidth] as? Int ?? 0
        let height = properties[kCGImagePropertyPixelHeight] as? Int ?? 0
        let encoding = properties[kCGImagePropertyColorModel] as? String ?? NSLocalizedString("UNKNOWN", comment: "- That girl was hot.")

        return (width, height, fileSize, encoding)
    }
}
