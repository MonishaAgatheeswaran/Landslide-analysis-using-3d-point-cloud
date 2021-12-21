import h5py
import scipy.io as sio
import numpy as np


def main():
    
    dem=sio.loadmat('dem.mat')
    (rows,cols)=np.shape(dem["dem2"])
    print(rows, cols)
    roughness=np.zeros((rows,cols))
    for r in range(1,rows-1):
        for c in range(1,cols-1):
            temp_win=dem["dem2"][r-1:r+2,c-1:c+2]
            rough=abs(temp_win[1,1]-temp_win[0,0])
            if rough<abs(temp_win[1,1]-temp_win[0,1]):
                rough=abs(temp_win[1,1]-temp_win[0,1])
            if rough<abs(temp_win[1,1]-temp_win[0,2]):
                rough=abs(temp_win[1,1]-temp_win[0,2])
            if rough<abs(temp_win[1,1]-temp_win[1,0]):
                rough=abs(temp_win[1,1]-temp_win[1,0])
            if rough<abs(temp_win[1,1]-temp_win[1,2]):
                rough=abs(temp_win[1,1]-temp_win[1,2])
            if rough<abs(temp_win[1,1]-temp_win[2,0]):
                rough=abs(temp_win[1,1]-temp_win[2,0])
            if rough<abs(temp_win[1,1]-temp_win[2,1]):
                rough=abs(temp_win[1,1]-temp_win[2,1])
            if rough<abs(temp_win[1,1]-temp_win[2,2]):
                rough=abs(temp_win[1,1]-temp_win[2,2])
            roughness[r,c]=rough
   
            
    sio.savemat('roughness.mat', mdict={'roughness': roughness})
    
    
            
    return 
   


if __name__ == "__main__":
    main()
