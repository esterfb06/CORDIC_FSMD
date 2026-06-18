# Informações do Grupo

*Nome do Grupo:* AP3-02208A-Grupo-B

### Nome dos Alunos:
* Eduardo Campos St Clair Smallwood (23104293)
* Carlos Henrique D'Avila Carvalho (24100810)
* Leonardo de Oliveira Santana (24200512)
* Daniella Nascimento Romano (24202452)
* Pedro Korosi Peres (24202599)
* Carolina Cardozo de Mesquita (25150364)

---

# Informações do Projeto
    
## Descrição do Problema a ser Resolvido
Nosso objetivo é projetar e desenvolver um sistema digital capaz de calcular funções trigonométricas (senos, cossenos e tangentes) de ângulos contidos em um intervalo de 0 a 90 graus, com uma boa precisão para o seno e o cosseno. No caso da tangente, haverá pouca precisão conforme nos aproximamos de 90 graus, já que a tangente tende ao infinito à medida que seu ângulo se aproxima desse valor.

## Descrição da FSM
A FSM possui um total de 8 estados, sendo eles:

* *S0:* Estado de repouso inicial;
* *S1:* Estado para setar os valores iniciais do seno e do cosseno;
* *S2:* Estado que checa o número de iterações já feitas no cálculo do seno e do cosseno (16 iterações);
* *S3:* Somatório que gerará, no final, os resultados aproximados de seno e cosseno;
* *S4:* Estado para setar os valores iniciais para o cálculo da tangente e carregar o valor final do seno e do cosseno em seus respectivos registradores;
* *S5:* Estado que checa o número de iterações já feitas no cálculo da tangente;
* *S6:* Estado que calcula a tangente dividindo o seno pelo cosseno;
* *S7:* Carrega o valor calculado da tangente no registrador determinado e volta para o S0.

## Descrição do Datapath
O Datapath possui 4 grandes blocos, dispostos da esquerda para a direita:

* *Bloco das Iterações:* Responsável pelo controle do número de iterações;
* *Bloco do Cosseno:* Responsável pelo cálculo do cosseno;
* *Bloco do Seno:* Responsável pelo cálculo do seno;
* *Bloco de Z e Tangente:* Responsável pelo cálculo de Z (ângulos que serão somados ou subtraídos em cada iteração) e pelo cálculo da tangente.
