# 🚘 Hitch – University Carpooling App (Flutter Frontend)

## 🧭 Overview
**Hitch** is a university carpooling application that connects students and staff members to share rides, reduce travel costs, and promote eco-friendly transportation.  
This repository contains the **Flutter frontend** of the platform, providing a modern, intuitive, and responsive mobile experience.

---

## 🧩 Features
- 🔍 **Search for rides** by location, date, and available seats
- 🚗 **Offer a ride** as a driver with detailed trip and vehicle information
- 💬 **In-app messaging & notifications** for coordination between passengers and drivers
- 💳 **Integrated payments** for fair cost-sharing
- 👤 **User profiles** with trip history, reviews, and driver ratings
- 📱 **Real-time synchronization** with the Spring Boot backend (REST API)

---

## ⚙️ Tech Stack
| Layer | Technology |
|-------|-------------|
| Framework | Flutter (Dart) |
| State Management | Provider / Riverpod |
| HTTP Client | Dio / http package |
| Authentication | JWT (via Spring Boot API) |
| Backend | Spring Boot + PostgreSQL |
| Notifications | Firebase Cloud Messaging (or SMS gateway) |

---

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/your-username/hitch-flutter.git
cd hitch-flutter
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Configure environment
Create a `.env` file or configure constants in `lib/config/api_constants.dart`:
```dart
const String baseUrl = "http://<your-backend-ip>:8080/api/v1";
```

### 4. Run the app
```bash
flutter run
```

---

## 🧠 Project Structure
```
lib/
 ├── models/           # Data models (User, Vehicle, Trip, Booking, etc.)
 ├── services/         # API and data services
 ├── providers/        # State management logic
 ├── screens/          # UI screens (login, home, trip detail, etc.)
 ├── widgets/          # Reusable UI components
 └── utils/            # Helpers, formatters, constants
```

---

## 🧑‍💻 API Integration
The app consumes the **Hitch REST API** (Spring Boot backend).  
All endpoints are authenticated via JWT and return standardized JSON responses:
```json
{
  "status": "success",
  "data": { },
  "message": "Trip created successfully"
}
```

---

## 🧱 Build & Deployment
To build a release APK:
```bash
flutter build apk --release
```

To run on a specific device:
```bash
flutter run -d <device_id>
```

---

## 📸 UI Preview *(optional section)*
_Add screenshots or demo GIFs here when available._

---

## 🤝 Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to your branch (`git push origin feature/amazing-feature`)
5. Create a Pull Request

---

## 🪪 License
This project is licensed under the **MIT License** — feel free to use, modify, and distribute it.

---

## 👨‍💻 Author
**Kangue Kwelle Patrick Loïc**  
Fullstack Developer — *Spring Boot | Flutter | PostgreSQL*  
📧 [your.email@example.com]  
🌐 [Portfolio or LinkedIn URL]
