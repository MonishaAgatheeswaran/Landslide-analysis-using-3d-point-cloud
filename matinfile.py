import h5py
import scipy.io as sio
import numpy as np
import math

def main():
    
    dem=sio.loadmat('dem.mat')
    (rows,cols)=np.shape(dem["dem2"])
    print(rows, cols)
    hillshade=np.zeros((rows,cols))
    for r in range(1,rows-1):
        for c in range(1,cols-1):
            temp_win=dem["dem2"][r-1:r+2,c-1:c+2]
            zew=((temp_win[0,2]+(2*temp_win[0,1])+temp_win[0,0])-(temp_win[2,2]+(2*temp_win[2,1])+temp_win[2,0]))/8
            
            zns=((temp_win[0,2]+(2*temp_win[1,2])+temp_win[2,2])-(temp_win[0,0]+(2*temp_win[1,0])+temp_win[2,0]))/8
            
            a=(0.7071*(zew+zns))/np.sqrt(2*0.7071*0.7071)
            slope_rad=math.atan(np.sqrt((zns*zns)+(zew*zew)))
            aspect_rad=math.atan2(zns,-zew)+(2*3.14)
            hs=255*((math.cos(0.7857142857)*math.cos(slope_rad))+(math.sin(0.7857142857)*math.sin(slope_rad)*math.cos(2.3578-aspect_rad)))
            hillshade[r,c]=hs
            
    sio.savemat('hillshade.mat', mdict={'hillshade': hillshade})
    
    
            
    return 
   


if __name__ == "__main__":
    main()
