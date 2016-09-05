---
title       : "Exercício Litteris"
subtitle    : 
author      : Luis Antonio
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

<!-- font-size: 0.7em; -- Inserido no arquivo slidify.css do framework io2012
para diminuir o tamanho do caption da tabela  -->

<!-- Limit image width and height -->
<style type='text/css'>
img {
    max-height: 500px;
    max-width: 1080px;
    }
</style>

<!-- Center image on slide -->
<script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.7.min.js"></script>
<script type='text/javascript'>
$(function() {
    $("p:has(img)").addClass('centered');
});
</script>


## Questões
1. Quais gêneros tem na média histórica os maiores ratings
2. Quais gêneros obtiveram a maior queda e crescimento na média com o passar do tempo 
3. Existe alguma relação entre users? (e.g. users dão notas mais altas para um gênero dão notas mais baixas para outro gênero; dica: você pode tentar segmentar users)

--- .class #id 
Os dados utilizados para responder as questões estão no link abaixo. [http://grouplens.org/datasets/movielens/20m/](http://grouplens.org/datasets/movielens/20m/)

A partir dele foram retirados dois arquivos úteis, e foram criados dois data frames, `movies` e `ratings`. Abaixo vemos parte deles.

<table>
<caption>Head of the Movies Data Frame</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> movieId </th>
   <th style="text-align:left;"> title </th>
   <th style="text-align:left;"> genres </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Toy Story (1995) </td>
   <td style="text-align:left;"> Adventure|Animation|Children|Comedy|Fantasy </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> Jumanji (1995) </td>
   <td style="text-align:left;"> Adventure|Children|Fantasy </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> Grumpier Old Men (1995) </td>
   <td style="text-align:left;"> Comedy|Romance </td>
  </tr>
</tbody>
</table>

<table>
<caption>Head of the Ratings Data Frame</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> userId </th>
   <th style="text-align:right;"> movieId </th>
   <th style="text-align:right;"> rating </th>
   <th style="text-align:right;"> timestamp </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 3.5 </td>
   <td style="text-align:right;"> 1112486027 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 29 </td>
   <td style="text-align:right;"> 3.5 </td>
   <td style="text-align:right;"> 1112484676 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 32 </td>
   <td style="text-align:right;"> 3.5 </td>
   <td style="text-align:right;"> 1112484819 </td>
  </tr>
</tbody>
</table>

--- .class #id 

## Processamento dos data frames

Como podemos ver pelo campo `Timestamp` a data está no formato `POSIXct`, por isso convertemos ela para o calendário Gregoriano. Além disso, extraímos somente o ano de cada data.

<table>
<caption>Ratings com a data formatada</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> userId </th>
   <th style="text-align:right;"> movieId </th>
   <th style="text-align:right;"> rating </th>
   <th style="text-align:left;"> timestamp </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 3.5 </td>
   <td style="text-align:left;"> 2005 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 29 </td>
   <td style="text-align:right;"> 3.5 </td>
   <td style="text-align:left;"> 2005 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 32 </td>
   <td style="text-align:right;"> 3.5 </td>
   <td style="text-align:left;"> 2005 </td>
  </tr>
</tbody>
</table>

--- .class #id

Como alguns filmes possuem vários gêneros, separamos os diferentes gêneros em diferentes linhas.

<table>
<caption>Movies com gêneros separados</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> movieId </th>
   <th style="text-align:left;"> title </th>
   <th style="text-align:left;"> genres </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Toy Story (1995) </td>
   <td style="text-align:left;"> Adventure </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Toy Story (1995) </td>
   <td style="text-align:left;"> Animation </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Toy Story (1995) </td>
   <td style="text-align:left;"> Children </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Toy Story (1995) </td>
   <td style="text-align:left;"> Comedy </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Toy Story (1995) </td>
   <td style="text-align:left;"> Fantasy </td>
  </tr>
</tbody>
</table>

--- .class #id 

Para obtermos os gêneros e seus respectivos ratings criamos um único data frame fazendo inner join de `ratings` e `movies`, usando o campo `movieId`. 

<table>
<caption>Data frame completo</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> userId </th>
   <th style="text-align:right;"> movieId </th>
   <th style="text-align:right;"> rating </th>
   <th style="text-align:left;"> timestamp </th>
   <th style="text-align:left;"> title </th>
   <th style="text-align:left;"> genres </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 3.5 </td>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> Jumanji (1995) </td>
   <td style="text-align:left;"> Adventure </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 3.5 </td>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> Jumanji (1995) </td>
   <td style="text-align:left;"> Children </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 3.5 </td>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> Jumanji (1995) </td>
   <td style="text-align:left;"> Fantasy </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 29 </td>
   <td style="text-align:right;"> 3.5 </td>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> City of Lost Children, The (Cité des enfants perdus, La) (1995) </td>
   <td style="text-align:left;"> Adventure </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 29 </td>
   <td style="text-align:right;"> 3.5 </td>
   <td style="text-align:left;"> 2005 </td>
   <td style="text-align:left;"> City of Lost Children, The (Cité des enfants perdus, La) (1995) </td>
   <td style="text-align:left;"> Drama </td>
  </tr>
</tbody>
</table>

--- .class #id 

## Outliers
Foi excluído o ano de 1995, pois existem apenas 4 filmes nesse ano.  


<table>
<caption>Filmes com ratings em 1995</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> movieId </th>
   <th style="text-align:left;"> title </th>
   <th style="text-align:left;"> genres </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 21 </td>
   <td style="text-align:left;"> Get Shorty (1995) </td>
   <td style="text-align:left;"> Comedy|Crime|Thriller </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 47 </td>
   <td style="text-align:left;"> Seven (a.k.a. Se7en) (1995) </td>
   <td style="text-align:left;"> Mystery|Thriller </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1079 </td>
   <td style="text-align:left;"> Fish Called Wanda, A (1988) </td>
   <td style="text-align:left;"> Comedy|Crime </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1176 </td>
   <td style="text-align:left;"> Double Life of Veronique, The (Double Vie de Véronique, La) (1991) </td>
   <td style="text-align:left;"> Drama|Fantasy|Romance </td>
  </tr>
</tbody>
</table>

--- .class #id 

## Questão 1 

Agrupando a média dos ratings por gênero e tempo.

![Média dos ratings por gênero e tempo](plots/q1.png) 

--- .class #id 

Analisando as maiores médias, abaixo vemos os gêneros com maiores ratings.

<table>
<caption>Maiores médias</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> genres </th>
   <th style="text-align:right;"> rating </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Film-Noir </td>
   <td style="text-align:right;"> 3.911992 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> War </td>
   <td style="text-align:right;"> 3.803397 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Documentary </td>
   <td style="text-align:right;"> 3.733566 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> IMAX </td>
   <td style="text-align:right;"> 3.683389 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Crime </td>
   <td style="text-align:right;"> 3.682062 </td>
  </tr>
</tbody>
</table>

--- .class #id 

## Questão 2

Para analisar os crescimentos e quedas na média, o data frame foi dividido em 2 períodos (análise visual de crescimento e queda). Mesmo acreditando que deve existir uma maneira melhor... 


```r
cresc <- tout %>% filter(timestamp %in% c(2005:2013) & genres != "(no genres listed)")
queda <- tout %>% filter(timestamp %in% c(1999:2005) & genres != "(no genres listed)")
```

A partir dessa divisão pensei em duas maneiras para descobrir os gêneros com maiores quedas e os com maiores crescimentos. A primeira seria analisando o coeficiente angular da regressão linear.

--- .class #id 

Abaixo temos os gêneros que tiveram os maiores crescimentos e quedas na média.

<table><tr valign="top"><td><table cellpadding="3">
<caption>Crescimento</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> genres </th>
   <th style="text-align:right;"> slope </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Children </td>
   <td style="text-align:right;"> 0.0487146 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Western </td>
   <td style="text-align:right;"> 0.0449657 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sci-Fi </td>
   <td style="text-align:right;"> 0.0429731 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Action </td>
   <td style="text-align:right;"> 0.0398870 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Romance </td>
   <td style="text-align:right;"> 0.0377789 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> IMAX </td>
   <td style="text-align:right;"> 0.0372127 </td>
  </tr>
</tbody>
</table></td><td><table cellpadding="3">
<caption>Queda</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> genres </th>
   <th style="text-align:right;"> slope </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Western </td>
   <td style="text-align:right;"> 0.0524497 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adventure </td>
   <td style="text-align:right;"> 0.0339880 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Animation </td>
   <td style="text-align:right;"> 0.0337058 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Action </td>
   <td style="text-align:right;"> 0.0206850 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Musical </td>
   <td style="text-align:right;"> 0.0071989 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> IMAX </td>
   <td style="text-align:right;"> 0.0031196 </td>
  </tr>
</tbody>
</table></td></tr></table>

--- .class #id 

E, a segunda, seria calcular a diferença entre o maior e o menor rating nesses períodos, por gênero. Para isso usei o pacote `sqldf`. Não gerou o mesmo resultado, a ordem não foi a mesma. Abaixo temos as respectivas tabelas de maiores crescimentos e quedas.


<table><tr valign="top"><td><table cellpadding="3">
<caption>Crescimento</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> genres </th>
   <th style="text-align:right;"> diff </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sci-Fi </td>
   <td style="text-align:right;"> 0.3236401 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Western </td>
   <td style="text-align:right;"> 0.2936069 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Action </td>
   <td style="text-align:right;"> 0.2905666 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Children </td>
   <td style="text-align:right;"> 0.2610443 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> IMAX </td>
   <td style="text-align:right;"> 0.2497089 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Thriller </td>
   <td style="text-align:right;"> 0.2462954 </td>
  </tr>
</tbody>
</table></td><td><table cellpadding="3">
<caption>Queda</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> genres </th>
   <th style="text-align:right;"> diff </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> IMAX </td>
   <td style="text-align:right;"> 0.3660882 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> War </td>
   <td style="text-align:right;"> 0.2755366 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Romance </td>
   <td style="text-align:right;"> 0.2597686 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Documentary </td>
   <td style="text-align:right;"> 0.2231839 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Comedy </td>
   <td style="text-align:right;"> 0.2220157 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Musical </td>
   <td style="text-align:right;"> 0.2194429 </td>
  </tr>
</tbody>
</table></td></tr></table>

--- .class #id 

## Questão 3

Para realizarmos o gráfico com a correlação entre os gêneros vamos, primeiro, verificar o número de vezes que um usuário forneceu determinado rate para um determinado gênero e a média, agrupando por `(user,genre)`.

Depois, padronizar a coluna de rating, por usuário (alguns usuários que veem mais filmes que outros).

Passamos agora os gênero para colunas para fazermos a correlação. Temos um exemplo abaixo, com as 6 primeiras colunas.

<table>
<caption>Gêneros nas colunas</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> userId </th>
   <th style="text-align:right;"> Action </th>
   <th style="text-align:right;"> Adventure </th>
   <th style="text-align:right;"> Animation </th>
   <th style="text-align:right;"> Children </th>
   <th style="text-align:right;"> Comedy </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0.9108773 </td>
   <td style="text-align:right;"> 1.222508 </td>
   <td style="text-align:right;"> -0.9810469 </td>
   <td style="text-align:right;"> -0.4361182 </td>
   <td style="text-align:right;"> 1.0028340 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2.1958028 </td>
   <td style="text-align:right;"> 1.978503 </td>
   <td style="text-align:right;"> -0.7739635 </td>
   <td style="text-align:right;"> -0.7739635 </td>
   <td style="text-align:right;"> -0.2850385 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 0.9943531 </td>
   <td style="text-align:right;"> 1.109202 </td>
   <td style="text-align:right;"> -0.9287968 </td>
   <td style="text-align:right;"> -0.6210328 </td>
   <td style="text-align:right;"> 1.1092016 </td>
  </tr>
</tbody>
</table>

--- .class #id 

Abaixo vemos o gráfico da correlação entre os gêneros.

![Correlação entre os gêneros](plots/q3.png) 


--- .class #id 

O gráfico foi ordenado pelo primeiro componente principal e foi adicionado um `X` para designar valores de significância inferiores a `1%`.

Vemos que, pessoas que gostam de gêneros como Aventura e/ou Ação e/ou Sci-Fi, não gostam de Dramas e/ou Filmes-Noir. E, quem gosta de Filmes-Noir e/ou Drama, não gosta de Aventura e Ação. 

Em menor escala, quem gosta de Thriller gosta de Ação e não gosta de Musical ou Romance, quem gosta de Animação gosta de filmes de criança, quem gosta Musical também gosta de filmes de criança e Romance, mas não gosta de filmes de Ação ou Thriller.

