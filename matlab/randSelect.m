function result=randSelect(cage)

strcage=num2str(cage); 

load([strcage,'/data/vectors.mat']);

myList=floor(rand(100,1)*size(vectors,1));

vectors=vectors(myList,:);

proPOSCAR(cage,vectors,[strcage,'/posFiles']);

end
