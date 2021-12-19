clear
clc

%% Caricamento dati
load('G01.mat')

%% Ispezione del dataset
summary(t)

%% Statistiche descrittive per alcune variabili
% (comprensione/descrizione dei fenomeni)
mean(t.PM10)
std(t.PM10)
grpstats(t,'ARPA_ID_staz',{'mean','std','min','max'},'DataVars',{'PM10'})

%% Scatterplot
y = t.PM10;
x = t.Temperatura;
scatter(x,y,'filled')
title('Temperatura e PM10')

%% Regressione lineare multipla
data = t(:,{'PM10','Temperatura','Pioggia_cum','Umidita_relativa','O3'})
data.Properties.VariableNames = {'PM10','Temp','Pioggia','Umid','Ozono'};
% m1: completo
m1 = fitlm(data,'ResponseVar','PM10','PredictorVars',{'Temp','Pioggia','Umid','Ozono'})
% m2: senza ozono
m2 = fitlm(data,'ResponseVar','PM10','PredictorVars',{'Temp','Pioggia','Umid'})
% m3: senza pioggia
m3 = fitlm(data,'ResponseVar','PM10','PredictorVars',{'Pioggia','Ozono'})
% m4: risposta logaritmica
data.logPM10 = log(data.PM10);
m4 = fitlm(data,'ResponseVar','logPM10','PredictorVars',{'Temp','Pioggia','Umid'})
%%% Aggiungere o togliere le variabili: metodologia stepwise
% https://it.mathworks.com/help/stats/stepwiselm.html

%% Adattamento
r2 = m1.Rsquared.Ordinary
% Il 49.58% della variabilità complessiva di PM10 è spiegato dalla
% relazione lineare con la temperatura, pioggia, umidità e concentrazioni
% di ozono.


%% Analisi dei residui
% https://it.mathworks.com/help/stats/residuals.html
resm1 = m1.Residuals.Raw
% Serie storica
plot(resm1)
yline(0,'r','LineWidth',3)
yline(mean(resm1),'b','LineWidth',2)
% Istogramma
histfit(resm1)


tabella=t
tabella.ARPA_ID_staz=[]
tabella.Nome_staz=[]
tabella.Cod_staz=[]
tabella.Citta=[]
tabella.Provincia=[]
tabella.ARPA_zona=[]
tabella.ARPA_tipo_staz=[]
tabella.Altitudine=[]
tabella.Latitudine=[]
tabella.Longitudine=[]
tabella.NOx=[]
tabella.O3=[]
