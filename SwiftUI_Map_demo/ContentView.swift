//
//  ContentView.swift
//  SwiftUI_Map_demo
//
//  Created by tom montgomery on 9/20/23.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    // TODO: is extension more of a best practice than defining constants in the view?
    static let oxford = CLLocationCoordinate2D(latitude: 39.75312073937112,  longitude: -104.99918878465613)
    
    static let elCharrito = CLLocationCoordinate2D(latitude: 39.75393155111249,  longitude: -104.99116849938966)
}

extension MKCoordinateRegion {
    
    static let cityPark = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 39.74761191056656,
            longitude: -104.95008683320782),
        span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))
    
    static let fairmount = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.70645329416548,  longitude: -104.89790177509029), span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))
}

struct ContentView: View {
    
    
    @State private var searchResults: [MKMapItem] = []
    
    // need to track position so we can fetch appropriate results after the user moves the map
    // .automatic is the default cam position anyway
    @State var camera: MapCameraPosition = .automatic
    
    // add state to track the region that is visible on the map
    @State private var visibleRegion: MKCoordinateRegion?
    
    // to enable marker selection, add a selection binding to the map
    @State private var selectedResult: MKMapItem?
    // can support selection with tags just like a picker or a list (i.e. for annotations, custom map items) BUT would need to change the selection: var in Map() for this to bind
    @State private var selectedTag: Int?
    
    // get a route from one mapItem to another (a search result)
    @State private var route: MKRoute?
    
    // declare a point of interest, to be able to set a marker
    let historicBldg1 = CLLocationCoordinate2D(
        latitude: 39.73981105001161,
        longitude: -104.9714814593941)
    
    let snarfs = CLLocationCoordinate2D(latitude: 39.73411717690557, longitude: -104.974454885836)
    
    let ogden = CLLocationCoordinate2D(latitude: 39.74033174737522,  longitude: -104.97487116373111)
    
    let hospital = CLLocationCoordinate2D(latitude: 39.746369168169046,  longitude: -104.97309121764467)
    
    let mollyBrown = CLLocationCoordinate2D(latitude: 39.73812565853498,  longitude: -104.98068183669311)
    
    var body: some View {
        
        // closure after Map() is the "Map Content Builder" for the map
        Map(position: $camera, selection: $selectedResult) {
            // Camera region automatically frames the Markers at the zoom level to box them in
            // pass in 'position' binding to control camera position with buttons
            Marker("Colonnade Lofts", coordinate: historicBldg1)
                .tint(.blue)
            Marker("Best Sandwich Shop", systemImage: "fork.knife", coordinate: snarfs)
            Marker("Maisie Peters Venue", coordinate: ogden)
                .tint(.orange)
            Marker("St Josephs Hospital", coordinate: hospital)
            // Instead of Markers "balloon", Annotation presents a swiftUI view
            Annotation("Molly Brown Museum", coordinate: mollyBrown) {
                
                Image(systemName: "person.crop.artframe")
                    .foregroundColor(.white)
                    //.foregroundStyle(.white)
                // TODO: .foregroundColor vs .foregroundStyle?
                    .padding(4)
                    .background(.red)
                    .cornerRadius(4)
            }
            Annotation("El Charrito", coordinate: .elCharrito) {
                // consider .anchor(.bottom) to position the annotation precisely on the coordinate
                
                // use ZStack to compose some shapes and an image
                ZStack {
                    // TODO: why two rounded rects and not one?
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.background)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.secondary, lineWidth: 5)
                    Image(systemName: "car")
                        .padding(5)
                }
            }
            // useful to de-clutter the text overlays on the map
            .annotationTitles(.hidden)
            
            // must have selection state in order for markers to be selectable
            ForEach(searchResults, id: \.self) { result in
                Marker(item: result)
            }
            .annotationTitles(.hidden)
            
            UserAnnotation()
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                VStack(spacing: 0) {
                    
//                    if let selectedResult {
//                        // if there is a selectedResult, show the IIV
//                        ItemInfoView(selectedResult: selectedResult, route: route)
//                            .frame(height: 128)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .padding([.top, .horizontal])
//                    }
                    
                    BeantownButtons(searchResults: $searchResults, position: $camera, visibleRegion: visibleRegion)
                    
                }
                
//                Button {
//                    // center on Colonnade
//                    camera = .region(MKCoordinateRegion(center: historicBldg1, latitudinalMeters: 200, longitudinalMeters: 200))
//                } label: {
//                    Text("Colonnade")
//                }
//                Button {
//                    // center on Molly Brown
//                    camera = .region(MKCoordinateRegion(center: mollyBrown, latitudinalMeters: 200, longitudinalMeters: 200))
//                } label: {
//                    Text("Molly Brown")
//                }
                Spacer()
            }
            .padding(.top)
            .background(.thinMaterial)
        }
        .mapStyle(.standard(elevation: .realistic))
        .onChange(of: searchResults) {
            // reposition depending on the set of search results
            camera = .automatic
        }
        .onChange(of: selectedResult) {
            getDirections()
        }
        .onMapCameraChange { context in
            // by default this is not called until a user is finished interacting with the map (unless you specify frequency). keeps it less chatty
            visibleRegion = context.region
        }
        .mapControls{
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        
        // SafeAreaInset allows for controls above map AND inset so nothing will cover it
        
        // SIMULATOR - OPT+trackpad - pinch to zoom in/out
        // SIMULATOR - OPT+SHIFT+trackpad - tilt to 3d street view
        
        // CONTROLLING THE AREA - set the camera position
        
        // MKMapRect is also an option to control MapCameraPosition
        //
    }
    
    func getDirections() {
        route = nil
        guard let selectedResult else { return }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: .oxford))
        //TODO: how come a MKMapItem is ok for destination,but the source needs it defined in terms of a placemark?
        request.destination = selectedResult
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            // set the state
            route = response?.routes.first
        }
    }
}

#Preview {
    ContentView()
}
