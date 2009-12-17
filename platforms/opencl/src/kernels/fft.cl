float2 multiplyComplex(float2 c1, float2 c2) {
    return (float2) (c1.x*c2.x-c1.y*c2.y, c1.x*c2.y+c1.y*c2.x);
}

/**
 * Perform a 1D FFT on each row along one axis.
 */

__kernel void execFFT(__global float2* matrix, float sign, __local float2* w, __local float2* data0, __local float2* data1) {
    const int i = get_local_id(0);
    w[i] = (float2) (cos(-sign*i*2*M_PI/XSIZE), sin(-sign*i*2*M_PI/XSIZE));
    int index = get_group_id(0);
    while (index < YSIZE*ZSIZE) {
        int z = index/YSIZE;
        int y = index-z*YSIZE;
        int element = i*XMULT+y*YMULT+z*ZMULT;
        data0[i] = matrix[element];
        barrier(CLK_LOCAL_MEM_FENCE);
        COMPUTE_FFT
        index += get_num_groups(0);
    }
}
