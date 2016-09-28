Directory for vision code.

[dist, angle, status, ball, robot] = findDistanceAngle(cam, camHeight, ballCol, robCol)
is the main function.

Parameters:
cam: camera object to use
camHeight: mounting height of camera, in meters
ballCol: RGB value approximating ball. [R G B]
robCol: RGB value approximating robot marker. [R G B]

Returns:

dist: Distance between robot and ball, in meters.
angle: angle between robot and ball, in meters.
status: debug messages for vision system, string
ball: vector to ball position, in meters
robot: vector to robot position in meters