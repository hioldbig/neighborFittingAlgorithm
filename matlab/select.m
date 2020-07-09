function result=select(cage)

strcage=num2str(cage); 

load([strcage,'/data/branches.mat']);
load([strcage,'/data/b.mat']);
load([strcage,'/data/vectors.mat']);
load([strcage,'/data/myList.mat']);

myList=setdiff(1:size(vectors,1),myList);
branches=branches(myList,:);
vectors=vectors(myList,:);

branches=[ones(size(branches,1),1) branches];

en=branches*b;
order=(1:size(en,1))';

en=[order en];

en=sortrows(en,2);

newList=en(1:100,1); 

vectors=vectors(newList,:);

proPOSCAR(cage,vectors,[strcage,'/posFiles']);

end
