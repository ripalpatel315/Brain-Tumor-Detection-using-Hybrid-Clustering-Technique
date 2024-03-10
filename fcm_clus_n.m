function data = fcm_clus_n(data,cluster_n,i)
[center,U,obj_fcn] = fcm(data,cluster_n);
maxU = max(U);
for m = 1 : cluster_n
    index{m} = find(U(m,:) == maxU);
    c{m}=i(index{m});
    max_val(m) = max(c{m});
end
%=====================Analysing Clusters==================================%
[k,id]=sort(max_val);
for m = 1 : cluster_n
    data(index{id(m)})=m;
end
end
