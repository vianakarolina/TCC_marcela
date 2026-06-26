import excel "G:\Meu Drive\TCC Marcela\TCC - PACIENTES TPS.xlsx", sheet("Banco de dados - Codificado") firstrow clear

browse

edit

*------------------------------------------------------------------------------*
keep in 1/26

* Rotulando as variáveis no banco
label define sexo_label 0 "Feminino" 1 "Masculino"
label values Sexo sexo_label

label define renda_label 0 "Menor que 1 SM" 1 "1 SM" 2 "De 1 a 2 SM" 3 "De 2 a 3 SM" 4 "Acima de 3 SM" 
label values Renda renda_label

generate renda_cat = . 
replace renda_cat = 0 if Renda == 0 | Renda == 1
replace renda_cat = 1 if Renda == 2 | Renda == 3
replace renda_cat = 2 if Renda == 4
label define renda_cat_label 0 "Até 1SM" 1 "Entre 1 e 3 SM" 2 "Mais que 3 SM"
label values renda_cat renda_cat_label

label define escolaridade_label 0 "Menos que 8 anos" 1 "Mais que 8 anos"
label values Escolaridadedicotomizado escolaridade_label

label define tabagismo_label 0 "Não" 1 "Sim" 2 "Ex-fumante"
label values Tabagismo tabagismo_label

label define diabetes_label 0 "Não" 1 "Sim"
label values Diabetes diabetes_label

label define estagio_label 0 "Estágio I" 1 "Estágio II" 2 "Estágio III" 3 "Estágio IV"
label values EstágiodaPeriodontite estagio_label

label define grau_label 0 "Grau A" 1 "Grau B" 2 "Grau C"
label values GraudaPeriodontite grau_label

label define risco_label 0 "Baixo" 1 "Moderado" 2 "Alto"
label values Risco risco_label

*------------------------------------------------------------------------------*
* Encontrando os percentis 25, 50 e 75 para criar uma variável de baixo, medio e alto letramento na amostra como fez Batista et al.
summarize Somatotalquestões, detail

centile Somatotalquestões, centile(25 50 75)
* p25: 45; 
* p50: 48; 
* p75: 52

*Gerando a variável de literácia categorizada de acordo com os percentis encontrados
generate literacia_cat = .
replace literacia_cat = 0 if Somatotalquestões < 46
replace literacia_cat = 1 if Somatotalquestões > 45 & Somatotalquestões < 52
replace literacia_cat =2 if Somatotalquestões >=52
label define literacia_cat_label 0 "Baixa literacia" 1 "Média literácia" 2 "Alta literácia"
label values literacia_cat literacia_cat_label

tab literacia_cat

*Gerando a variavel de literacia dicotomizada de acordo com a mediana como fez Suka et al.
generate literacia_dic = .
replace literacia_dic = 0 if Somatotalquestões < 49
replace literacia_dic = 1 if Somatotalquestões >=49
label define literacia_dic_label 0 "Baixa literácia" 1 "Alta literácia"
label values literacia_dic literacia_dic_label

tab literacia_dic

*------------------------------------------------------------------------------*
* TABELA 1 - CARACTERÍSTICAS GERAIS DA AMOSTRA
tab Sexo
sum Idade
tab Renda
tab Escolaridadedicotomizado
tab Tabagismo
tab Diabetes
tab EstágiodaPeriodontite
tab GraudaPeriodontite
tab Risco
sum Somatotalquestões
tab literacia_cat
tab literacia_dic

*------------------------------------------------------------------------------*
* TABELA 2 - indicadores periodontais para alta e baixa literacia

*Teste de normalidade de todas as variáveis com Shapiro-Wilk
swilk Índicedeplaca Percentualdesangramentoasond Percentualdebolsasiguaisa4 Percentualdebolsasiguaisa5m Percentualdebolsasmaioresou MédiadePS MédiadeNIC Númerodedentes Perdaósseaidade

* Distribuição normal: Sangramento, numero de dentes (p>0,05) - teste t
ttest Percentualdesangramentoasond, by(literacia_dic)
ttest Númerodedentes, by(literacia_dic)

* Mann Whitney para as demais variáveis
ranksum Índicedeplaca, by(literacia_dic)
ttest Índicedeplaca, by(literacia_dic)

ranksum Percentualdebolsasiguaisa4, by(literacia_dic)
ttest Percentualdebolsasiguaisa4, by(literacia_dic)

