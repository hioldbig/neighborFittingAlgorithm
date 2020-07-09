function proPOSCAR(cage,vectors,dirPath)
% To produce the POSCAR file

strcage=num2str(cage);

load(['~/matlab/c60/xyz/',strcage,'.mat']);  % get xyz of relaxed C60

for i=1:size(vectors,1)
 
  vector=vectors(i,:);  

  n=size(vector,2);

  atoms = {'N','C'};
  num = [n 60-n];

  tmp=xyz;

  %sub=xyz(subList(i,:),:);  % setdiff is not fit here!
  sub=tmp(vector,:);
  tmp(vector,:)=[];

  % tmp=setdiff(xyz,sub,'rows');  setdiff will change the default order!!
  data=[sub;tmp];
  posFile=joinNum(vector);

  if exist(dirPath,'dir')==0
     mkdir(dirPath);
  end

  saveFile(atoms,num,posFile,data,dirPath);

end

end

function saveFile(atoms,num,posFile,data,dirPath)
     
     bv=[20 0 0; 0 21 0; 0 0 22];
     
     fid = fopen([dirPath '/' posFile],'w');

     posHead(fid,atoms,num,bv);

     data=data/bv;

     data=movePOS(data,[0.5 0.5 0.5]);

     for ii=1:length(data) 
        fprintf(fid,'%21.16f',[data(ii,1),data(ii,2),data(ii,3)]);
        fprintf(fid,'\tT\tT\tT\n');
     end

     fclose(fid);

end

function newPOS = movePOS( oldPOS, newCenter )
% 将团簇的中心点移到新的位置
% 如果团簇只有一个点，则直接将该点移到目标坐标点
% 参数1为团簇坐标点，参数2为新的中心位置。

if(size(oldPOS,1)>1)
  center = mean(oldPOS);
else
  center = oldPOS;  
end

% 如果中心在原点，将坐标限制在0-1的范围内，便于vesta的显示。
if(norm(center-zeros(1,3))<0.01) 
  INDEX=find(oldPOS>0.5);
  oldPOS(INDEX)=oldPOS(INDEX)-1;
end

cha=newCenter-center;

if(norm(cha)<0.01)   % 已经位于目的点，无需移动
    newPOS=oldPOS;
else
    for i=1:1:3;
      oldPOS(:,i)= oldPOS(:,i)+cha(:,i);
    end;  
    newPOS = oldPOS;
end


end
