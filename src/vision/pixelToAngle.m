function ang = pixelToAngle(pixel)
f = 452; %focal distance in 'pixels'
ang = atand(pixel/f);