%% Extracting the location of channel.
function mixing_index(avg_ref_val,max_deviation,min_deviation,img,background_img)
%===================================================================================%
%  NOTE BEFORE USING: "img": is last section image of outlet                        %
%===================================================================================%

% Detecting the Edge of the channel in the image.
img=img-background_img;
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

%% Extracting channel and finding mixing index

channel_matrix=im2double(img(lower_limit:upper_limit,:),'indexed');
division_length=8;  %cuz of factor of 2048                                                                                        %DEPEND
division=2048./division_length;
[a,~]=size(channel_matrix);

%% Dividing the channel into partsof division_length each.
mixing_index=zeros(1,division);
for i=1:division,
    temp_slice=channel_matrix(:,(i-1)*division_length+1:i*division_length);
    temp=sqrt(sum(sum((((temp_slice-avg_ref_val).^2)./(division_length.*a)),1),2));
    mixing_index(1,i)=temp;
end


mixing_index=map_me(min_deviation,max_deviation,1,0,mixing_index);

plot(mixing_index);
