import cv2
import numpy as np
from apriltag import apriltag

imagepath = 'test.jpg'
image = cv2.imread(imagepath, cv2.IMREAD_GRAYSCALE)
detector = apriltag("tagStandard41h12")

detections = detector.detect(image)
"""
def main():
    capture = cv2.VideoCapture(0)

    while True:
        ret, frame = capture.read()
        if not ret:
            break

        # Get the center coordinates of the frame
        center_x, center_y = frame.shape[1] // 2, frame.shape[0] // 2

        at_detector.detect(frame)
        
        # Display the zoomed frame
        cv2.imshow('Digital Zoom', frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    capture.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()
"""
