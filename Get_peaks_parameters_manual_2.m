function [parameters] = Get_peaks_parameters_manual(I,vortex_point_x,vortex_point_y)
% Function will calculate the vortex quality paremeters using LG transform
% Input:
% I - image

% Output:
% parameters=[peak_to_valey, peaks_difference, proportions] 
%mean x and y peak to valley value
%mean intensity difference between peaks for both x and y direction
%mean proportion for both x and y defined as a ratio between donut's width
%and core width

%I=I./(max(I,[],'all'));
size_of_image=length(I); % Caulculate the size of an image

%% X
%Peaks
I_profile_x=I(vortex_point_x,:);

PeakProminence=0.4;
PeakHeight=0.5;
MinPeakDistance=30;
[pks,pks_locs] = findpeaks(I_profile_x,1:1:size_of_image, 'MinPeakHeight', PeakHeight, 'MinPeakProminence', PeakProminence, 'MinPeakDistance', MinPeakDistance ); % find peaks and their locations
[dip,dip_locs] = findpeaks(-I_profile_x,1:1:size_of_image, 'MinPeakProminence', PeakProminence); % find dips and their locations
dip=-dip; 

while length(pks)~= 2
try
PeakProminence=PeakProminence-0.1;
PeakHeight=PeakHeight-0.1;
[pks,pks_locs] = findpeaks(I_profile_x,1:1:size_of_image, 'MinPeakHeight', PeakHeight, 'MinPeakProminence', PeakProminence, 'MinPeakDistance', MinPeakDistance ); % find peaks and their locations
[dip,dip_locs] = findpeaks(-I_profile_x,1:1:size_of_image, 'MinPeakProminence', PeakProminence); % find dips and their locations
dip=-dip;

catch
%pks=ones(length(pks_locs));
pks=[0 0];
dip=0;
end

end

figure()
plot(I_profile_x);
hold on
plot(pks_locs,pks,'*b');
plot(dip_locs,dip,'*r');


peak_to_valley_x=abs(max(pks,[],'all')-min(dip,[],'all'));
peaks_difference_x=abs(pks(2)-pks(1));

%Diameter ratios
level=ones(size_of_image,1)*max(pks)/2;
x=1:1:size_of_image;
[x0,y0,~,~] = intersections(x,I_profile_x,x,level,'robust');
try
    
distances_x=[norm(x0(2)-x0(1)), norm(x0(3)-x0(2)), norm(x0(4)-x0(3))];
proportions_x1 =(norm(x0(3)-x0(2))/norm(x0(2)-x0(1)));
proportions_x2 =(norm(x0(3)-x0(2))/norm(x0(4)-x0(3)));

%prop_vect=[norm(x0(3)-x0(2)), norm(x0(2)-x0(1))]

proportions_x=mean([proportions_x1, proportions_x2]);

catch
distances_x=0;
proportions_x=0;
end

%% Y
%Peaks
I_profile_y=I(:,vortex_point_y);
%I_profile_y=I_profile_y./(max(I_profile_y,[],'all'));

PeakProminence=0.4;
PeakHeight=0.5;
MinPeakDistance=30;
[pks,pks_locs] = findpeaks(I_profile_y,1:1:size_of_image, 'MinPeakHeight', PeakHeight, 'MinPeakProminence', PeakProminence, 'MinPeakDistance', MinPeakDistance ); % find peaks and their locations
[dip,dip_locs] = findpeaks(-I_profile_y,1:1:size_of_image, 'MinPeakProminence', PeakProminence); % find dips and their locations
dip=-dip; 


while length(pks)~= 2
try
PeakProminence=PeakProminence-0.1;
PeakHeight=PeakHeight-0.1;
[pks,pks_locs] = findpeaks(I_profile_y,1:1:size_of_image, 'MinPeakHeight', PeakHeight, 'MinPeakProminence', PeakProminence, 'MinPeakDistance', MinPeakDistance ); % find peaks and their locations
[dip,dip_locs] = findpeaks(-I_profile_y,1:1:size_of_image, 'MinPeakProminence', PeakProminence); % find dips and their locations
dip=-dip; 

catch
pks=[0, 0];
dip=0;
end

end

figure()
plot(I_profile_y);
hold on
plot(pks_locs,pks,'*b');
plot(dip_locs,dip,'*r');

peak_to_valley_y=abs(max(pks,[],'all')-min(dip,[],'all'));
peaks_difference_y=abs(pks(2)-pks(1));

%Diameter ratios
level=ones(size_of_image,1)*max(pks)/2;
x=1:1:size_of_image;

[x0,y0,~,~] = intersections(x,I_profile_y,x,level,'robust');
try
    
distances_y=[norm(x0(2)-x0(1)), norm(x0(3)-x0(2)), norm(x0(4)-x0(3))];
proportions_y1 =(norm(x0(3)-x0(2))/norm(x0(2)-x0(1)));
proportions_y2 =(norm(x0(3)-x0(2))/norm(x0(4)-x0(3)));



proportions_y=mean([proportions_y1, proportions_y2]);
catch
distances_y=0;
proportions_y=0;
end



peak_to_valley=mean([peak_to_valley_x, peak_to_valley_y]);
peaks_difference=mean([peaks_difference_x, peaks_difference_y]);
proportions=mean([proportions_x,proportions_y]);

parameters=[peak_to_valley, peaks_difference, proportions];

end

