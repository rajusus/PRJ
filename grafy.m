ind=[313,532,432,21];
signal_count=5;
fs=4096;
duration=1;
S=zeros(signal_count,fs*duration);
for i = ind
noise_file=noise_files{i};
file=noise_files_directory+noise_file;
dataset = "/"+h5info(file).Datasets.Name;
x_spacing_noise = h5readatt(file,dataset,'dx');
noise = h5read(file,dataset);
resampled = resample_custom(double(noise),duration,n); clear noise
S(incr,:)=resampled;
incr=incr+1;
end