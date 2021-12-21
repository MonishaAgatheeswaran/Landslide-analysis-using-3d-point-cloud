import h5py
import scipy.io as sio
import numpy as np


def main():
    
    dem=sio.loadmat('dem.mat')
    (rows,cols)=np.shape(dem["dem2"])
    print(rows, cols)
    prof_curv=np.zeros((rows,cols))
    plan_curv=np.zeros((rows,cols))
    for r in range(1,rows-1):
        for c in range(1,cols-1):
            temp_win=dem["dem2"][r-1:r+2,c-1:c+2]
            h=1
            zx=(temp_win[1,2]-temp_win[1,0])/(2*h)
            zy=(temp_win[0,1]-temp_win[2,1])/(2*h)
            zxx=(temp_win[1,2]-(2*temp_win[1,1])+temp_win[1,0])/(h*h)
            zyy=(temp_win[0,1]-(2*temp_win[1,1])+temp_win[2,1])/(h*h)
            zxy=-temp_win[0,0]+temp_win[0,2]+temp_win[2,0]-temp_win[2,2]
            p=(zx*zx)+(zy*zy)
            q=p+1
            prof_curv[r,c]=((zxx*zy*zy)-(2*zxy*zx*zy)+(zyy*zx*zx))/np.power(q,3/2)
            plan_curv[r,c]=((zxx*zx*zx)-(2*zxy*zx*zy)+(zyy*zy*zy))/p*np.power(q,3/2)
            
    sio.savemat('prof_curv.mat', mdict={'prof_curv': prof_curv})
    sio.savemat('plan_curv.mat', mdict={'plan_curv': plan_curv})
    
            
    return 
   


if __name__ == "__main__":
    main()
