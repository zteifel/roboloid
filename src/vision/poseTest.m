clear camobj;

camobj = webcam(2);

im = snapshot(camobj);

pose = estimateCameraPose(im);

clear camobj