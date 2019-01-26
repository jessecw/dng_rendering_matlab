//  dng_HSVtoRGB.c
//  
//
//  Created by JesseChen on 15-8-23.
//
//  The syntax is:
//  out_img = dng_HSVtoRGB(in_img)
//

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "matrix.h"
#include "mex.h"

static float Max_real32 (float x, float y)
{	
    return (x > y ? x : y);
}

static float Min_real32(float x, float y)
{	
	return (x < y ? x : y);
}

/*****************************************************************************/
// Converts from HSV values (range 0.0 to 6.0 for hue, and 0.0 to 1.0 for
// saturation and value) to RGB values (range 0.0 to 1.0).
static void inline_DNG_HSVtoRGB (float h, float s,float v,
					      float *ptr_r,float *ptr_g, float *ptr_b)
{
    int i;
    float f, p;
    float r, g, b;
    
	if (s > 0.0f){
		if (h < 0.0f)
			h += 6.0f;
			
		if (h >= 6.0f)
			h -= 6.0f;
			
		i = (int)h;
		f = h - (float)i;
		
		p = v * (1.0f - s);
		
		#define q	(v * (1.0f - s * f))
		#define t	(v * (1.0f - s * (1.0f - f)))
		
		switch (i){
			case 0: r = v; g = t; b = p; break;
			case 1: r = q; g = v; b = p; break;
			case 2: r = p; g = v; b = t; break;
			case 3: r = p; g = q; b = v; break;
			case 4: r = t; g = p; b = v; break;
			case 5: r = v; g = p; b = q; break;
		}
			
		#undef q
		#undef t
	} else {
		r = v;
		g = v;
		b = v;
	}
    
    *ptr_r = (double)r;
    *ptr_g = (double)g;
    *ptr_b = (double)b;
}


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    mxClassID in_param_category;
    double *pInputImg;
    double *pOutputImg;
    double *pOutputR, *pOutputG, *pOutputB;
    double *pInput_h, *pInput_s, *pInput_v;
    float r, g, b, hh, ss, vv;
    mwSize input_img_dims;
    const mwSize *input_img_dims_array;
    int i, num_pix_elements, h, w;
    
    if (nrhs != 1){
        mexErrMsgIdAndTxt("Matlab:dng_HSVtoRGB:the input parameters are not correct",
                          "out_img = dng_rendering_acr3_tone_mapping(in_img)");
        return;
    }
    
    in_param_category = mxGetClassID(prhs[0]);
    if (in_param_category != mxDOUBLE_CLASS){
        mexErrMsgIdAndTxt("Matlab:dng_HSVtoRGB:the input image's data type should be double",
                          "double type input image required.");
    } else {
        pInputImg = (double *)mxGetData(prhs[0]);
        input_img_dims = mxGetNumberOfDimensions(prhs[0]);
        mexPrintf("Image has %d dimensions\n", input_img_dims);
        if (input_img_dims != 3){
            mexErrMsgIdAndTxt("Matlab:dng_HSVtoRGB:the input image should be a three-channel image", "three-channel image required.");
            return;
        }
        
        input_img_dims_array = mxGetDimensions(prhs[0]);
        for (i = 0; i < input_img_dims; i++){
            mexPrintf("Image's dim[%d] = %d\n", i, input_img_dims_array[i]);
        }
        h = input_img_dims_array[0];
        w = input_img_dims_array[1];
        
        num_pix_elements = (int)mxGetNumberOfElements(prhs[0]);
        mexPrintf("Image's size = %d\n", num_pix_elements);
        
        pOutputImg = (double *)mxCalloc(num_pix_elements, sizeof(double));
        
        // memcpy(pOutputImg, pInputImg, num_pix_elements * sizeof(double));
        pOutputR = pOutputImg;
        pOutputG = pOutputR + h*w;
        pOutputB = pOutputG + h*w;
        pInput_h = pInputImg;
        pInput_s = pInput_h + h*w;
        pInput_v = pInput_s + h*w;

        for (i = 0; i < h*w; i++){
            hh = (float)*pInput_h;
            ss = (float)*pInput_s;
            vv = (float)*pInput_v;

            inline_DNG_HSVtoRGB(hh, ss, vv, &r, &g, &b);
            
            *pOutputR = (double)r;
            *pOutputG = (double)g;
            *pOutputB = (double)b;
            
            pInput_h++;
            pInput_s++;
            pInput_v++;
            pOutputR++;
            pOutputG++;
            pOutputB++;
        }

        plhs[0] = mxCreateNumericMatrix(0, 0, mxDOUBLE_CLASS, mxREAL);
        mxSetData(plhs[0], (void *)pOutputImg);
        
        mxSetDimensions(plhs[0], input_img_dims_array, input_img_dims);
        
    }
}