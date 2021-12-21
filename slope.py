import h5py
import scipy.io as sio
import numpy as np
filepath = 'dod.mat'
arrays = {}

def main():
    
    dem=sio.loadmat('dem.mat')
    (rows,cols)=np.shape(dem["dem2"])
    slope=np.zeros((rows,cols))
    for r in range(1,rows-1):
        for c in range(1,cols-1):
            temp_win=dem["dem2"][r-1:r+2,c-1:c+2]
            mid= temp_win[1,1]
            max_d=temp_win[0,0]
            if max_d<temp_win[0,2]:
                max_d=temp_win[0,2]
            if max_d<temp_win[2,0]:
                max_d=temp_win[2,0]
            if max_d<temp_win[2,2]:
                max_d=temp_win[2,2]
            max_1=temp_win[1,0]
            if max_1<temp_win[1,2]:
                max_1=temp_win[1,2]
            if max_1<temp_win[0,1]:
                max_1=temp_win[0,1]
            if max_1<temp_win[2,1]:
                max_1=temp_win[2,1]
            slope_d=np.abs(mid-max_d)/np.sqrt(2)
            slope_1=np.abs(mid-max_1)/np.sqrt(2)
            if slope_d>slope_1:
                slope[r,c]=slope_d
            else:
                slope[r,c]=slope_1
    sio.savemat('slope.mat', mdict={'slope': slope})
    
    return 
   


if __name__ == "__main__":
    main()
 