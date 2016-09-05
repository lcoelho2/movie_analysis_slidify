# arquivo com o processamento dos dados

# Separando os gêneros dos filmes classificados com mais de um.
moviess <- movies %>% mutate(genres = strsplit(genres, "\u007C",fixed=TRUE)) %>% unnest(genres)

# Alterando o formato da data
ratingsBefore <- ratings
ratings$timestamp <- as.POSIXct(as.numeric(ratings$timestamp),origin="1970-01-01",tz="GMT")
ratings$timestamp <- format(ratings$timestamp, "%Y")

# Juntando o aquivo com os ratings e o arquivo com os gêneros
total <- ratings %>% inner_join(moviess,by="movieId")

# Analisando quem são os outliers. Foi excluído o ano de 1995, pois existem apenas 4 filmes nesse ano.  
#y1995 <- total %>% filter(timestamp == 1995)  
#movies %>% filter(movieId %in% y1995$movieId)
# Retirando outliers
tout <- total %>% filter(timestamp != 1995)  

# Agrupando a média dos ratings por gênero e tempo
tagg <- tout %>% group_by(genres,timestamp) %>% summarise(rating = mean(rating))

# Resposta da questão 1
# Analisando as maiores médias
mm <- tagg %>% group_by(genres) %>% summarise(rating = mean(rating)) %>% arrange(desc(rating)) %>% top_n(n=5,wt=rating)


# Questão 2
cresc <- tout %>% filter(timestamp %in% c(2005:2013) & genres != "(no genres listed)")
queda <- tout %>% filter(timestamp %in% c(1999:2005) & genres != "(no genres listed)")

#Abaixo temos os gêneros que tiveram os maiores crescimentos na média.

crescLm <- ddply(cresc %>% select(genres,timestamp,rating), "genres", function(x) coef(lm(rating ~ timestamp,data = x))[2])
names(crescLm)[2] <- "slope"
head(crescLm %>% arrange(desc(slope)))

#Abaixo temos os gêneros que tiveram as maiores quedas na média.
quedaLm <- ddply(queda %>% select(genres,timestamp,rating), "genres", function(x) coef(lm(rating ~ timestamp,data = x))[2])
names(quedaLm)[2] <- "slope"
head(quedaLm %>% arrange(desc(slope)))

#E a segunda seria calcular a diferença entre o maior e o menor rating nesses períodos, por gênero. 
#Para isso usei o pacote `sqldf`. Não gerou o mesmo resultado, a ordem dos maiores não foi a mesma.
#Crescimento na média.
cresc <- sqldf("select genres, (max(rating) - min(rating)) diff from tagg
               where timestamp between 2005 and 2013 and genres != '(no genres listed)' group by genres order by diff desc")
hcresc <- head(cresc) ##alguma coisa no processamento do slidify não estava carregando a tabela cresc direito

#Queda na média.
decr <- sqldf("select genres, (max(rating) - min(rating)) diff from tagg 
              where timestamp between 1999 and 2005 and genres != '(no genres listed)' group by genres order by diff desc")


# Questão 3

usrRatMax <- tout %>% filter(genres != "(no genres listed)") %>% group_by(userId,genres,rating) %>% summarise(count = n())
usrRatxCt <- usrRatMax %>% mutate(cxr = rating * count) %>% group_by(userId,genres) %>% summarise(avg = mean(cxr))

#Agora, vamos padronizar a coluna de rating, por usuário (alguns usuários que veem mais filmes que outros).
usrgensc <- ddply(usrRatxCt, "userId", function(x){ x$scavg = scale(x$avg)})
usrgensc <- mutate(usrgensc, genres = usrRatxCt$genres) #adiciona genres ao data.frame de novo
colnames(usrgensc) <- c("userId", "avgsc","genres")

#Passamos agora os gênero para colunas para fazermos a correlação.
usrgenres <- cast(usrgensc, userId ~ genres ,value= "avgsc")

# função para adicionar a significância e P values ao gráfico da correlação
cor.mtest <- function(mat, conf.level = 0.95){
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat <- lowCI.mat <- uppCI.mat <- matrix(NA, n, n)
  diag(p.mat) <- 0
  diag(lowCI.mat) <- diag(uppCI.mat) <- 1
  for(i in 1:(n-1)){
    for(j in (i+1):n){
      tmp <- cor.test(mat[,i], mat[,j], conf.level = conf.level)
      p.mat[i,j] <- p.mat[j,i] <- tmp$p.value
      lowCI.mat[i,j] <- lowCI.mat[j,i] <- tmp$conf.int[1]
      uppCI.mat[i,j] <- uppCI.mat[j,i] <- tmp$conf.int[2]
    }
  }
  return(list(p.mat, lowCI.mat, uppCI.mat))
}

#Abaixo vemos o processamento para a geração do gráfico
genrcor <- cor(usrgenres[,2:20],use ="complete.obs")
dimnames(genrcor) <- list(colnames(usrgenres[2:20]),colnames(usrgenres[2:20]))
res1 <- cor.mtest(usrgenres[,2:20],0.95)   #retira a coluna do userId
m <- genrcor
p <- cor.mtest(usrgenres[,2:20])





