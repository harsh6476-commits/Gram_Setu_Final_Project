@echo off
echo 🚀 Starting Gram Setu Backend and Public Tunnel...
cd backend

:: Start the backend server in a new window
start "Gram Setu Backend" cmd /k "npm run dev"

:: Wait 3 seconds to let the server start
timeout /t 3 /nobreak >nul

:: Start the tunnel in a new window
start "Gram Setu Public Tunnel" cmd /k "npm run tunnel"

echo.
echo ==============================================================
echo ✅ Both Backend and Tunnel are starting!
echo.
echo ⚠️  IMPORTANT NEXT STEPS:
echo 1. Look at the "Gram Setu Public Tunnel" window.
echo 2. Copy the URL it gives you (e.g. https://your-url.loca.lt).
echo 3. Paste that URL into lib/core/constants.dart as 'tunnelUrl'.
echo 4. OPEN THAT URL ON YOUR PHONE'S BROWSER FIRST.
echo 5. Click the blue "Click to Continue" button to bypass security.
echo 6. Run your Flutter app!
echo ==============================================================
echo.
pause
