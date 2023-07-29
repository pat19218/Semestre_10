import cv2
import numpy as np

def detect_pupil(frame):
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    gray = cv2.GaussianBlur(gray, (9, 9), 2, 2)

    # Detección de círculos (pupilas) utilizando la transformada de Hough
    circles = cv2.HoughCircles(gray, cv2.HOUGH_GRADIENT, dp=1, minDist=50, param1=200, param2=30, minRadius=5, maxRadius=30)

    if circles is not None:
        circles = np.round(circles[0, :]).astype("int")
        for (x, y, r) in circles:
            # Dibujar el círculo (pupila) y el centro en la imagen
            cv2.circle(frame, (x, y), r, (0, 255, 0), 4)
            cv2.rectangle(frame, (x - 5, y - 5), (x + 5, y + 5), (0, 128, 255), -1)

            # Calcular la dirección en función del centro del ojo
            horizontal_direction = "Mirando al centro"
            vertical_direction = "Mirando al centro"

            if x < frame.shape[1] // 3:
                horizontal_direction = "Mira hacia la izquierda"
            elif x > frame.shape[1] * 2 // 3:
                horizontal_direction = "Mira hacia la derecha"

            if y < frame.shape[0] // 3:
                vertical_direction = "Mira hacia arriba"
            elif y > frame.shape[0] * 2 // 3:
                vertical_direction = "Mira hacia abajo"

            # Mostrar la dirección en la imagen
            cv2.putText(frame, horizontal_direction, (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
            cv2.putText(frame, vertical_direction, (10, 70), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)

    return frame

def main():
    capture = cv2.VideoCapture(0)

    while True:
        ret, frame = capture.read()
        if not ret:
            break

        frame = detect_pupil(frame)

        cv2.imshow('Eye Tracking', frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    capture.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()
