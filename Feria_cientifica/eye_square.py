import cv2

def detect_eyes_and_forehead(image):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
    eye_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_eye.xml')
    faces = face_cascade.detectMultiScale(gray, scaleFactor=1.3, minNeighbors=5, minSize=(30, 30))

    for (x, y, w, h) in faces:
        # Detectar ojos dentro del rostro
        roi_gray = gray[y:y+h, x:x+w]
        eyes = eye_cascade.detectMultiScale(roi_gray)
        for (ex, ey, ew, eh) in eyes:
            # Ajustar las coordenadas para mostrar solo los ojos y la frente en la pantalla
            x_offset, y_offset = 30, 40
            x_eye, y_eye = x + ex, y + ey
            x_forehead, y_forehead = x + ex + ew // 2, y + ey - eh // 2
            eye_forehead_width, eye_forehead_height = 120, 160

            # Recortar y escalar las regiones de los ojos y la frente
            eye_forehead = cv2.resize(image[y_forehead:y_forehead + eye_forehead_height,
                                            x_eye - x_offset:x_eye - x_offset + eye_forehead_width],
                                     (380, 140))

            # Mostrar la imagen en una ventana aparte
            cv2.imshow('Eyes and Forehead', eye_forehead)

    return image

def main():
    capture = cv2.VideoCapture(0)

    while True:
        ret, frame = capture.read()
        if not ret:
            break

        frame = detect_eyes_and_forehead(frame)

        cv2.imshow('Eye and Forehead Detection', frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    capture.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()
