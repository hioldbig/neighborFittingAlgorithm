function top100(cage,i)
 
 strcage=num2str(cage);

 fitting1=load([strcage,'/data/fitting/',num2str(i-1)]);
 en1=sort(fitting1(:,2));
 
 fitting2=load([strcage,'/data/fitting/',num2str(i)]);
 en2=sort(fitting2(:,2));

 top100=en2(1:100);

 newList=setdiff(en2,en1);

 tmp=intersect(top100,newList);

 result=size(tmp,1);

 dlmwrite([strcage,'/data/top100/',num2str(i)],result);

end
