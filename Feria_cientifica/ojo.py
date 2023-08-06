import cv2
import dlib
import math
import numpy as np
import time


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

# Function to calculate Eye Aspect Ratio (EAR)
def eye_aspect_ratio(eye_landmarks):
    # Calculate the Euclidean distances between the vertical eye landmarks
    A = math.dist(eye_landmarks[1], eye_landmarks[5])
    B = math.dist(eye_landmarks[2], eye_landmarks[4])

    # Calculate the Euclidean distance between the horizontal eye landmarks
    C = math.dist(eye_landmarks[0], eye_landmarks[3])

    # Calculate the Eye Aspect Ratio (EAR)
    ear = (A + B) / (2.0 * C)

    return ear

# Initialize dlib's face detector (HOG-based) and landmark predictor
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor("shape_predictor_68_face_landmarks.dat")

# Initialize constants for EAR threshold and frame count for blink detection
EAR_THRESHOLD = 0.3
FRAME_COUNT_BLINK = 3

# Initialize variables to track eye closure duration
left_eye_closed_start = None
right_eye_closed_start = None

# Process video stream or read frames from the image
cap = cv2.VideoCapture(0)  # Replace 0 with video file path if reading from a file

while True:
    ret, frame = cap.read()
    if not ret:
        break
    
    # Get the center coordinates of the frame
    center_x, center_y = frame.shape[1] // 2, frame.shape[0] // 2

    # Zoom factor (increase this value to zoom in)
    zoom_factor = 2

    # Apply digital zoom to the frame
    frame = digital_zoom(frame, zoom_factor, (center_x, center_y))
    
    # Flip the frame horizontally for the mirror effect
    frame = cv2.flip(frame, 1)
    # Convert frame to grayscale for better face and eye detection
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # Detect faces in the grayscale frame
    faces = detector(gray)

    for face in faces:
        # Detect eye landmarks using dlib's shape predictor
        shape = predictor(gray, face)
        landmarks = np.array([(shape.part(i).x, shape.part(i).y) for i in range(36, 48)])

        # Draw landmarks on the frame and change color based on eye closure
        for i, (x, y) in enumerate(landmarks):
            if i in range(0, 6):  # Left eye landmarks
                color = (0, 255, 0) if eye_aspect_ratio(landmarks[0:6]) >= EAR_THRESHOLD else (0, 0, 255)
            else:  # Right eye landmarks
                color = (0, 255, 0) if eye_aspect_ratio(landmarks[6:12]) >= EAR_THRESHOLD else (0, 0, 255)
            cv2.circle(frame, (x, y), 1, color, -1)

        # Calculate Eye Aspect Ratio (EAR) for each eye
        left_eye_ear = eye_aspect_ratio(landmarks[0:6])
        right_eye_ear = eye_aspect_ratio(landmarks[6:12])

        # Check for eye closure based on EAR threshold
        if left_eye_ear < EAR_THRESHOLD:
            if left_eye_closed_start is None:
                left_eye_closed_start = time.time()
        else:
            if left_eye_closed_start is not None:
                # Calculate and store duration of left eye closure
                duration_left_eye_closed = time.time() - left_eye_closed_start
                left_eye_closed_start = None
                if duration_left_eye_closed >= FRAME_COUNT_BLINK / 2:
                    print("Left Eye Closed Duration:", duration_left_eye_closed)

        if right_eye_ear < EAR_THRESHOLD:
            if right_eye_closed_start is None:
                right_eye_closed_start = time.time()
        else:
            if right_eye_closed_start is not None:
                # Calculate and store duration of right eye closure
                duration_right_eye_closed = time.time() - right_eye_closed_start
                right_eye_closed_start = None
                if duration_right_eye_closed >= FRAME_COUNT_BLINK / 2:
                    print("         Right Eye Closed Duration:", duration_right_eye_closed)

    
    # Display the flipped frame with detected eyes and face
    cv2.imshow("Mirror Effect with Eye Landmarks", frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
