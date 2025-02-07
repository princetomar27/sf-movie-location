# sfmovie

### **Movie Location Project Documentation**

---

## **Project Overview**
The **Movie Location Project** displays movie filming locations on a map of San Francisco. The project fetches movie location data from a public API (`https://data.sfgov.org/resource/yitu-d5am.json`), processes the data, and presents it to the user on an interactive map using **Google Maps**.

### **Key Features:**
1. **Fetch Movie Location Data**: Retrieve movie location data via an API request.
2. **Interactive Google Map**: Display the locations on a map with markers for each movie.
3. **Data Filtering**: Users can filter the movie locations by title, location, or other metadata.
4. **Error Handling**: Handle missing or invalid data gracefully.

---

## **Technologies Used**

- **Flutter**: The front-end framework used for building the mobile app.
- **Dart**: The programming language used in Flutter.
- **Dio**: HTTP client for making requests to the API.
- **Google Maps API**: Used to render the map and show movie locations.
- **Dartz**: For functional programming, used to return either success or failure results.
- **Flutter Dotenv**: For managing API keys and environment variables.

---

## **API Integration**

### **Base URL**
- The movie location data is retrieved from `https://data.sfgov.org/resource/yitu-d5am.json`.

### **Headers**
- The API requires an `X-App-Token` for authentication. This token is stored in the `.env` file for security.

### **API Response Example**
```json
[
  {
    "title": "Always Be My Maybe",
    "release_year": "2019",
    "locations": "717 Grant Ave",
    "production_company": "Isla Productions, LLC",
    "distributor": "Netflix",
    "director": "Nahnatchka Khan",
    "writer": "Michael Golamco, Randall Park, Ali Wong",
    "actor_1": "Ali Wong",
    "actor_2": "Randall Park",
    "actor_3": "Keanu Reeves",
    "point": {
      "type": "Point",
      "coordinates": [-122.4063975, 37.7936544]
    },
    "longitude": "-122.4063975",
    "latitude": "37.7936544"
  },
  ...
]
```

---

## **Project Structure**

### **lib/**
The main directory for the Flutter application code.

#### **lib/main.dart**
The entry point for the app, responsible for setting up the environment, routes, and widgets.

#### **lib/core/**
Contains the core components and utilities such as error handling, failure classes, and the HTTP client.

- **errors/**
  - `exceptions.dart`: Defines exceptions for API calls.
  - `failures.dart`: Defines failure types like `ServerFailure` and `PermissionFailure`.
  
- **network/**
  - `error_message_model.dart`: Defines the error message structure returned from the API.
  

#### **lib/features/movie_location/**
Contains the main logic for interacting with the movie locations.

- **data/**
  - `models/movie_location_model.dart`: Defines the structure of the data fetched from the API and provides JSON parsing.
  - `datasource/movie_remote_data_source.dart`: Responsible for fetching movie location data from the API.
  - `repositories/movie_repository_impl.dart`: Defines the interface for the repository impl that fetches movie data.
  
- **domain/**
  - `entities/movie_location.dart`: The entity that represents a movie location used throughout the app.
  - `repositories/movie_repository.dart`: Defines the interface for the repository that fetches movie data.
  - `usecases/get_movie_locations.dart`: Defines the interface for the usecase that fetches movie data.
  
- **presentation/** (UI Layer)
  - `movie_location_screen.dart`: Displays the movie locations on the map.
  - `movie_location_cubit.dart`: Handles the state of the movie location data (using Cubit for state management).

---

## **Error Handling**
The app uses **Dartz** for functional error handling and **`Either<Failure, Success>`** patterns:
- **Failure Types**:
  - `ServerFailure`: Triggered when an error occurs during the API call.
  - `PermissionFailure`: Triggered when there is an issue with permissions.

- **Handling Missing or Malformed Data**:
  - If a field such as `latitude` or `longitude` is missing, the app defaults to `0.0`.
  - If the API fails to respond correctly, detailed error messages are displayed.

---

## **State Management**

The application uses **Cubit** for state management. The core states for movie locations include:
- **MovieLocationInitial**: Initial state, before any data is loaded.
- **MovieLocationLoading**: Loading state, displayed while the API request is being made.
- **MovieLocationLoaded**: Contains the movie location data after successful retrieval.
- **MovieLocationError**: Error state, displayed when the data retrieval fails.

---

## **How to Run the Project**

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-repository/movie-location-flutter.git
   ```

2. **Install dependencies**:
   Navigate to the project directory and run:
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**:
   - Create a `.env` file at the root of the project.
   - Add your **API_BASE_URL** and **API_TOKEN** to the `.env` file:
     ```
     API_BASE_URL=https://data.sfgov.org/resource/yitu-d5am.json
     API_TOKEN=your_api_token_here
     ```

4. **Run the app**:
   ```bash
   flutter run
   ```

---

## **Screenshots**
![Simulator Screenshot - iPhone 15 Pro Max - 2025-02-07 at 14 17 21](https://github.com/user-attachments/assets/c319b78c-87e1-492a-82f9-7c0c30dcaf51)


---

## **Future Improvements**
- **Add Offline Caching**: Implement local storage (e.g., Hive or SharedPreferences) to cache data for offline use.
- **Retry Logic**: Implement automatic retry logic in case of temporary API failures.
- **Error Logging**: Add better logging for failed requests to help with debugging.
- **Additional Data**: Enhance the app by showing movie posters, trailers, and Street View for each location, if we have another api to fetch movie details using name.

---


---

This documentation provides an overview of the movie location project and outlines how to run the app, the core components, and how the app handles data and errors.
