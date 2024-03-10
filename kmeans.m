function label_vector = kmeans(no_of_cluster,data)
min_val = min(data(:));
vector=double((data(:)-min_val)+1);
vector = repmat(vector,[1,no_of_cluster]);
vec_mean=(1:no_of_cluster).*max((vector))/(no_of_cluster+1);
num = length(vector);
itr = 0;
% tic
while(true)
itr = itr+1;
old_mean=vec_mean;
vec_mean = repmat(vec_mean,[num,1]);
for m = 1 : 10
distance=(((vector-vec_mean)).^2);
end
vec_mean(2:end,:)=[];
    [~,label_vector] = min(distance,[],2);
    label_vector = label_vector-1;
for i=1:no_of_cluster
index=(label_vector==(i-1));
vec_mean(:,i)=sum(vector(index))/nnz(index);
end
if (vec_mean==old_mean | itr>50)
break;
end
end