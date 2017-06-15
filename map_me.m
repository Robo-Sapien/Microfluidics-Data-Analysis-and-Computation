function mapped_val=map_me(from_low,from_high,to_low,to_high,val)

slope=(val-from_low)./(from_high-from_low);
mapped_val=to_low+slope.*(to_high-to_low);

end