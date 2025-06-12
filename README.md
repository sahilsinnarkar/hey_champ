# Hey Champ App 🚀

**Hey Champ App** is a productivity-focused Flutter mobile application designed to help users manage their study sessions, reminders, daily habits, notes, expenses, and more — all integrated with Firebase and built using VS Code.

---

## 📱 Features

- ✅ Focus session tracker by subject
- ✅ Daily habit tracker
- ✅ To-do list manager
- ✅ Smart revision planner (spaced repetition)
- ✅ Rich text notes with PDF export
- ✅ Expense manager
- ✅ Real-time AI chatbot
- ✅ Firebase Authentication
- ✅ Local notifications with permission handling

---

## 🔧 Tech Stack

- **Flutter 3.8.1**
- **Firebase Auth/Core**
- **Hive (local database)**
- **Google Gemini API**
- **Provider (state management)**
- **Flutter Local Notifications**
- **PDF & Printing packages**
- **Go Router (navigation)**
- **Flutter Dotenv (for environment variables)**

---

## 🔐 Environment Setup

Create a `.env` file at the root of your project:

```env
MY_GEMINI_API_KEY=your_api_key_here
```

▶️ Getting Started
1. Clone the Repository
   ```
   git clone https://github.com/sahilsinnarkarr/hey_champ.git
   cd hey_champ_app
   ````
2. Install Dependencies
   `flutter pub get`
3. Clean build cache
   `flutter clean`
4. Generate necessary files
   `dart run build_runner build`
5. Run the app
  `flutter run`

⚙️ VS Code Setup
This project was built using Visual Studio Code. If you’re using Android Studio, make sure the IDE handles .env, build_runner, and Firebase integration accordingly.

📌 Notes
- This project uses flutter_launcher_icons to generate app icons.
- firebase_options.dart is auto-generated and should not be modified manually.
- You can add more environment variables in .env and access them using flutter_dotenv.
