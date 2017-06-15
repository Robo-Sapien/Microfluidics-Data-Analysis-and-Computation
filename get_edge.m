function [avg_ref_val,max_deviation,min_deviation]=get_edge(img,background_img)
%% Extracting the location of channel.
%===================================================================================%
%  NOTE BEFORE USING: "img": Y-Section image portion                                %
%===================================================================================%


% Detecting the Edge of the channel in the image.
img=img-background_img;                                       %removing background noise (CAUTION: USE THE BACKGROUNG IMAGE OF SAME PERSPECTIVE)
[m,n]=size(img);
strip_window=40;                                                                                                        %DEPEND $$$$$$$$$$$$$$$$$$ (IMPORTANT)(USER)
strip_matrix=zeros(m-2*strip_window+1,n);
for i=1:m-2*strip_window+1,
    first_strip=sum(img(i:i+strip_window-1,:),1);
    second_strip=sum(img(i+strip_window:i+2*strip_window-1,:),1);
    strip_matrix(i,:)=abs(second_strip-first_strip);
end

% Searching the coordinate position of the channel in the raw image.
observed_channel_width=190;   %giving miimum seperation apart for two maxima to choose fro the corresping edge.
max_matrix=sum(strip_matrix(:,650:750),2);                                                                              %DEPEND, (PROGRAMMER) (horizontal sum to get which row is max)
[max_m,max_n]=size(max_matrix);
max_val=0;
max_index=1;
for i=1:max_m,
    if max_matrix(i,1)>max_val,
        max_val=max_matrix(i,1);
        max_index=i;
    end
end
max_val_net=max_matrix(max_index,1);
max_index_next=max_index;
for i=1:max_m,
    if max_matrix(max_index,1)+max_matrix(i,1)>max_val_net && abs(i-max_index)>observed_channel_width,
        max_val_net=max_matrix(max_index,1)+max_matrix(i,1);
        max_index_next=i;
    end
end

if max_index>max_index_next,
    lower_limit=max_index_next+ceil(strip_window/2);
    upper_limit=max_index+ceil(strip_window/2);
else
    lower_limit=max_index+ceil(strip_window/2);
    upper_limit=max_index_next+ceil(strip_window/2);
end


%% Finding the Mixing index in the channel.

channel_length=upper_limit-lower_limit+1;

channel_start_point=420;                                                                                        % will depend on image.$$$$$$$$$$$$$$$$$$ (IMPORTANT)(USER)
division_length=9;                                                                                              % will depend on us. $$$$$$$$$$$$$$$$$$$$$ (IMPORTANT)(USER)

channel_matrix=img(lower_limit:upper_limit,channel_start_point:end);
[m,n]=size(channel_matrix);
reference_conc_matrix=img(lower_limit:upper_limit,channel_start_point-division_length:channel_start_point-1);
channel_matrix=im2double(channel_matrix,'indexed');
reference_conc_matrix=im2double(reference_conc_matrix,'indexed');

                                                                                                                                                                   
division=(n)./(division_length);
[a,b]=size(reference_conc_matrix);

%% (CASE 1) We are now taking first strip as our avg_reference (to switch uncomment CASE2)
%avg_ref_val=sum(sum(reference_conc_matrix,1),2)./(a.*b);
%temp=sqrt((sum(sum(((reference_conc_matrix-avg_ref_val).^2),1),2))./(a*b));
%max_deviation=temp;
%min_deviation=0;  

%(CASE 2)Uncomment these two simultaneously and comment all CASE 1
%avg_ref_val=125;                           % fixed reference ideal case.
%max_deviation=125;
%min_deviation=0;

%% Dividing the channel into partsof division_length each.
mixing_index=zeros(1,division);
for i=1:division,
    temp_slice=channel_matrix(:,(i-1)*division_length+1:i*division_length);
    temp=sqrt(sum(sum((((temp_slice-avg_ref_val).^2)./(division_length.*a)),1),2));
    mixing_index(1,i)=temp;
end


mixing_index=map_me(min_deviation,max_deviation,1,0,mixing_index);
                                       
plot(mixing_index);

end
