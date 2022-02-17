# Flat Weather
Weather Forecast App (OpenWeather API & CLLocationManager). MVVM architecture. Without storyboard or xib.

The application shows the current weather and the weather for the next 24 hours/7 days for the current user location or any other location. All data stored in CoreData and you can see last weather even offline. Data conversion to many types. 3td party Frameworks are not used

<img src="https://user-images.githubusercontent.com/79332349/154113229-25cd1452-3ef8-40c9-bcd6-86166e944feb.png" width="195" height="422"> <img src="https://user-images.githubusercontent.com/79332349/154113497-4b222b1f-df7c-47c3-bfd7-9aa08e4ae158.png" width="195" height="422"> <img src="https://user-images.githubusercontent.com/79332349/154113590-1c9b1773-c59e-419d-8c55-3759844187d8.png" width="195" height="422"><img src="https://user-images.githubusercontent.com/79332349/154113706-0a72a44e-023e-4e24-83d5-ef6f5a35d9ad.png" width="195" height="422"><img src="https://user-images.githubusercontent.com/79332349/154113772-6e1c557d-1213-4468-90bd-34d92567bf26.png" width="195" height="422"><img src="https://user-images.githubusercontent.com/79332349/154114015-cea312cc-96d6-4f14-b886-6e677c8a476a.png" width="195" height="422">

App features:
- No storyboards and xibs
- MVVM with Data Driven UI
- CoreData with fetchResultController
- Unit Tests
- UI Test
- CLLocationManager

Extra:
- Fastline
- Swiftlint


Installation

- Clone or download files:
git clone https://github.com/dirudenko/Flat-Weather/MyApp.git

- Open MyAPP.xcodeproj
- Set you weatherAPIKey in Helpers/Constants.swift

Requirements
- iOS > 13
- Xcode 13.1

API
- I used OpenWeathermap to get weather data.
- Get your own API key [here](https://home.openweathermap.org/api_keys).

