import cv2
import mediapipe as mp
import numpy as np

def digital_zoom(frame, zoom_factor, zoom_center):
    h, w = frame.shape[:2]
    x, y = zoom_center

    # Calculate the new width and height based on the zoom factor
    new_w = int(w / zoom_factor)
    new_h = int(h / zoom_factor)

    # Define the region of interest (ROI) for zooming
    x1 = max(0, x - new_w // 2)
    y1 = max(0, y - new_h // 2)
    x2 = min(w, x + new_w // 2)
    y2 = min(h, y + new_h // 2)

    # Zoom in on the ROI
    zoomed_frame = frame[y1:y2, x1:x2]

    # Resize the zoomed frame to the original frame size
    zoomed_frame = cv2.resize(zoomed_frame, (w, h))

    return zoomed_frame

mp_face_detection = mp.solutions.face_detection
mp_drawing = mp.solutions.drawing_utils
face_detection = mp_face_detection.FaceDetection(min_detection_confidence=0.5)

cap = cv2.VideoCapture(0)

zoom_factor = 3.5
zoom_center = None

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        continue

    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = face_detection.process(rgb_frame)

    if results.detections:
        for detection in results.detections:
            bboxC = detection.location_data.relative_bounding_box
            ih, iw, _ = frame.shape
            bbox = int(bboxC.xmin * iw), int(bboxC.ymin * ih), \
                   int(bboxC.width * iw), int(bboxC.height * ih)
            
            new_zoom_center = (bbox[0] + bbox[2] // 2, bbox[1] + bbox[3] // 2)
            
            if zoom_center is None or np.linalg.norm(np.array(new_zoom_center) - np.array(zoom_center)) >= 20:
                zoom_center = new_zoom_center
            
            zoomed_frame = digital_zoom(frame, zoom_factor, zoom_center)
            
            cv2.rectangle(frame, bbox, (0, 255, 0), 2)

    cv2.imshow('Stabilized Face Detection with Zoom', zoomed_frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