ranksum Percentualdebolsasiguaisa5m, by(literacia_dic)
ttest Percentualdebolsasiguaisa5m, by(literacia_dic)

ranksum Percentualdebolsasmaioresou, by(literacia_dic)
ttest Percentualdebolsasmaioresou, by(literacia_dic)

ranksum MédiadePS, by(literacia_dic)
ttest MédiadePS, by(literacia_dic)

ranksum MédiadeNIC, by(literacia_dic)
ttest MédiadeNIC, by(literacia_dic)

ranksum Perdaósseaidade, by(literacia_dic)
ttest Perdaósseaidade, by(literacia_dic)


* OPÇÃO: Variavel com 3 níveis de letramento  - Kruskall Wallis e one way ANOVA 
kwallis Índicedeplaca, by(literacia_cat)
kwallis Percentualdebolsasiguaisa4, by(literacia_cat)
kwallis Percentualdebolsasiguaisa5m, by(literacia_cat)
kwallis Percentualdebolsasmaioresou, by(literacia_cat)
kwallis MédiadePS, by(literacia_cat)
kwallis MédiadeNIC, by(literacia_cat)

kwallis Perdaósseaidade, by(literacia_cat)

anova Percentualdesangramentoasond literacia_cat
anova Númerodedentes literacia_cat

*------------------------------------------------------------------------------*

* TABELA 3 - QUI QUADRADO - LITERACIA VS RISCO E ESTAGIO
swilk Somatotalquestões 



anova Somatotalquestões EstágiodaPeriodontite
tabstat Somatotalquestões, by(EstágiodaPeriodontite) statistics(mean sd n)


anova Somatotalquestões Risco
tabstat Somatotalquestões, by(Risco) statistics(mean sd n)


anova Somatotalquestões GraudaPeriodontite
tabstat Somatotalquestões, by(GraudaPeriodontite) statistics(mean sd n)

*OPÇÃO - TESTE EXATO DE FISHER, VARIÁVEIS CATEGÓRICAS
tab EstágiodaPeriodontite literacia_dic, cell col exact
tab GraudaPeriodontite literacia_dic , cell col exact
tab Risco literacia_dic, cell col exact

*------------------------------------------------------------------------------*
*GRAFICOS - MEDIAS DO ESCORE TOTAL DE LETRAMENTO DE ACORDO COM VARIÁVEIS PERIODONTAIS

graph bar (mean) Somatotalquestões, over(EstágiodaPeriodontite) blabel(bar, format(%4.1f)) ytitle("Média de pontuação") title("Média do índice de literácia pelo estágio")


graph bar (mean) Somatotalquestões, over(GraudaPeriodontite) blabel(bar, format(%4.1f)) ytitle("Média de pontuação") title("Média do índice de literácia pelo grau")


graph bar (mean) Somatotalquestões, over(Risco) blabel(bar, format(%4.1f)) ytitle("Média de pontuação") title("Média do índice de literácia pelo risco")


*Forçando a barra com um modelo de regressão
regress Somatotalquestões Percentualdesangramentoasond Sexo Idade Diabetes Tabagismo Renda 


*------------------------------------------------------------------------------*
*CORRELAÇÃO DE SPEARMAN - HEATMAP NO PYTHON
spearman Somatotalquestões Índicedeplaca Percentualdesangramentoasond Percentualdebolsasiguaisa4 Percentualdebolsasiguaisa5m Percentualdebolsasmaioresou MédiadePS MédiadeNIC Númerodedentes Perdaósseaidade


********************************************************************************
*Torturando os dados - nada significativo
generate risco_dic = .
replace risco_dic = 0 if Risco == 0 | Risco == 1
replace risco_dic = 1 if Risco == 2
label define  risco_dic_label 0 "Baixo/moderado" 1 "Alto"
label values risco_dic risco_dic_label

tab risco_dic

ttest Somatotalquestões, by (risco_dic) //não significativo



generate estagio_dic = .
replace estagio_dic = 0 if EstágiodaPeriodontite == 0 | EstágiodaPeriodontite == 1
replace estagio_dic = 1 if EstágiodaPeriodontite == 2 | EstágiodaPeriodontite == 3
label define estagio_dic_label 0 "Estágios I/II" 1 "Estágios III/IV"
label values estagio_dic estagio_dic_label

tab estagio_dic

ttest Somatotalquestões, by (estagio_dic)


tab estagio_dic literacia_cat, cell col exact
tab GraudaPeriodontite literacia_cat , cell col exact
tab risco_dic literacia_cat, cell col exact
