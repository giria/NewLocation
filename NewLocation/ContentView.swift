import SwiftUI
import CoreLocation

struct ContentView: View {
    @State var newlocationManager = NewLocationManager()
   
    
    var body: some View {
        VStack {
            Image(systemName: "location")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .padding()
            
            Text("New location manager: \(newlocationManager.location?.description ?? "No Location Provided!")")
        }
        .padding()
       
        .task {
            try? await newlocationManager.requestUserAuthorization()
            try? await newlocationManager.startCurrentLocationUpdates()
            // remember that nothing will run here until the for try await loop finishes
        }
    }
}


@Observable
class NewLocationManager {
    var location: CLLocation? = nil
    
    private let locationManager = CLLocationManager()
    
    func requestUserAuthorization() async throws {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startCurrentLocationUpdates() async throws {
        for try await locationUpdate in CLLocationUpdate.liveUpdates() {
            guard let location = locationUpdate.location else { return }

            self.location = location
        }
    }
}
