import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_300/model/map_model.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice_ex/places.dart' as places ;
import 'package:http/http.dart' as http;
class Maps extends StatefulWidget {
  Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}
double? lat;
double? lng;
String radius ='500';
const GoogleApiKey = 'AIzaSyDTDLvrw4lFjZwl5chp-7C3ePDdBgp3NvM';
final homeScaffold = GlobalKey<ScaffoldState>();
class _MapsState extends State<Maps> {
  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(37.42796, -12208574));
  Set<Marker>markersList = {};
late GoogleMapController googleMapController;
NearPLaces nearPLaces = NearPLaces();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffold,
      body: Column(
        children: [
          Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              markers: markersList,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller){
                googleMapController = controller;
              },
              ),
             
          ),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed:(){
               _handlePressButton();
               
               },
             child: const Text('search')),
             const SizedBox(height: 10,),
             ElevatedButton(onPressed: (){
                   getNearbyPlaces();
                 }, child: Text('Near places')),
                 const SizedBox(height: 15,),
             Expanded(
               child: ListView(
                 children: 
                   [Column(
                     children: [
                       if(nearPLaces.results!=null)
                       for(int i =0;i<nearPLaces.results!.length;i++)
                       nearPLacesWidget(nearPLaces.results![i])
                     ],
                   ),
                 ],
               ),
             )
        ],
      ),
    );
  }
  Future<void>_handlePressButton()async{
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
       apiKey: GoogleApiKey,
       onError: onErorr,
       mode: Mode.overlay,
       language: 'en',
       strictbounds: false,
       types: [""],
       decoration: InputDecoration(
        hintText: 'search',
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.white)
        )
       ),
       components: [Component(Component.country, "eg")],
       );

       displayPredection(p!,homeScaffold.currentState);
  }
  void onErorr(PlacesAutocompleteResponse response){
    homeScaffold.currentState!.showBottomSheet((context) {
      return SnackBar(content: Text(response.errorMessage!));
    });
  }
  
  Future<void> displayPredection(Prediction p, ScaffoldState? currentState)async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: GoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders()
    );
    PlacesDetailsResponse details = await places.getDetailsByPlaceId(p.placeId!);
    lat = details.result.geometry!.location.lat;
    lng = details.result.geometry!.location.lng;
    
    markersList.clear();
    markersList.add(Marker(markerId: const MarkerId("0"),position: LatLng(lat!, lng!),infoWindow: InfoWindow(title: details.result.name)));
    setState(() {
      
    });
    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat!,lng!), 14.0));
  }
  
  void getNearbyPlaces()async {
    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location='+lat.toString()+ ','+lng.toString()+'&radius='+radius+'&key='+GoogleApiKey);
    var response = await http.post(url);
    nearPLaces = NearPLaces.fromJson(jsonDecode(response.body));
    setState(() {
      
    });
  }
   Widget? filter(Results results){
    if(results.types!.contains('hospital')||results.types!.contains('health')||results.types!.contains('pharmacy')){
      return Column(
        children: [
          Text('Name: ${results.name!}'),
          //Text('Name: '+results.name!),
          Text(results.openingHours !=null ?"Open":"Closed"),
          //Text(results.types.toString())
        ],
      );
        
      
    }else{
      return null;
    }
  }
  Widget nearPLacesWidget(Results results){
    if(results.types!.contains('hospital')||results.types!.contains('health')||results.types!.contains('pharmacy')){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10,right: 10,left: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(10)),
      child: filter(results),
    );
    }else{
      return const SizedBox(height: 0,);
    }
  }
 
}