function [max_deviation,min_deviation]=get_deviaiton(water_pixel_value,rhodomine_pixel_value,mixed_pixel_value)
min_deviation=0;
max_deviation=sqrt(((rhodomine_pixel_value-mixed_pixel_value).^2+(water_pixel_value-mixed_pixel_value).^2)./2);
end
