a=1.0;

theta0=pi/2.0;
dtheta=pi/128.0;
theta=0:dtheta:theta0

func=exp(-a*theta(:).*theta(:)).*(cos(theta(:)).^7.0)

riemann=dtheta*sum(func)

n=0:1:3;

integrand = ((1.0/2.0*a)*pi^.5 * factorial(7) * .5^6 * (exp(-((2*n(:)+1).*(2*n(:)+1)/(4.0.*a.^2)))./(factorial(n(:)).*factorial(7-n(:)))))
integral = sum(integrand)