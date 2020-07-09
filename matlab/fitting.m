function result=fitting(cage,step)

strcage=num2str(cage);

enList=load([strcage,'/data/enList']); 
load([strcage,'/data/branches.mat']);
load([strcage,'/data/vectors.mat']);

en=enList(:,13);
en=[en (1:size(en,1))'];

vs=enList(:,1:12);
vs=[vs (1:size(vs,1))'];

vs=unique(vs,'rows');

en=en(vs(:,13),1);

myList=find(ismember(vectors,vs(:,1:12),'rows'));
branches=branches(myList,:);

branches=[ones(size(branches,1),1) branches];

[b, bint, r, rint, stats] = regress(en, branches);
error=sqrt(sum(r.^2,1)/size(r,1));

fitting=[en-r en];
mini=min(en);

save([strcage,'/data/myList'],'myList');
save([strcage,'/data/b'],'b');

dlmwrite([strcage,'/data/mini/',num2str(step)],mini,'precision','%.4f');
dlmwrite([strcage,'/data/error/',num2str(step)],error,'precision','%.4f');
dlmwrite([strcage,'/data/fitting/',num2str(step)],fitting,'delimiter',' ','precision','%.4f');

end
