function obj = readlas()
%READLAS Summary of this function goes here
%   Detailed explanation goes here
file='Copy_of_points (2).las';
 fid = fopen('Copy_of_points (2).las');
        fseek(fid,double(file.header.offset_to_point_data),-1);
        
        LEN = file.header.point_data_record_length;
        POINTS = file.header.number_of_point_records;
        OFFSET = file.header.offset_to_point_data;      
        fseek(fid,OFFSET,-1);
        file.x = fread(fid,POINTS,'*int32',LEN-4);  %x
        fseek(fid,OFFSET+4,-1);
        file.y = fread(fid,POINTS,'*int32',LEN-4);  %y
        fseek(fid,OFFSET+8,-1);
        file.z = fread(fid,POINTS,'*int32',LEN-4);  %z   
        
        fclose(fid);
        
        %apply filter
        if ~exist('donotfilter','var')
            obj.x = obj.x(obj.selection);   
            obj.y = obj.y(obj.selection);
            obj.z = obj.z(obj.selection);        
        end
        obj.normalize_xyz();
end

