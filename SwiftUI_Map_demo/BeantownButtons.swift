//
//  BeantownButtons.swift
//  SwiftUI_Map_demo
//
//  Created by tom montgomery on 9/24/23.
//

import SwiftUI
import MapKit

struct BeantownButtons: View {
    
    // write the results to the binding
    @Binding var searchResults: [MKMapItem]
    
    @Binding var position: MapCameraPosition
    
    // so we can search within the region that is visible to the user
    // must add visibleRegion to the search request to make it so.  not required
    var visibleRegion: MKCoordinateRegion?
    
    func search(for query: String) {
        // create search request & set parameters
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = visibleRegion ?? MKCoordinateRegion(
            center: .oxford,
            span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))
        
        Task {
            // Execute the search async
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
            
            
    }
    
    var body: some View {
        HStack {
            Button {
                search(for: "playground")
            } label: {
                Label("Playgrounds", systemImage: "figure.and.child.holdinghands")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                search(for: "beach")
            } label: {
                Label("Beaches", systemImage: "beach.umbrella")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                position = .region(.cityPark)
            } label: {
                Label("City Park", systemImage: "bicycle")
            }
            
            Button {
                position = .region(.fairmount)
                // could use ITEM instead of REGION
                // position = .item(.capeCodBay)
            } label: {
                Label("Fairmount Cemetery", systemImage: "building.columns")
            }
        }
        .labelStyle(.iconOnly)
    }
    
    // EXAMPLE - position with an exact MapCamera config
//    position = .camera(
//        MapCamera(
//        centerCoordinate: CLLocationCoordinate2D(
//            latitude: 42.360431,
//            longitude: -71.055930),
//        distance: 980,
//        heading: 242,
//        pitch: 60))
    // SHOWS A SWEET 3D PERSPECTIVE WITH PITCH ANGLE
    
    //EXAMPLE - CAM POSITION WITH USER LOCATION W/FALLBACK IF UNKNOWN
    //position = .userLocation(fallback: .automatic)
    // MUST provide a binding to the Map(position: $position)
}

//#Preview {
//    BeantownButtons()
//}
