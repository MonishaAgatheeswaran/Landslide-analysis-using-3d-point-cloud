function fyp()

c=lasdata('points (22).las');
d=lasdata('points (23).las');
disp(length(c.x));
disp(length(d.x));
%figure;
%plot_xyz(c);
%figure; 
%plot_xyz(d);
xlimit=[min(c.x) max(c.x)];
disp(xlimit(1));
sprintf('%.30f',xlimit(1))
ylimit=[min(c.y) max(c.y)];
sprintf('%.30f',ylimit(1))
sprintf('%.30f',ylimit(2))

x_range=xlimit(2)-xlimit(1);
y_range=ylimit(2)-ylimit(1);
disp(x_range);
disp(y_range);
%fname='data1.ply';
%fid = fopen(fname, 'w');
%for i=1:length(c.x)
%   fprintf(fid,'%g %g %g\n',c.x(i),c.y(i),c.z(i));
%end   
%fclose(fid);
%fname='data2.ply';
%fid = fopen(fname, 'w');
%for i=1:length(d.x)
%       fprintf(fid,'%g %g %g\n',d.x(i),d.y(i),d.z(i));
%end   
%fclose(fid);
pt1=[c.x(:),c.y(:),c.z(:)];
pt2=[d.x(:),d.y(:),d.z(:)];
dem1=zeros(round(x_range)+1,round(y_range));
for i=1:length(c.x)
    %disp(round(c.x-xlimit(1)));
   
    dem1(round(c.x(i)-xlimit(1)+1),round(c.y(i)-ylimit(1)+1))=c.z(i);
end
for i=1:round(x_range+1)
    xarr(i)=i;
end
for i=1:round(y_range+1)
    yarr(i)=i;
end
figure('Name','Pcplot: Before landslide') ;
pcshow(pt1);
figure('Name','Pcplot: After landslide');
pcshow(pt2);

if length(yarr) ~= size(dem1,2) || length(xarr) ~= size(dem1,1)
disp(length(xarr));
disp(size(dem1,2));
disp(length(yarr));
disp(size(dem1,1));
end

figure('Name','DEM: Before landslide');
dem(yarr,xarr,dem1);     

%----------dem222------------
xlimit2=[min(d.x) max(d.x)];
disp(xlimit2(1));
%sprintf('%.30f',xlimit(1))
ylimit2=[min(c.y) max(c.y)];
x_range2=xlimit2(2)-xlimit2(1);
y_range2=ylimit2(2)-ylimit2(1);

dem2=zeros(round(x_range2)+1,round(y_range2));
for i=1:length(d.x)
    %disp(round(c.x-xlimit(1)));
   
    dem2(round(d.x(i)-xlimit2(1)+1),round(d.y(i)-ylimit2(1)+1))=d.z(i);
end
for i=1:round(x_range2+1)
    xarr2(i)=i;
end
for i=1:round(y_range2+1)
    yarr2(i)=i;
end
figure('Name','DEM: After landslide');
dem(yarr2,xarr2,dem2);


%%%%%--------------saving dem as mat------
save('dem.mat','dem2')


%%%%%--------saving as tiff--------
%figure('Name','trial tiff');
%imwrite(dem2,'ls.tif','tif');
%imshow('ls.tiff')
%------------dod----------
xmini=min(xlimit(1),xlimit2(1));
xmaxi=max(xlimit(2),xlimit2(2));
ymini=min(ylimit(1),ylimit2(1));
ymaxi=max(ylimit(2),ylimit2(2));
dod_xrange=round(xmaxi-xmini);
dod_yrange=round(ymaxi-ymini);
dem2=zeros(round(dod_xrange)+1,round(dod_yrange));

for i=1:length(d.x)
    %disp(round(c.x-xlimit(1)));
   
    dod(round(d.x(i)-xmini+1),round(d.y(i)-ymini+1))=d.z(i);
end
for i=1:length(c.x)
    %disp(round(c.x-xlimit(1)));
   
    dod(round(c.x(i)-xmini+1),round(c.y(i)-ymini+1))=dod(round(c.x(i)-xmini+1),round(c.y(i)-ymini+1))-c.z(i)*(-1);
    %disp(dod(round(c.x(i)-xmini+1),round(c.y(i)-ymini+1)));
end
for i=1:round(dod_xrange+1)
    dodx(i)=i;
end
for i=1:round(dod_yrange+1)
    dody(i)=i;
end
demelevation=[min(dod(:)) max(dod(:))];
figure('Name','Difference of DEM');
dem(dody,dodx,dod);
count=1;
volume=0;
for i=1:length(dodx)
    for j=1:length(dody)
        trialx(count)=i+xmini;
        trialy(count)=j+ymini;
        trialz(count)=dod(i,j);
        if trialz(count)>0
            volume=volume+trialz(count);
        end
        count=count+1;
    end
end
volume=volume/14.63;
god=[trialx(:),trialy(:),trialz(:)];
figure('Name','Pcplot: DoD');
pcshow(god);



%----------volume-----------
save('dod.mat','dod')
systemCommand = ['C:\Users\Monisha\AppData\Local\Programs\Python\Python36\python.exe volume.py']
[sts1,vol ] =system(systemCommand)
disp('trying to print');
disp(volume);
%14.63 pts/msq 4.8737e+09
sprintf('%.3f m3',volume)



%-----------slope-----------
systemCommand = ['C:\Users\Monisha\AppData\Local\Programs\Python\Python36\python.exe slope.py']
[sts2,slope ] =system(systemCommand)
slope=matfile('slope.mat');
sl=slope.slope;
%whos -file slope.mat

figure('Name','Slope');

dem(yarr2,xarr2,sl);

%disp(sl)

%--------------profile and plan curvature---------
systemCommand = ['C:\Users\Monisha\AppData\Local\Programs\Python\Python36\python.exe curvature.py']
[sts2,curv ] =system(systemCommand)
prof_curv=matfile('prof_curv.mat');
pfc=prof_curv.prof_curv;
figure('Name','Profile Curvature');
dem(yarr2,xarr2,pfc);
plan_curv=matfile('plan_curv.mat');
plc=plan_curv.plan_curv;
figure('Name','Plan Curvature');
dem(yarr2,xarr2,plc);



%---------------roughness-------------
systemCmd = ['C:\Users\Monisha\AppData\Local\Programs\Python\Python36\python.exe roughness.py']
[sts2,roughness] =system(systemCmd)
roughness=matfile('roughness.mat');
rgh=roughness.roughness;
figure('Name','Roughness');
dem(yarr2,xarr2,rgh);


%---------------hillshade-----------
systemCmd = ['C:\Users\Monisha\AppData\Local\Programs\Python\Python36\python.exe hillshade.py']
[sts2,hillshade] =system(systemCmd)
hillshade=matfile('hillshade.mat');
hs=hillshade.hillshade;
figure('Name','Hillshade');
dem(yarr2,xarr2,hs);

end



%---------------roughness-------------
%systemCmd = ['C:\Users\Monisha\AppData\Local\Programs\Python\Python36\python.exe matinfile.py']
%[sts2,rough] =system(systemCmd)
