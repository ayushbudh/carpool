# Carpool

## Description

Carpool app is a cross platform app that can help to reduce carbon footprint by sharing car ride for people travelling on same route as of driver. This app is currently a MVP where a rider can request for ride to a driver that is currently driving for the same origin and destination location. The long term vision of this app is to solve problems like insecurity(by scanning government ID of drivers and riders for safety), close pickup location for riders (by enforcing 0.5 mile walk distance policy) and helping people use free electic bikes to minimize the walking distance for riders.

Carpool app has two separate UIs: Driver and Rider. Drivers have the ability to start/cancel a ride and during there ongoing drive they can received incoming request from the riders for a ride. Drivers can either accept/reject the request based on the drivers will. Riders have the ability to find a new ride and wait till there request gets accepted/rejected.

## Prototype

<img width="929" alt="Screen Shot 2022-04-14 at 12 38 23 AM" src="https://user-images.githubusercontent.com/56787472/163314649-e02c9d56-7374-4ca9-88d7-1da555951573.png">

View on figma: https://www.figma.com/file/sYpzzz2ShWBI7K8lAojgAe/Car-Pooling?node-id=0%3A1

## Flow Chart

<img width="789" alt="Screen Shot 2022-04-17 at 12 43 14 AM" src="https://user-images.githubusercontent.com/56787472/163700762-e9373ca2-0be1-4a39-a49e-a56313d6ca26.png">


## Technical Deep Dive

[1] __User Authentication & Firstore__

User authentication is setup signup/sign in users using either email and password or Google account auth with Firebase authentication service. When the app launches and no user is logged in on the launchscreen user can select between driver or rider as the role for signup/signin. Each new user is stored in the users collection with there user details in the Firebase Firestore. Whether a driver/rider exists already as a rider/driver in the users collection is handled by the code and it will display error for this type of situations.


[2] __Firebase Firstore & Usage of Google Maps Platform__

Firebase Firestore stores the users details and information like whether drivers are available or not, new incoming requests for drivers, etc. When a driver starts a ride the isDriving property is set to true so that the driver becomes visible to other riders for incoming ride requests. When a rider requests for a ride driver can either accepth or reject and based on that a request object with details like riders name, latlng points, status etc are stored in both riders and drivers requests collection. This approach helps to listen to new requests and keep track of status in real time for both drivers and riders. Even though this approach might not be good if the app is scaled as it will depend on the Firstore realtime event handling capability in which case an event driven architecture will need to be adopted. Google Places and Directions API are used to get the polypoints of a route to draw it on the Google Map Widget for both drivers and riders.

[3] __Driver/Riders Matching Process__

Currently, the drivers and riders are matched based on the start and end location latitude longitude points.

## Technologies

Flutter SDK, Firebase Authentication, Firestore Database, Google Maps Platform APIs (Directions & Places API)

## Project Status Board

Trello Board: https://trello.com/b/o7j75SKg/carpool

## Platform Support

Currently the app works on both Android and IOS platform but there is an polyline drawing issue on the Web.

<details>
  <summary><h2>Setup Instructions</h2></summary>
   <p>To setup the project follow the steps below:
    <ol>
      <li> Clone the repository using <code>git clone -b mapscreen https://github.com/ayushbudh/carpool/ on the terminal/cmd.</code></li>
      <li> Use <code> cd carpool </code> command to get at the root directory of the app </li>
      <li> Get and set up your api key in the code
        <ul>
          <li>Replace API-Key with your own https://github.com/ayushbudh/carpool/blob/6806de822386993f3a4aacb7be852d6e692c7965/ios/Runner/AppDelegate.swift#L13 </li>
        <li>Replace APIKEY with your own for IOS https://github.com/ayushbudh/carpool/blob/6806de822386993f3a4aacb7be852d6e692c7965/lib/services/location_services.dart#L6 </li>
          <li>Replace API-Key with your own for Web https://github.com/ayushbudh/carpool/blob/6806de822386993f3a4aacb7be852d6e692c7965/web/index.html#L29</li>
          <li>Replace API-Key with your own for Android https://github.com/ayushbudh/carpool/blob/6806de822386993f3a4aacb7be852d6e692c7965/android/app/src/main/AndroidManifest.xml#L11</li>

   </p>
 </details>

