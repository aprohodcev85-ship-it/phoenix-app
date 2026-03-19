importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyAn8YH1iu6rzIvqo-5YPK53oknfShAg-7c",           // ← Замени на свой
  authDomain: "phoenix-logistics.firebaseapp.com",
  projectId: "phoenix-logistics-710ad",
  storageBucket: "phoenix-logistics-710ad.firebasestorage.app",
  messagingSenderId: "1234567890",
  appId: "1:834086078158:android:c21fabd4e52faf7d86f29f"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('Background message received:', payload);
  
  const notificationTitle = payload.notification?.title || 'Phoenix';
  const notificationOptions = {
    body: payload.notification?.body || 'Новое уведомление',
    icon: '/icons/Icon-192.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});