import cv2
import dlib
import imutils

capture = cv2.VideoCapture(0)

#Detector facial
face_detector = dlib.get_frontal_face_detector()
#Predictor de 68 puntos de referencia, debe estar en la misma carpeta
predictor = dlib.shape_predictor("shape_predictor_68_face_landmarks.dat")


while True:
    ret, frame = capture.read()
    
    if ret == False:
        break
    """
    En tal caso el frame sea demasiado grande se redimenciona con:
    frame = imutils.resize(frame, width=720)
    """
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    
    #se detecta los rostros, 1 es para detectar varios rostros
    coordinates_boxes = face_detector(gray, 1)
    #print("coordinates_boxes: ", coordinates_boxes)
    for c in coordinates_boxes:
        x_init, y_init, x_fin, y_fin = c.left(), c.top(), c.right(), c.bottom()
        cv2.rectangle(frame, (x_init,y_init), (x_fin, y_fin), (0,255,0), 1)
        
        shape = predictor(gray, c)    
        for i in range (0, 68):
            x, y = shape.part(i).x, shape.part(i).y
            cv2.circle(frame, (x,y), 2, (255,0,0), -1)
            cv2.putText(frame, str(i + 1), (x, y -5), 1, 0.8, (0, 255, 255), 1)
        
    cv2.imshow("Frame", frame)
    
    if cv2.waitKey(1) == 27 & 0xFF:
        break
    
capture.release()
cv2.destroyAllWindows()