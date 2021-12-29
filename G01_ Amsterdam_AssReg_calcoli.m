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

tabella.Data=[]


dati = t(:,{'Data','NO2','PM10','Temperatura','Umidita_relativa','Pioggia_cum','Benzina_vendita_rete_ord','Gasolio_motori_rete_ord','Gasolio_riscaldamento'})

a1=fitlm(dati,'ResponseVar','NO2','PredictorVars',{'Temperatura','Umidita_relativa','Pioggia_cum','Benzina_vendita_rete_ord','Gasolio_motori_rete_ord','Gasolio_riscaldamento'})
plot(a1)
%sinceramente non so come faccia a rappresentare una funzione di 6 variabili in 2 dimensioni
histfit(a1.Residuals.Raw)

a2=fitlm(dati,'ResponseVar','PM10','PredictorVars',{'Temperatura','Umidita_relativa','Pioggia_cum','Benzina_vendita_rete_ord','Gasolio_motori_rete_ord','Gasolio_riscaldamento'})
plot(a2)
histfit(a2.Residuals.Raw)

%al profe piace stepwise
%la differenza è che calcola da sola quali variabili togliere e quali
%aggiungere. In questo caso toglie la pioggia e la benzina mentre aggiunge
%il prodotto tra la temperatura e il gasolio motori
a1=stepwiselm(tabella,"linear","ResponseVar","NO2")
plot(a1)
histfit(a1.Residuals.Raw)

tabella2=tabella;
tabella2.PM10=[];

%uguale ma senza PM10 come "causa"
b1=stepwiselm(tabella2,"linear","ResponseVar","NO2")
plot(b1)
histfit(b1.Residuals.Raw)

a2=stepwiselm(tabella,"linear","ResponseVar","PM10")
plot(a2)
histfit(a2.Residuals.Raw)

tabella3=tabella;
tabella3.NO2=[];

%uguale ma senza NO2 come "causa"
b2=stepwiselm(tabella3,"linear","ResponseVar","PM10")
plot(b2)
histfit(b2.Residuals.Raw)
