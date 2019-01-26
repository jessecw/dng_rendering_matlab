//
//  dng_RGBtoHSV.c
//  
//
//  Created by JesseChen on 15-8-23.
//
//  The syntax is:
//  out_img = dng_RGBtoHSV(in_img)
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

/******************************************************************************/
// Converts from RGB values (range 0.0 to 1.0) to HSV values (range 0.0 to
// 6.0 for hue, and 0.0 to 1.0 for saturation and value).
static void inline_DNG_RGBtoHSV (float r, float g,float b,
					      float *ptr_h,float *ptr_s, float *ptr_v)
{
	float h, s, v, gap;
    
	v = Max_real32 (r, Max_real32 (g, b));

	gap = v - Min_real32 (r, Min_real32 (g, b));
	
	if (gap > 0.0f) {
		if (r == v) {
			h = (g - b) / gap;
			
			if (h < 0.0f){
				h += 6.0f;
			}		
		} else if (g == v) {
			h = 2.0f + (b - r) / gap;
		} else {
			h = 4.0f + (r - g) / gap;
		}
			
		s = gap / v;
	} else {
		h = 0.0f;
		s = 0.0f;
	}
    
    *ptr_h = h;
    *ptr_s = s;
    *ptr_v = v;
}


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    mxClassID in_param_category;
    double *pInputImg;
    double *pOutputImg;
    double *pInputR, *pInputG, *pInputB;
    double *pOutput_h, *pOutput_s, *pOutput_v;
    float r, g, b, hh, ss, vv;
    mwSize input_img_dims;
    const mwSize *input_img_dims_array;
    int i, num_pix_elements, h, w;
    
    if (nrhs != 1){
        mexErrMsgIdAndTxt("Matlab:dng_rendering_acr3_tone_mapping:the input parameters are not correct",
                          "out_img = dng_rendering_acr3_tone_mapping(in_img)");
        return;
    }
    
    in_param_category = mxGetClassID(prhs[0]);
    if (in_param_category != mxDOUBLE_CLASS){
        mexErrMsgIdAndTxt("Matlab:dng_rendering_acr3_tone_mapping:the input image's data type should be double",
                          "double type input image required.");
    } else {
        pInputImg = (double *)mxGetData(prhs[0]);
        input_img_dims = mxGetNumberOfDimensions(prhs[0]);
        mexPrintf("Image has %d dimensions\n", input_img_dims);
        if (input_img_dims != 3){
            mexErrMsgIdAndTxt("Matlab:dng_rendering_acr3_tone_mapping:the input image should be a three-channel image", "three-channel image required.");
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
        pInputR = pInputImg;
        pInputG = pInputR + h*w;
        pInputB = pInputG + h*w;
        pOutput_h = pOutputImg;
        pOutput_s = pOutput_h + h*w;
        pOutput_v = pOutput_s + h*w;

        for (i = 0; i < h*w; i++){
            r = (float)*pInputR;
            g = (float)*pInputG;
            b = (float)*pInputB;

            inline_DNG_RGBtoHSV(r, g, b, &hh, &ss, &vv);
            
            *pOutput_h = (double)hh;
            *pOutput_s = (double)ss;
            *pOutput_v = (double)vv;
            
            pInputR++;
            pInputG++;
            pInputB++;
            pOutput_h++;
            pOutput_s++;
            pOutput_v++;
        }

        plhs[0] = mxCreateNumericMatrix(0, 0, mxDOUBLE_CLASS, mxREAL);
        mxSetData(plhs[0], (void *)pOutputImg);
        
        mxSetDimensions(plhs[0], input_img_dims_array, input_img_dims);
        
    }
}