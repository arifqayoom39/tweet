## Tweet Clone App

Source Code for a Full-Stack Twitter-like Application - Fully Compatible with Android & iOS!


## 🚀 Features

- **Authentication**:
  - Sign Up with Email & Password
  - Sign In with Email & Password
- **Tweeting**:
  - Post Tweets with Text
  - Post Tweets with Images
  - Share Links in Tweets
- **Hashtags**:
  - Automatic Hashtag Detection & Storage
- **Engagement**:
  - Display Tweets in Feed
  - Like Tweets
  - Retweet Posts
  - Comment/Reply to Tweets
- **User Interaction**:
  - Follow & Unfollow Users
  - Search for Users
  - View Followers and Following Lists
- **Profile Management**:
  - Edit User Profile
  - Display Recent Tweets, Followers, and Following on Profile
- **Tweet Filters**:
  - View Tweets by Hashtag
- **Extras**:
  - Display Verified (Blue Tick) Users
  - Notifications Tab (Get Notified when Someone Replies, Follows, Likes, or Retweets)



## 🛠️ Tech Stack

- **Backend**: Appwrite (Auth, Storage, Database, Realtime)
- **Frontend**: Flutter (Mobile App), Riverpod (State Management)
  


## 🔧 Installation

To set up and run the Tweet Clone app locally, follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/arifqayoom39/tweet.git
   ```

2. **Navigate to the Project Directory**:
   ```bash
   cd tweet
   ```

3. **Install Appwrite Locally** (See [Appwrite Installation Documentation](https://appwrite.io/docs/installation)).

4. **Create Appwrite Project**:
   - Set up an Appwrite project for both Android & iOS in the Appwrite Dashboard.
   - Configure Appwrite Database, Storage, and Realtime services.
   - Create attributes for Tweets, Users, and Notifications collections.
   - Adjust Roles and Permissions for Authentication, Database, and Storage.

5. **Update Configuration**:
   - In `lib/constants/appwrite_constants.dart`, update:
     - Your project-specific **IDs** (from the Appwrite Dashboard).
     - Your **IP Address** for local development.

6. **Run the App**:
   ```bash
   flutter pub get
   open -a simulator # for iOS simulator
   flutter run
   ```

---

## 📥 Download the APK

We are currently in the final stages of testing the **Saafir Bus Ticketing App** before its official launch on the Play Store. You can download the APK directly from the following sources:

- **Google Drive:** [Download APK](https://drive.google.com/file/d/17sFkf7q11LDHxh4Z7T-yTAIaEnReya1P/view?usp=drivesdk)
- **Testing Version:** We are highly testing this app to ensure it meets the highest quality standards before launch.


## 💡 Inspiration

This project draws inspiration from Rivaan Ranawat's Tweet Clone series. We’ve built upon those ideas to create a fully functional, scalable app.

---

## 🖼️ Screenshots

Here are some visual previews of the Tweet Clone App:

| Sign Up Page | Tweet Feed | Profile Page |
|--------------|------------|--------------|
| ![Sign Up](https://github.com/arifqayoom39/tweet/blob/main/signup.jpeg) | ![Tweet Feed](https://github.com/arifqayoom39/tweet/blob/main/tweet.jpeg) | ![Profile Page](https://github.com/arifqayoom39/tweet/blob/main/profile.jpeg) |

---


## 🤝 Contributing

We welcome contributions from community! Here's how to get started:

1. Fork this repository.
2. Clone your fork: `https://github.com/arifqayoom39/Saafir.git`
3. Create a branch: `git checkout -b feature/your-feature-name`
4. Make your changes.
5. Commit your changes: `git commit -m "Brief description of changes"`
6. Push to your branch: `git push origin feature/your-feature-name`
7. Submit a pull request.



## 🤝 Feedback

We would love to hear your thoughts and suggestions for improvements. Feel free to reach out at **arifqayoom39@gmail.com**.
