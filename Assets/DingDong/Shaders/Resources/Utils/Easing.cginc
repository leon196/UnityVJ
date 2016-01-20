// http://gizma.com/easing/

float easeOutQuint (float t, float b, float c, float d) {
	t /= d;
	t--;
	return c*(t*t*t*t*t + 1) + b;
}

float easeInOutSine (float t, float b, float c, float d) {
	return -c/2 * (cos(3.141592653589*t/d) - 1) + b;
}

float easeOutCirc (float t, float b, float c, float d) {
	t /= d;
	t--;
	return c * sqrt(1 - t*t) + b;
}

float easeInExpo (float t, float b, float c, float d) {
	return c * pow( 2.0, 10.0 * (t/d - 1.0) ) + b;
}