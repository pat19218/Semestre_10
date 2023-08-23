# Feria Científica UVG 2do Ciclo 2023
# Control de Mouse con el ojo


import cv2
import mediapipe as mp
import pyautogui
import numpy as np
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



def main():
    x_nose = 0
    y_nose = 0
    
    zoom_center = None
    
    screen_x = 0
    screen_y = 0
    screen_x_last = 0
    screen_y_last = 0
    
    x_mouse = int(200)
    y_mouse = int(200)
    
    mp_face_detection = mp.solutions.face_detection
    #mp_drawing = mp.solutions.drawing_utils
    face_detection = mp_face_detection.FaceDetection(min_detection_confidence=0.5)

    
    # Zoom factor (increase this value to zoom in)
    zoom_factor = 5.0 
            
    cam = cv2.VideoCapture(0)
    if not cam.isOpened():
        raise IOError("Cannot open webcam")

    
    face_mesh = mp.solutions.face_mesh.FaceMesh(refine_landmarks=True)
    screen_w, screen_h = pyautogui.size()   

    while True:
        _,frame = cam.read()
        frame = cv2.flip(frame,1)
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
                
                frame= digital_zoom(frame, zoom_factor, zoom_center)
                
                #cv2.rectangle(frame, bbox, (0, 255, 0), 2)

        
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
                #print("this is x: ",x)
                #print("this is y: ",y)
                cv2.circle(frame, (x,y),int(3/zoom_factor),(0,255,0))
                
                if id == 1:
                    screen_x = screen_w / frame_w *x
                    screen_y = screen_h / frame_h *y
                    print("                             ", screen_w)
                    #pyautogui.moveTo(screen_x,screen_y)
                    diffx = abs(screen_x-screen_x_last) > 20
                    diffy = abs(screen_y-screen_y_last) > 20
                    print("en x: ", screen_x-screen_x_last)
                    print("             en y: ", screen_y-screen_y_last)
                    #time.sleep(0.5)
                    if diffx:
                        if ((screen_x - screen_x_last) < 0) and (x_mouse < (screen_w - 30)):
                            x_mouse = int(x_mouse + 30)  #se movio derecha
                        elif x_mouse > 10:
                            x_mouse = int(x_mouse - 30)  #se movio izquierda
                    """if diffy:
                        if (screen_y - screen_y_last) < 0:
                            y_mouse = y_mouse + 10
                        else:
                            y_mouse = y_mouse - 10
                       """ 
                    if  diffx or diffy:                            
                        pyautogui.moveTo(x_mouse,y_mouse)
                        
                        screen_x_last = screen_x
                        screen_y_last = screen_y
                        
        
        # Ojo izquierdo        
        left = [landmarks[145], landmarks[159]]
        for landmark in left:
            x = int(landmark.x * frame_w)
            y = int(landmark.y * frame_h)
            cv2.circle(frame, (x,y),int(3/zoom_factor),(0,255,255))
        #print(left[0].y - left[1].x)
        
        # nariz
        nose = [landmarks[8]] #473
        for landmark in nose:
            x_nose = int(landmark.x * frame_w)
            y_nose = int(landmark.y * frame_h)
            cv2.circle(frame, (x_nose,y_nose),int(3/zoom_factor),(0,255,255))
        
        #union parpado
        par = [landmarks[353]] 
        for landmark in par:
            x_par = int(landmark.x * frame_w)
            y_par = int(landmark.y * frame_h)
            cv2.circle(frame, (x_par,y_par),int(3/zoom_factor),(0,255,255))
        # ***********************
        # Get the center coordinates of the frame
        center_x, center_y = frame.shape[1] // 2, frame.shape[0] // 2

        # Apply digital zoom to the frame
        #try:
        #    frame = digital_zoom(frame, zoom_factor, (x_nose, y_nose))
        #except:
        #    frame = digital_zoom(frame, zoom_factor, (center_x, center_y))
        # ***********************
        
        if left[0].y - left[1].x < 0.035:
            print("click")
            #pyautogui.click()
            #pyautogui.sleep(1)
        
        
        cv2.imshow('Eye controlled mouse',frame)
        #cv2.waitKey(1)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cam.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()
