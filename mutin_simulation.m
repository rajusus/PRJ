close all;clc; clear
%% 

root_path = "C:\Users\rayan\MATLAB Drive\PRJ";
noise_files_directory = root_path+"\Python_scripts\All_Aux\";
noise_files = dir(fullfile(noise_files_directory,'*.hdf5'));
noise_files={noise_files.name};
strain_file=root_path+"\Python_scripts\strain.hdf5";
strain=h5read(strain_file,"/Strain");
n=length(strain);
duration=double(1);
fs=n/duration;
%%
noise_signal_count=length(noise_files);
Fs_noises = zeros(1,noise_signal_count);
noise_sizes = Fs_noises;
top_amount = 5;
top_noises= zeros(top_amount,2+n);
looking_for_maximum=0;
if looking_for_maximum == 0
    top_noises(:,2)=inf(top_amount,1);
end
%%
for i = 1:length(noise_files)
    noise_file=noise_files{i};
    file=noise_files_directory+noise_file;
    dataset = "/"+h5info(file).Datasets.Name;
    x_spacing_noise = h5readatt(file,dataset,'dx');
    Fs_noise = 1/x_spacing_noise;
    Fs_noises(i) = Fs_noise;
    noise = h5read(file,dataset);

    resampled = resample_custom(double(noise),duration,n); clear noise
    
    if size(resampled,1) == 1
        resampled=resampled';
    end
    adata = [strain,resampled];
    mutin_ = mutin(adata); clear adata
    for j = 1:top_amount
        if (mutin_ > top_noises(j,2) && looking_for_maximum == 1)
            if j < top_amount
                top_noises(j+1:end,:) = top_noises(j:end-1,:);
            end
            top_noises(j,:) = [i, mutin_,resampled'];
            break
        elseif (mutin_ < top_noises(j,2) && looking_for_maximum == 0)
            if j < top_amount
                top_noises(j+1:end,:) = top_noises(j:end-1,:);
            end
            top_noises(j,:) = [i, mutin_,resampled'];
            break
        end
    end
    clear resampled
end
signal_count=1+top_amount;
X = zeros(signal_count,n);
X(1,:)=normalise_custom(strain); clear strain
for i = 1:signal_count-1
    X(i+1,:)=normalise_custom(top_noises(i,3:end));
end
saved_mutin = top_noises(:,1:2);clear top_noises


disp(saved_mutin(:,2))
figure
for i = 1:signal_count
    subplot(signal_count,1,i)
    plot(X(i,:))
end
[Wefica, ISRef, Wsymm, ISRsymm, status, icasig] = efica(X);
figure
for i = 1:signal_count
    subplot(signal_count,1,i)
    plot(icasig(i,:))
end

%save("saved.mat","X","icasig", "Wefica")

