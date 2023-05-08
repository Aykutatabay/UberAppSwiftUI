//
//  HomeViewModel.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 28.02.2023.
//

import SwiftUI
import Firebase
import Combine
import MapKit

class HomeViewModel:NSObject, ObservableObject {
    
    // MARK: - Properties
    
    //Local Search Properties
    @Published var queryFragment: String = ""
    @Published var userLocationCoordinate: CLLocationCoordinate2D?
    @Published var selectedLocationCoordinate: UberLocation?
    @Published var results: [MKLocalSearchCompletion] = []
    @Published var pickUpTime: String?
    @Published var dropOffTime: String?
    private let searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()
    var currentUser: User?
    @Published var trip: Trip?
    @Published var drivers: [User] = []
    var cancellables = Set<AnyCancellable>()
    let userService = UserService.shared
    var routeToPickupLocation: MKRoute?
    
    var tripCancelledMessage: String {
        guard let user = currentUser, let trip = trip else { return "" }
        
        if user.accountType == .passenger {
            if trip.state == .driverCancelled {
                return "Your driver cancelled this trip"
            } else if trip.state == .passengerCancelled {
                return "Your trip has been cancelled"
            }
        } else {
            if trip.state == .driverCancelled {
                return "Your trip has been cancelled"
            } else if trip.state == .passengerCancelled {
                return "Your trip has been cancelled by the passenger"
            }
        }
        return ""
    }
    
    // MARK: - LifeCycle
    override init() {
        super.init()
        fetchUser()
        searchCompleter.delegate = self
        // its override because we conform to nsobject that parent of the all classes
        updateQueryFragment()
        publishUserLocation()
    }
    
    // MARK: - Helpers
    
    func viewForState(_ state: MapViewState, user: User) -> some View {
        switch state {
        case .locationSelected, .polylineAdded:
            return AnyView(RideRequestView())
        case .tripRequested:
            if let trip = self.trip {
                return user.accountType == .passenger ? AnyView(TripLoadingView()) : AnyView(AcceptTripView(trip))
            }
        case .tripAccepted:
            if let trip = self.trip {
                return user.accountType == .passenger ? AnyView(TripAcceptedView()) : AnyView(PickupPassengerView(trip: trip))
            }
        case .tripCancelledByPassenger, .tripCancelledByDriver:
            return AnyView(TripCancelledView())
            
        default:
            break
        }
        return AnyView(Text(""))
    }
    
    func fetchUser() {
        userService
            .$user
            .sink { _ in
                
            } receiveValue: { [weak self] user in
                guard let user = user else { return }
                self?.currentUser = user
                self?.drivers = []
                if user.accountType == .passenger {
                    self?.fetchDrivers()
                    self?.addTripObserverForPassenger()
                } else {
                    self?.addTripObserverForDriver()
                }
                
                
            }.store(in: &cancellables)
    }
    
    func cancelTripAsPassenger() {
        updateTripState(state: .passengerCancelled)
    }
    
    
    func rejectTrip() {
        updateTripState(state: .rejected)
    }
    
    func acceptTrip() {
        updateTripState(state: .accepted)
    }
    
    func cancelTripAsDriver() {
        updateTripState(state: .driverCancelled)
    }
    
    private func updateTripState(state: TripState) {
        guard let trip = trip else { return }
        var data = ["state": state.rawValue]
        if state == .accepted {
            data["travelTimeToPassanger"] = trip.travelTimeToPassanger
        }
        Firestore.firestore().collection("trips").document(trip.id).updateData(data)
    }
    
    func deleteTrip() {
        guard let trip = trip else { return }
        
        Firestore.firestore().collection("trips").document(trip.id).delete() { _ in
            self.trip = nil
        }
    }
}

// MARK: - Passenger API

extension HomeViewModel {
    
    func addTripObserverForPassenger() {
        guard let currentUser = currentUser else { return }
        
        Firestore.firestore().collection("trips").whereField("passengerUid", isEqualTo: currentUser.uid).addSnapshotListener { snapshot, _ in
            guard let change = snapshot?.documentChanges.first,
                      change.type == .added || change.type == .modified else { return }
            
            guard let trip = try? change.document.data(as: Trip.self) else { return }
            self.trip = trip
            print("DEBUG: Updated trip state is \(trip.state)")
        }
    }
    func addTripObserverForDriver() {
        guard let currentUser = currentUser else { return }
        
        Firestore.firestore().collection("trips").whereField("driverUid", isEqualTo: currentUser.uid).addSnapshotListener { snapshot, _ in
            guard let change = snapshot?.documentChanges.first,
                      change.type == .added || change.type == .modified else { return }
            
            guard let trip = try? change.document.data(as: Trip.self) else { return }
            self.trip = trip
            
            print("DEBUG: Updated trip state is \(trip.state)")
            
            self.trip = trip
            
            self.getDestinationRoute(from: trip.driverLocation.toCoordinate(), to: trip.passengerLocation.toCoordinate())
                .sink { _ in
                    
                } receiveValue: { route in
                    print("DEBUG: Expected travel to passenger \((route.expectedTravelTime / 60).toOneDecimal()) minutes")
                    print("DEBUG: Distance from passenger \((route.distance / 1600).toOneDecimal())")
                    self.routeToPickupLocation = route
                    self.trip?.travelTimeToPassanger = Int(route.expectedTravelTime / 60)
                    self.trip?.distanceToPassanger = route.distance / 1600
                    
                }.store(in: &self.cancellables)
        }
    }
    
