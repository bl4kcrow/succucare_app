/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {setGlobalOptions} from "firebase-functions";
import {onRequest} from "firebase-functions/https";
import * as logger from "firebase-functions/logger";

import {onDocumentCreated,
  onDocumentUpdated} from "firebase-functions/v2/firestore";
import {Timestamp} from "firebase-admin/firestore";
import * as admin from "firebase-admin";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({maxInstances: 10});

export const helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

// SDK Firebase Admin initialization (one time)
if (admin.apps.length === 0) {
  admin.initializeApp();
}

interface moisture {
  level: "low" | "medium" | "high";
  source: "manual" | "sensor" | "inferred";
}

interface plantDoc {
  commonName: string;
  category: string;
  lastWateredAt: Timestamp;
  nextWateringAt: Timestamp;
  primaryPhotoUrl: string;
  moisture: moisture;
}

export const onNextWateringAtCreated = onDocumentCreated(
  {
    document: "users/{userId}/plants/{plantId}",
    region: "us-central1",
  },
  async (event) => {
    const newData = event.data?.data() as plantDoc;

    if (!newData) {
      logger.log("Not found data");
      return null;
    }

    const userDoc = admin.firestore()
      .collection("users")
      .doc(event.params.userId);
    const userSnap = await userDoc.get();
    if (!userSnap.exists) {
      logger.warn(`User ${event.params.userId} doesn't exist`);
      return;
    }
    const userData = userSnap.data();
    const fcmToken = userData?.notificationsToken;

    if (!fcmToken) {
      logger.warn(`Token FCM not found for user: ${event.params.userId}`);
      return null;
    }

    // Push notification payload
    const message: admin.messaging.Message = {
      token: fcmToken,
      notification: {
        title: newData.commonName,
        body: "Tiempo de riego",
        imageUrl: newData.primaryPhotoUrl,
      },
      // Additional notification data
      data: {
        moisture: newData.moisture.level,
        plantId: event.params.plantId,
      },
      // Settins specific for Android
      android: {
        notification: {
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
          sound: "default",
        },
      },
    };

    // Send push notification
    try {
      const response = await admin.messaging().send(message);
      logger.log(`Push notification. ID del mensaje: ${response}`);
    } catch (error) {
      logger.error("Push notification error:", error);
    }

    return null;
  });

export const onNextWateringAtChanges = onDocumentUpdated(
  {
    document: "users/{userId}/plants/{plantId}",
    region: "us-central1",
  },
  async (event) => {
    const previousData = event.data?.before.data() as plantDoc;
    const afterData = event.data?.after.data() as plantDoc;

    if (!previousData || !afterData) {
      logger.log("Not found data");
      return null;
    }

    if (previousData.nextWateringAt !== afterData.nextWateringAt) {
      logger.log("The field nextWateringAt has changed.");

      const userDoc = admin.firestore()
        .collection("users")
        .doc(event.params.userId);
      const userSnap = await userDoc.get();
      if (!userSnap.exists) {
        logger.warn(`User ${event.params.userId} doesn't exist`);
        return;
      }
      const userData = userSnap.data();
      const fcmToken = userData?.notificationsToken;

      if (!fcmToken) {
        logger.warn(`Token FCM not found for user: ${event.params.userId}`);
        return null;
      }

      // Push notification payload
      const message: admin.messaging.Message = {
        token: fcmToken,
        notification: {
          title: afterData.commonName,
          body: "Tiempo de riego",
          imageUrl: afterData.primaryPhotoUrl,
        },
        // Additional notification data
        data: {
          moisture: afterData.moisture.level,
          plantId: event.params.plantId,
        },
        // Settins specific for Android
        android: {
          notification: {
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
            sound: "default",
          },
        },
      };

      // Send push notification
      try {
        const response = await admin.messaging().send(message);
        logger.log(`Push notification. ID del mensaje: ${response}`);
      } catch (error) {
        logger.error("Push notification error:", error);
      }
    } else {
      logger.log("The field nextWateringAt has NOT change.");
    }

    return null;
  });
