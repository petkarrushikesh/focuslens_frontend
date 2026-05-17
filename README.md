## 🚀 Add FocusLens Flutter Frontend

### Description
This PR introduces a complete, production-grade Flutter frontend for the FocusLens study session analyzer. The app provides a beautiful, intuitive UI for uploading study videos and visualizing focus/distraction analytics in real-time.

### What's New
- ✅ Full-featured Flutter mobile & web application
- ✅ Cross-platform support (iOS, Android, Web, Desktop)
- ✅ Seamless video file picker integration
- ✅ Multipart HTTP upload to Flask backend
- ✅ Real-time focus/distraction analytics dashboard
- ✅ Beautiful Material Design 3 UI
- ✅ Focus timeline visualization with event details
- ✅ Server health check and connection status
- ✅ Audio indexing support with language selection
- ✅ Comprehensive error handling and user feedback

### Features Implemented

#### Home Screen
- Video file selection using `file_picker` package
- Real-time server connection status indicator
- Optional audio indexing with language selection
- Loading states and user feedback
- Detailed error messages

#### Results Screen
- Two-page swipeable interface
- Summary page with focus score, metrics, and statistics
- Timeline page with detailed event visualization
- Event color coding (Focus: Green, Distraction: Red, Idle: Yellow)
- Video ID display for reference

#### API Integration
- Health check endpoint monitoring
- Multipart video upload with timeout handling
- Comprehensive error handling for all HTTP status codes
- CORS-compatible requests

### Technical Details

**Dependencies:**
- `http: ^1.1.0` — HTTP requests and multipart uploads
- `file_picker: ^6.1.0` — Cross-platform file selection
- `intl: ^0.19.0` — Internationalization support

**Project Structure:**
VideoDB/
├── backend/           (Existing Flask files)
├── focuslens_flutter/ (Your New Frontend)
│   ├── lib/
│   │   ├── models/
│   │   ├── services/
│   │   ├── screens/
│   │   └── main.dart
│   ├── pubspec.yaml
│   └── README.md
└── README.md          (Root README)


### How to Use

1. **Clone & Setup:**
   ```bash
   git clone https://github.com/NisargWath/VideoDB.git
   cd VideoDB/focuslens_flutter
   flutter pub get

   Configure Backend URL: Edit lib/services/api_service.dart and set the backend URL:

Dart
static const String baseUrl = 'http://your-backend-url:5000';
Run the App:

bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
Backend Requirements
The Flutter app expects the Flask backend to expose:

GET /health — Health check endpoint
POST /upload-session — Video upload endpoint (multipart/form-data)
Ensure Flask is configured for cross-origin requests:

Python
from flask_cors import CORS
app = Flask(__name__)
CORS(app)
app.run(host='0.0.0.0', port=5000)
Testing
✅ Tested on Chrome/Firefox (Web)
✅ Tested on Android emulator
✅ Verified multipart upload functionality
✅ Confirmed API integration with Flask backend
✅ Validated error handling for network failures
Known Limitations
Mobile Network Issue: When running on a mobile device, ensure:
Both devices are on the same Wi-Fi network
Flask backend is bound to 0.0.0.0 (not 127.0.0.1)
Firewall allows port 5000
Use device's local IP (e.g., 192.168.1.x) instead of localhost
Related Issues
Closes: (if any issue number from the original repo)
Screenshots
(Optional: Add screenshots of the UI if available)

Checklist
 Code follows the project style guidelines
 Self-reviewed the code
 Commented complex areas of code
 Updated documentation (added README.md in focuslens_flutter/)
 No breaking changes
 All features tested
Reviewers Notes
This is a complete frontend implementation that pairs seamlessly with the existing FocusLens Flask backend. The app is production-ready and handles all edge cases including network errors, server unavailability, and invalid file formats.

Code

---

Reviewers Notes
This is a complete frontend implementation that pairs seamlessly with the existing FocusLens Flask backend. The app is production-ready and handles all edge cases including network errors, server unavailability, and invalid file formats.

Code

---

## Steps to Push & Create PR

### 1. **Add Your Fork as Remote** (if not already done)
```bash
git remote add upstream https://github.com/NisargWath/VideoDB.git
git fetch upstream
2. Create a Branch from Their Main
bash
git checkout upstream/main
git checkout -b add/flutter-frontend
3. Copy Your Project Files
bash
# Copy your focuslens_flutter folder into the cloned repo
cp -r ~/path/to/your/focuslens_flutter ./focuslens_flutter
4. Commit Your Changes
bash
git add focuslens_flutter/
git commit -m "feat: Add FocusLens Flutter Frontend

- Implement complete Flutter mobile and web application
- Add video file picker and multipart upload service
- Create responsive Material Design 3 UI
- Integrate focus/distraction analytics dashboard
- Add timeline visualization for focus events
- Include server health check and error handling
- Support audio indexing with language selection
- Add comprehensive documentation and setup guide"
5. Push to Your Fork
bash
git push origin add/flutter-frontend
6. Create Pull Request
Go to: https://github.com/NisargWath/VideoDB
Click "Compare & pull request"
Select base: NisargWath/VideoDB:main ← compare: your-username/VideoDB:add/flutter-frontend
Paste the PR description above
Click "Create pull request"
📋 Quick Summary for Your PR
Title:

Code
Add FocusLens Flutter Frontend - Complete Mobile & Web UI
Short Description:

Code
This PR adds a production-grade Flutter frontend for FocusLens. 
It provides a beautiful UI for uploading study videos and displaying 
real-time focus/distraction analytics with timeline visualization.
Includes cross-platform support (iOS, Android, Web, Desktop).

<img width="720" height="1640" alt="Screenshot_20260508-085733 1" src="https://github.com/user-attachments/assets/7292699c-e783-43e1-b779-7e83912a1413" />