    func fetchDrivers() {
        Firestore.firestore().collection("users")
            .whereField("accountType", isEqualTo: AccountType.driver.rawValue)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("ERROR: Failed to fetch drivers", error.localizedDescription)
                }
                guard let documents = snapshot?.documents else { return }
                
                //let drivers = documents.compactMap({ try? $0.data(as: User.self) })
                let drivers = documents.compactMap { snapshot in
                    let user = try? snapshot.data(as: User.self)
                    return user
                }
                print("DEBUG: Driver \(drivers)")
                self.drivers = drivers
                
            }
    }
    
    func requestTrip() {
        guard let driver = drivers.first else { return }
        guard let currentUser = currentUser else { return }
        guard let dropoffLocation = selectedLocationCoordinate else { return }
        let dropOffGeoPoints = GeoPoint(latitude: dropoffLocation.coordinate.latitude, longitude: dropoffLocation.coordinate.longitude)
        let userLocation = CLLocation(latitude: currentUser.coordinates.latitude, longitude: currentUser.coordinates.longitude)
        
        getPlacemark(forLocation: userLocation)
            .sink { _ in
                
            } receiveValue: { placemark in
                guard let placemark = placemark else { return }
                
                let tripCost = self.computeRiderPrice(for: .uberX)
                let trip = Trip(
                                passengerUid: currentUser.uid,
                                driverUid: driver.uid,
                                passengerName: currentUser.fullName,
                                driverName: driver.fullName,
                                passengerLocation: currentUser.coordinates,
                                driverLocation: driver.coordinates,
                                pickupLocationName: placemark.name ?? "",
                                pickupLocationAddress: self.addressFromPlacemark(placemark),
                                dropoffLocationName: dropoffLocation.title,
                                pickupLocation: currentUser.coordinates,
                                dropoffLocation: dropOffGeoPoints,
                                tripCost: tripCost,
                                distanceToPassanger: 0,
                                travelTimeToPassanger: 0,
                                state: .requested
                )
                
                
                print("DEBUG: Placemark for user location",placemark.name ?? "")
                
                do {
                    let encodedTrip = try Firestore.Encoder().encode(trip)
                    Firestore.firestore().collection("trips").document().setData(encodedTrip)
                    print("DEBUG: Did upload trip to firestore")
                } catch let error {
                    print("ERROR: \(error)")
                }
                
            }.store(in: &cancellables)
    }
    

}



// MARK: - Driver API

extension HomeViewModel {
    func fetchTrips() {
        guard let currentUser = currentUser else { return }
        Firestore.firestore().collection("trips").whereField("driverUid", isEqualTo: currentUser.uid).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents, let document = documents.first else { return }
            guard let trip = try? document.data(as: Trip.self) else { return }
            
            self.trip = trip
            self.getDestinationRoute(from: trip.driverLocation.toCoordinate(), to: trip.passengerLocation.toCoordinate())
                .sink { _ in
                    
                } receiveValue: { route in
                    print("DEBUG: Expected travel to passenger \((route.expectedTravelTime / 60).toOneDecimal()) minutes")
                    print("DEBUG: Distance from passenger \((route.distance / 1600).toOneDecimal())")
                    
                    self.trip?.travelTimeToPassanger = Int(route.expectedTravelTime / 60)
                    self.trip?.distanceToPassanger = route.distance / 1600
                    
                }.store(in: &self.cancellables)
        }
    }
}


// MARK: - Location Search Helpers

extension HomeViewModel {
    
    func addressFromPlacemark(_ placemark: CLPlacemark) -> String {
        var result = ""
        if let thoroughfare = placemark.thoroughfare {
            result += thoroughfare
        }
        
        if let subthoroughfare = placemark.subThoroughfare {
            result += " \(subthoroughfare)"
        }
        if let subadministrativearea = placemark.subAdministrativeArea {
            result += ", \(subadministrativearea)"
        }
        return result
    }
    
    func getPlacemark(forLocation location: CLLocation) -> AnyPublisher<CLPlacemark?, Error> {
        Future<CLPlacemark?, Error> { promise in
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    promise(.failure(error))
                }
                guard let placemark = placemarks?.first else { return }
                promise(.success(placemark))
                
            }
        }.eraseToAnyPublisher()
    }
    
    
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


extension HomeViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
