//
//  MapRepresentableView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 24.02.2023.
//

import SwiftUI
import MapKit
import Combine

struct MapRepresentableView: UIViewRepresentable {
    let mapView = MKMapView()
    //@EnvironmentObject var viewModel: LocationSearchViewModel
    @Binding var mapState: MapViewState
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    
    
    // this function is in charge of making our map view
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        /*
         // coordinator, context, uiviewrepresentable definitionlarına bakarsan hatırlarsın
         @MainActor public struct UIViewRepresentableContext<Representable> where Representable : UIViewRepresentable {
             /// The view's associated coordinator.
             @MainActor public let coordinator: Representable.Coordinator
         }
         */
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.tintColor = UIColor(.red)
        return mapView
    }
    
    // this function is called for exmple user select a location this func is called and works. So when we select a location this function will work. @EnvironmentObject publish ediyor ya ordaki bir update burayı da bu fonksiyon sayesinde guncelliyor.
    func updateUIView(_ uiView: UIViewType, context: Context) {
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterUserLocation()
            context.coordinator.addDriversToMap(homeViewModel.drivers)
        case .searchingLocation:
            break
        case .locationSelected:
            if let selectedLocationCoordinate = homeViewModel.selectedLocationCoordinate?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: selectedLocationCoordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: selectedLocationCoordinate)
            }
            break
            
        case .polylineAdded:
            break
        case .tripAccepted:
            guard let driver = homeViewModel.currentUser,
                  driver.accountType == .driver,
                  let route = homeViewModel.routeToPickupLocation,
                  let trip = homeViewModel.trip else { return }
            context.coordinator.clearMapViewAndRecenterUserLocation()
            context.coordinator.configurePolylineToPickupLocation(withRoute: route)
            context.coordinator.addAndSelectAnnotation(withCoordinate: trip.pickupLocation.toCoordinate())
        default:
            break
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}


extension MapRepresentableView {
    
    class MapCoordinator: NSObject , MKMapViewDelegate {
        
        // MARK: - Helpers
        let parent: MapRepresentableView
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        var cancellables = Set<AnyCancellable>()
        
        // MARK: - Lifecycle
        init(parent: MapRepresentableView) {
            self.parent = parent
            super.init()
        }
        
        // MARK: - MKMapViewDelegate
        
        // un fonksiyon userlocation a ulasıyor
        // tells the deleagate that the location of the user was updated
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            self.currentRegion = region
            
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .red
            polyline.lineWidth = 4
            return polyline
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            if let annotation = annotation as? DriverAnnotation {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "driver")
                view.image = UIImage(systemName: "car.side.arrowtriangle.up.fill")
                return view
            }
            return nil
        }
        /*

         */

        
        // MARK: - Helpers
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
            
        }
        
        func addDriversToMap(_ drivers: [User]) {
            let annotations = drivers.map({ DriverAnnotation(driver: $0) })
            self.parent.mapView.addAnnotations(annotations)
            
            
            /*
             for driver in drivers {
                 let driverAnno = DriverAnnotation(driver: driver)
                 self.parent.mapView.addAnnotation(driverAnno)
                 /*
                  let coordinate = driver.coordinates
                  let latitude = coordinate.latitude
                  let longitude = coordinate.longitude
                  let anno = MKPointAnnotation()
                  anno.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                  parent.mapView.addAnnotation(anno)
                  */

             }
             */

             
            
        }
        
        func configurePolylineToPickupLocation(withRoute route: MKRoute) {
            self.parent.mapView.addOverlay(route.polyline)
            let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: .init(top: 64, left: 40, bottom: 400, right: 40))
            self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocationCoordinate else { return }
            
            parent.homeViewModel.getDestinationRoute(from: userLocationCoordinate, to: coordinate)
                .sink { _ in
                    
                } receiveValue: { route in
                    self.parent.mapView.addOverlay(route.polyline)
                    let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: .init(top: 64, left: 40, bottom: 500, right: 40))
                    self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                    
                    self.parent.mapState = .polylineAdded
                }.store(in: &cancellables)
        }
        
        func clearMapViewAndRecenterUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
    
    }
}
