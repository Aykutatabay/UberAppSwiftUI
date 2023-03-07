//
//  LocationSearchViewModel.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 24.02.2023.
//

import Foundation
import MapKit
import Combine
import Firebase

enum LocationResultsViewConfig {
    case ride
    case saveLocation(SavedLocationViewModel)
}


class LocationSearchViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var queryFragment: String = ""
    @Published var userLocationCoordinate: CLLocationCoordinate2D?
    @Published var selectedLocationCoordinate: UberLocation?
    @Published var results: [MKLocalSearchCompletion] = []
    @Published var pickUpTime: String?
    @Published var dropOffTime: String?
    private let searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()
    var cancellables = Set<AnyCancellable>()
    
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        // its override because we conform to nsobject that parent of the all classes
        updateQueryFragment()
        publishUserLocation()
        // this query fragment is what it is, what the search completer uses to search for all of those locations
    }
    
    // MARK: - Helpers

    
    func configurePickUpAndDropOffTime(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        pickUpTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravelTime)
    }
    
    func getDestinationRoute(from userLocationCoordinate: CLLocationCoordinate2D, to destinationLocationCoordinate: CLLocationCoordinate2D) -> AnyPublisher<MKRoute, Error> {
        return Future<MKRoute, Error> { promise in
            let userPlacemark = MKPlacemark(coordinate: userLocationCoordinate)
            let destinationPlacemark = MKPlacemark(coordinate: destinationLocationCoordinate)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlacemark)
            request.destination = MKMapItem(placemark: destinationPlacemark)
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                if let error = error {
                    print("ERROR: Failed to get direction", error.localizedDescription)
                    promise(.failure(error))
                    return
                }
                guard let route = response?.routes.first else { return }
                self.configurePickUpAndDropOffTime(with: route.expectedTravelTime)
                promise(.success(route))
            }
            
        }.eraseToAnyPublisher()
    }
    
    func computeRiderPrice(for type: RideType) -> Double {
        guard let selectedLocationCoordinate = self.selectedLocationCoordinate?.coordinate else { return 0 }
        guard let userLocationCoordinate = self.userLocationCoordinate else { return 0 }
        
        let startPointCoordinate = CLLocation(latitude: userLocationCoordinate.latitude, longitude: userLocationCoordinate.longitude)
        let destination = CLLocation(latitude: selectedLocationCoordinate.latitude, longitude: selectedLocationCoordinate.longitude)
        
        let tripDistanceInMeters = startPointCoordinate.distance(from: destination)
        return type.computePrice(for: tripDistanceInMeters)
        
    }
    
    func publishUserLocation() {
        UserLocationManager.shared.$userlocaiton
            .sink {[weak self] userLocationCoordinate in
                self?.userLocationCoordinate = userLocationCoordinate
            }.store(in: &cancellables)
    }
    
    func receivePublishedLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultsViewConfig) {
        selectedLocation(localSearch)
            .sink { _ in
                
            } receiveValue: { item in
                let coordinate = item.placemark.coordinate
                switch config {
                case .ride:
                    self.selectedLocationCoordinate = UberLocation(title: localSearch.title, coordinate: coordinate)
                case .saveLocation(let viewModel):
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    let savedLocation = SavedLocation(title: localSearch.title, address: localSearch.subtitle, coordinate: GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
                    
                    do {
                        let encodedLocation = try Firestore.Encoder().encode(savedLocation)
                        Firestore.firestore().collection("users").document(uid).updateData([
                            viewModel.dataBaseKey: encodedLocation
                        ])
                    } catch let error {
                        print("ERROR: problem with encoded the saved location",error.localizedDescription)
                    }
                }
                
            }.store(in: &cancellables)

    }
    
    func selectedLocation(_ localSearch: MKLocalSearchCompletion) -> AnyPublisher<MKMapItem, Error> {
        Future<MKMapItem, Error> { promise in
            self.locationSearch(forLocalSearchCompletion: localSearch) { response, error in
                if let error = error {
                    print("ERROR: ",error.localizedDescription)
                    promise(.failure(error))
                }
                guard let item = response?.mapItems.first else { return }
                
                promise(.success(item))
            }
        }.eraseToAnyPublisher()
    }
    
    func locationSearch (forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    func updateQueryFragment() {
        $queryFragment
            .sink {[weak self] queryFragment in
                self?.searchCompleter.queryFragment = queryFragment
            }
            .store(in: &cancellables)
    }
    
    
}




// MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    // it executes a search based on the query fragment and then once that search completes. it executes some sort of search that goes on under the hood or in the background
    // arama içindeki query fragment, arayınca cıkanlar da completionlar
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
