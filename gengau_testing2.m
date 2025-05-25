clc;clear
% Nastavení výchozích parametrů
time=1;
Fs=1000;
elements = time * Fs;
Ts=1/Fs;
t=0:Ts:time-Ts;
n_signals = 3; % počet signálů
SaddleTest = true;

%% Nastavení hodnot pro parametr Alfa
AlfaStart = 0; % V intervalu nevčetně
AlfaEnd = 5; % V intervalu včetně
AlfaJump=0.1;

AlfaLength = (AlfaEnd-AlfaStart)/AlfaJump;
AlfaInterval = AlfaStart+AlfaJump:AlfaJump:AlfaEnd;
sirs=zeros(1,AlfaLength); % Do proměnné sirs se budou ukládat hodnoty SIR pro jednotlivé hodnoty parametru Alfa

%% Smyčka pro výpočet SIR pro signál s1 v proměnným parametrem Alfa
sir_iterations = 100;
for i = 1:AlfaLength
    s1=gengau2(AlfaInterval(i),1,elements); % Nastavení s1 s pomocí Gengau2
    for j = 1:sir_iterations
        s2=randn(1,elements);
        s3=randn(1,elements);
        S(2,:)=s2;
        S(3,:)=s3;
        A=rand(n_signals);
        ini = randn(n_signals);
        X=A*S;
        
        Wefica = efica(X,ini,SaddleTest);
        G=Wefica*A;
        [~,Gsig] = max(abs(G(:,1))); % Gsig určuje, v jakém řádku se nachází nejvyšší zastoupení Gauss. signálu s1
        sirs(i)=sirs(i)+sir(G(Gsig,:),S,1);
    end
    sirs(i)=sirs(i)/sir_iterations;
end

plot(AlfaInterval,sirs)
