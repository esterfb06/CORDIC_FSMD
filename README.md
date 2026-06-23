# Informações do Grupo

*Nome do Grupo:* AP3-02208A-Grupo-B

### Nome dos Alunos:
* Ester de Freitas Brizolla (24207925)
* Eduardo Campos St Clair Smallwood (23104293)
* Carlos Henrique D'Avila Carvalho (24100810)
* Leonardo de Oliveira Santana (24200512)
* Daniella Nascimento Romano (24202452)
* Pedro Korosi Peres (24202599)
* Carolina Cardozo de Mesquita (25150364)

---

# Informações do Projeto
    
## Descrição do Problema a ser Resolvido
Nosso objetivo é projetar e desenvolver um sistema digital capaz de calcular as funções trigonométricas Seno e Cossenos de ângulos contidos em um intervalo de 90 a -90 graus, com uma boa precisão, usando o Modelo de Cordic.

## Descrição da FSM
A FSM possui um total de 5 estados, sendo eles:

* *S0:* Estado de repouso inicial;
* *S1:* Estado para setar os valores iniciais do seno e do cosseno e Z (vetor que é rotacionado a 45/1+i graus a cada iteração i);
* *S2:* Estado que checa o número de iterações já feitas no cálculo do seno e do cosseno (16 iterações);
* *S3:* Somatório que gerará, no final, os resultados aproximados de seno e cosseno;
* *S4:* Estado para carregar o valor final do seno e do cosseno em seus respectivos registradores;


## Descrição do Datapath
O Datapath possui 4 grandes blocos, dispostos da esquerda para a direita:

* *Bloco das Iterações:* Responsável pelo controle do número de iterações;
* *Bloco do Cosseno:* Responsável pelo cálculo do cosseno;
* *Bloco do Seno:* Responsável pelo cálculo do seno;
* *Bloco de Z:* Responsável pelo cálculo de Z (ângulos que serão somados ou subtraídos em cada iteração), resposável pelo rotação do Vetor, cuja as coordenadas X e Y são, respectivamentes o Seno e Cosseno desejado.

# Notas sobre o Cálculo da Tangente
Inicialmente, o objetivo do nosso Sistema Digital englobava também o calculo de tangente do ângulo selecionado. Teorizamos dois métodos:
   *  *Método em Série:* Após o cálculo do Seno e Cossenos, dividiriamos os seus resultados, o que, por definição, resultaria na tangente. A estratégia que tentamos implementar para isso foi de contar quantas vezes é possivel diminiuir o seno do cosseno. Pórem esse método tinha dois problemas. O primeiro era que a contagem só poderia ser feita com números inteiros, já que decidimos não usar Floating point; e o segundo é que caso Cosseno fosse maior que Seno (Tangente de 0 a 45 graus) o método não funciona, visto que cosseno não pode ser diminuido nenhuma vez de Seno nesse caso, i.e tangente(0-45)=0 por este método.
   * *Método em paralelo:* Pensamos tambem em fazer uma mémoria com os valores respectivos a cada arctangente ultilizado (lembrando que os valores de ArcTg são dados por 45/1+i, o que levaria a valores de Tangente no formato 2^-i, i.e Tg(2^-1) = 45 graus). Usando 16 iterações o valor terórico máximo que nosso sistema poderia calcular seria de 1,9999 (o somatório de 2^-i, com i=16), e arctg(1,999) é aproximadamente 63 graus. Porém, em nossos testes o cálculo da tangente por este método não funcionou por motivos que, infelizmente, não tivemos tempo de investigar    
