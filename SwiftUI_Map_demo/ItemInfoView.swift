//
//  ItemInfoView.swift - Title, travel time, and Look Around preview
//  SwiftUI_Map_demo
//
//  Created by tom montgomery on 9/27/23.
//

import SwiftUI
import MapKit

//struct ItemInfoView: View {
//    
//    @State private var lookAroundScene: MKLookAroundScene?
//    
//    // format travel time for display
//    private var travelTime: String? {
//        guard let route else { return nil }
//        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .abbreviated
//        formatter.allowedUnits = [.hour, .minute]
//        return formatter.string(from: route.expectedTravelTime)
//    }
//    
//    func getLookAroundScene() {
//        lookAroundScene = nil
//        Task {
//            // get the scene for a given mapItem using a SceneRequest
//            let request = MKLookAroundSceneRequest(mapItem: selectedResult)
//            lookAroundScene = try? await request.scene
//        }
//    }
//    
//    var body: some View {
//        LookAroundPreview(initialScene: lookAroundScene)
//            .overlay(alignment: .bottomTrailing) {
//                HStack {
//                    Text("\(selectedResult.name ?? "")")
//                    if let travelTime {
//                        Text(travelTime)
//                    }
//                }
//                .font(.caption)
//                .foregroundStyle(.white)
//                .padding(10)
//            }
//            .onAppear() {
//                getLookAroundScene()
//            }
//            .onChange(of: selectedResult) {
//                getLookAroundScene()
//            }
//    }
//}
//
//#Preview {
//    ItemInfoView()
//}
