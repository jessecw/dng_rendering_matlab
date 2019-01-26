function dng_temperature = find_dng_temperature(xy)
% dng_temperature = find_dng_temperature(xy)
% Author: Jesse Chen

%%
kTempTable = [
%r     u           v             t
   0    0.18006  0.26352  -0.24341
  10   0.18066  0.26589  -0.25479
  20   0.18133  0.26846  -0.26876
  30   0.18208  0.27119  -0.28539
  40   0.18293  0.27407  -0.30470
  50   0.18388  0.27709  -0.32675
  60   0.18494  0.28021  -0.35156
  70   0.18611  0.28342  -0.37915
  80   0.18740  0.28668  -0.40955
  90   0.18880  0.28997  -0.44278
 100  0.19032  0.29326  -0.47888
 125  0.19462  0.30141  -0.58204
 150  0.19962  0.30921  -0.70471
 175  0.20525  0.31647  -0.84901
 200  0.21142  0.32312  -1.0182 
 225  0.21807  0.32909  -1.2168 
 250  0.22511  0.33439  -1.4512 
 275  0.23247  0.33904  -1.7298 
 300  0.24010  0.34308  -2.0637 
 325  0.24702  0.34655  -2.4681 
 350  0.25591  0.34951  -2.9641 
 375  0.26400  0.35200  -3.5814 
 400  0.27218  0.35407  -4.3633 
 425  0.28039  0.35577  -5.3762 
 450  0.28863  0.35714  -6.7262 
 475  0.29685  0.35823  -8.5955 
 500  0.30505  0.35907  -11.324 
 525  0.31320  0.35968  -15.628 
 550  0.32129  0.36011  -23.325 
 575  0.32931  0.36038  -40.770 
 600  0.33724  0.36051  -116.45     
];

%%
kTintScale = -3000.0;

x = xy(1);
y = xy(2);

u = 2.0*x / (1.5 - x + 6.0*y);
v = 3.0*y / (1.5 - x + 6.0*y);

last_dt = 0;
last_dv = 0;
last_du = 0;

for index = 2:31
		du = 1.0;
        dv = kTempTable(index, 4);
		%dv = kTempTable [index] . t;
		
		len = sqrt (1.0 + dv * dv);
		
		du = du / len;
		dv = dv / len;
		
		% Find delta from black body point to test coordinate.
		
		uu = u - kTempTable(index,  2);
		vv = v - kTempTable(index,  3);
		
		% Find distance above or below line.
		
		dt = - uu * dv + vv * du;
		
		% If below line, we have found line pair.
		if (dt <= 0.0) | (index == 31)
			
				
			% Find fractional weight of two lines.
			
			if (dt > 0.0)
				dt = 0.0;
			end
							
			dt = -dt;
						
			if (index == 2)
				f = 0.0;
            else
				f = dt / (last_dt + dt);
            end
			
			% Interpolate the temperature.
			
			dng_temperature.fTemperature = 1.0E6 / (kTempTable(index - 1, 1) * f + kTempTable(index, 1) * (1.0 - f));
								
			% Find delta from black body point to test coordinate.
			
			uu = u - (kTempTable(index - 1, 2) * f + kTempTable(index, 2) * (1.0 - f));
			vv = v - (kTempTable(index - 1, 3) * f + kTempTable(index, 3) * (1.0 - f));
			
			% Interpolate vectors along slope.
			
			du = du * (1.0 - f) + last_du * f;
			dv = dv * (1.0 - f) + last_dv * f;
			
			len = sqrt (du * du + dv * dv);
			
			du = du/len;
			dv = dv/len;

			%Find distance along slope.
			
			dng_temperature.fTint = (uu * du + vv * dv) * kTintScale;
	
            return;
			%break;
			
        end        
        
        % Try next line pair.
		last_dt = dt;
		
		last_du = du;
		last_dv = dv;    
end