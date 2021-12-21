import h5py
import scipy.io as sio
import numpy as np
filepath = 'dod.mat'
arrays = {}

def main():
    
    A=sio.loadmat('dod.mat')
    
    
    volume=0;
    
    for i in range(0,len(A["dod"])):
        for j in range(0,len(A["dod"][i])):
            volume=volume+A["dod"][i][j];
    volume=volume/14.63;
    print('volume is',volume,'m3')
    
    return
   


if __name__ == "__main__":
    main()
