clc;
clear all;
close all;
p= 'images\abnormal\*jpg';
names = dir(p);
h1 = waitbar(0,'Please Wait....');
for m = 1 : length(names)
    waitbar(m/length(names));
    fn = names(m).name;
    pf = ['images\abnormal\',fn];
    out_ab(m,:) = Feature_Extraction(pf);
    target_ab(m,1)=1;
end
close(h1)
p= 'images\normal\*jpg';
names = dir(p);
h1 = waitbar(0,'Please Wait....');
for m = 1 : length(names)
    waitbar(m/length(names));
    fn = names(m).name;
    pf = ['images\normal\',fn];
    out_n(m,:) = Feature_Extraction(pf);
    target_n(m,1)=-1;
end
close(h1)
all_feature = [out_ab;out_n];
all_target = [target_ab;target_n];
svmStruct = svmtrain(all_feature,all_target);
save svmStruct svmStruct