function dx = Runge_Kutta(x,F)

M = 2;
L = 1;
g = 10;
k = 1;

sin_theta1 = sin(x(1,1));
sin_theta2 = sin(x(3,1));
cos_theta1 = cos(x(1,1));
cos_theta2 = cos(x(3,1));

dx(1,1) = x(2,1);
dx(3,1) = x(4,1);
dx(2,1) = (F - M*g*L*sin_theta1 - (1/4)*k*L^2*(sin_theta1 - sin_theta2)*cos_theta1) / (M*L^2);
dx(4,1) = (- M*g*L*sin_theta2 + (1/4)*k*L^2*(sin_theta1 - sin_theta2)*cos_theta2) / (M*L^2);

end