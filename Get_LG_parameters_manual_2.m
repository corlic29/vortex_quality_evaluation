function [parameters] = Get_LG_parameters_manual(I,vortex_point_x,vortex_point_y)
% Function will calculate the vortex quality paremeters using LG transform
% Input:
% I - image
% vortex_point_x/y - positions of the vortex point

% Output:
% parameters=[eccentricity];

size_of_image=max(size(I)); % Calculate the size of an image

%% L-G

maximum_value = max(I,[],'all');
[x,y]=find(I==maximum_value);
x=mean(x);
y=mean(y);
core_diameter=norm([vortex_point_x,vortex_point_y]-[x,y]);
w=core_diameter;

pX=size_of_image;
pY=size_of_image;

vector_x=-1:2/(pX-1):1;
vector_y= -1:2/(pY-1):1;
[X, Y]=meshgrid(vector_x, vector_y);


[alpha, r]=cart2pol(X, Y); %Polarne

%LG function
LG = (1i*pi.^2*w.^4).*(r.*exp(-pi.^.2*r.^2*w.^2).*exp(1i.*alpha));



%% L_G

crop_percentage=0.1; %Defines the percentage of imcrop


 % Load and crop
    im=imcrop(I,[0+round(crop_percentage*pX), 0+round(crop_percentage*pX), pX-2*round(crop_percentage*pX),  pX-2*round(crop_percentage*pX)]);
    
    
    im=imadjust(im);
    
    H = fspecial('disk',2); 
    im = imfilter(im,H,'replicate');

    
    %Pseudo-complex amplitude  
    im_complex=conv2(im,LG,'same');
    im_complex_II=im_complex.*conj(im_complex);
   
    real_im=real(im_complex);
    imag_im=imag(im_complex);
    
    %Surface approximation
    [length, ~]=size(im_complex_II);
    xx1=linspace(1,length,length);
    yy1=linspace(1,length,length);
    
    %Real
    [Xr1, Yr1, Zr1] = prepareSurfaceData(xx1, yy1, real_im);% przygotowanie macierzy do fitting
    sf_r1=fit([Xr1,Yr1],Zr1,'poly11');
    cr1=sf_r1.p00;
    ar1=sf_r1.p10;
    br1=sf_r1.p01;
    
    %Imaginary
    [Xi1, Yi1, Zi1] = prepareSurfaceData(xx1, yy1, imag_im);
    sf_i1=fit([Xi1,Yi1],Zi1,'poly11');
    ci1=sf_i1.p00;
    ai1=sf_i1.p10;
    bi1=sf_i1.p01;
    
    %Eccentricity
    pome1=ar1^2+ai1^2+br1^2+bi1^2;
    pome2=sqrt((ar1^2+ai1^2-br1^2-bi1^2)^2+4*(ar1*br1+ai1*bi1)^2);
    
    eccentricity=sqrt(1-(pome1-pome2)/(pome1+pome2));
     
    parameters=[eccentricity];


end

