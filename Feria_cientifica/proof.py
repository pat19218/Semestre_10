# Feria Científica UVG 2do Ciclo 2023
# Control de Mouse con el ojo


import cv2
import mediapipe as mp
import pyautogui
# +-+-+-+-+-+-+-+-+-+-+-+- Funciones  +-+-+-+-+-+-+-+-+-+-+-+-
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
# +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- 



cam = cv2.VideoCapture(0)
if not cam.isOpened():
    raise IOError("Cannot open webcam")

face_mesh = mp.solutions.face_mesh.FaceMesh(refine_landmarks=True)
screen_w, screen_h = pyautogui.size()

while True:
    _,frame = cam.read()

    
    
    frame = cv2.flip(frame,1)
    rgb_frame = cv2.cvtColor(frame,cv2.COLOR_BGR2RGB)
    output = face_mesh.process(rgb_frame)
    landmark_points = output.multi_face_landmarks
    frame_h,frame_w,_ = frame.shape

    # Ojo derecho
    if landmark_points:
        landmarks = landmark_points[0].landmark
        for id, landmark in enumerate(landmarks[474:478]):
            x = int(landmark.x * frame_w)
            y = int(landmark.y * frame_h)
            cv2.circle(frame, (x,y),3,(0,255,0))
            if id == 1:
                screen_x = screen_w / frame_w *x
                screen_y = screen_h / frame_h *y
                pyautogui.moveTo(screen_x,screen_y)
    
    # Ojo izquierdo        
    left = [landmarks[145], landmarks[159]]
    for landmark in left:
        x = int(landmark.x * frame_w)
        y = int(landmark.y * frame_h)
        cv2.circle(frame, (x,y),3,(0,255,255))
    print(left[0].y - left[1].x)
    
    # nariz
    nose = [landmarks[473]]
    for landmark in nose:
        x_nose = int(landmark.x * frame_w)
        y_nose = int(landmark.y * frame_h)
        cv2.circle(frame, (x_nose,y_nose),3,(0,255,255))

    # ***********************
     # Get the center coordinates of the frame
    center_x, center_y = frame.shape[1] // 2, frame.shape[0] // 2

    # Zoom factor (increase this value to zoom in)
    zoom_factor = 5 

    # Apply digital zoom to the frame
    frame = digital_zoom(frame, zoom_factor, (x_nose, y_nose))
    # ***********************
    
    """if left[0].y - left[1].x < 0.035:
        print("click")
        pyautogui.click()
        pyautogui.sleep(1)
    """
    
    cv2.imshow('Eye controlled mouse',frame)
    cv2.waitKey(1)