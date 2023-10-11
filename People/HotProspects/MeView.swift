//
//  MeView.swift
//  HotProspects
//
//  Created by Dhruv Rawat on 10/10/23.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    @State private var name = "Tom Cruise"
    @State private var emailAddress = "tomCruise@mi.com"
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            VStack {
                Image(uiImage: qrCode)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                    .contextMenu {
                        Button {
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: qrCode)
                        } label: {
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                        }
                    }
                
                
                
                Form {
                    Section("User Details") {
                        TextField("Email", text: $name)
                            .textContentType(.name)
                            .font(.title2)
                        
                        TextField("Email Address", text: $emailAddress)
                            .textContentType(.emailAddress)
                            .font(.title2)
                        
                    }
                    
                    
                }
                .navigationTitle("Your QR")
                .onAppear(perform: updateCode)
                .onChange(of: name){ updateCode() }
                .onChange(of: emailAddress){ updateCode() }
            }
            
        }
    }
    
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
                
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

#Preview {
    MeView()
}
