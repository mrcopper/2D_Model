r=[0:.1:1];
gauss=exp(-r.*r);
phi=[0:pi/10:2*pi];
[Phi,R]=meshgrid(phi,r);
[X,Y]=pol2cart(Phi,R);

Z=X+1i*Y;
f=0*Z;
figure 
surf(X,Y,abs(f))
hold
x=[-1:.01:1];
z=exp(-(5.0.*(x-0.5)).^2);
y=x.*0;
plot3(x,y,z)