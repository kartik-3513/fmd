# Face Mask Detector
An android application using flutter for detecting facemask. It uses a tiny version of the image classification model that runs on mobile itself. Detection is real-time in nature.

Course: Computer Hardware and Software

Technologies: Computer Vision, Machine Learning, Flutter, Tensorflow Lite, Google Teachable Machine

![App screenshot](./assets/app.jpg?raw=true)

### Dataset and Model
The model was trained on 2000 images. Dataset can be found [here](https://github.com/NVlabs/ffhq-dataset). The trained model was then converted using the TFLITE library. It takes input frames from camera feed,
runs a tiny model and outputs two classes, mask present and absent.

### Flutter Android Application
The mobile application supports front and back cameras. The user can start and stop detection. The camera sends the feed to the model. Model runs on the mobile itself and then classification is done. We have set a threshold on the class confidence scores as 0.9 for clear distinction.

### Conclusion
Detection is real-time. Processing and classification is done in approximately 200 milliseconds. This is ideal for both demonstration purposes, though in practice, slower processing might be acceptable as well.
Specialized hardware can be used for practical implementation and installation of detection systems. With optimized processing, this can be very well used in public places.

### Installation
Visit [flutter](https://flutter.dev/) official docs for installation guidelines.