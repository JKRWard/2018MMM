
#df needs time and rank at each point
df <- leaderboard


round1 <- select(df, Player_name, Total) %>% arrange(desc(Total)) %>% 
  mutate(Ranking = rank(Total, ties.method = "min")) %>% 
  mutate(Ranking = 17-Ranking) %>% 
  mutate(Round = 1) %>% 
  select(-Total)

round2 <- select(df, Player_name,Total) %>% 
  arrange(desc(Total)) %>% 
  mutate(Ranking = rank(Total, ties.method = "min")) %>% 
  mutate(Ranking = 17-Ranking) %>% 
  mutate(Round = 2) %>% 
  select(- Total)

round3 <- select(df, Player_name, Round_3) %>% arrange(desc(Round_3)) %>% 
  mutate(Ranking = rank(Round_3, ties.method = "min")) %>% 
  mutate(Ranking = 17-Ranking) %>% 
  mutate(Round = 3) %>% 
  select(Player_name, Ranking, Round)

round4 <- select(df, Player_name, Round_4) %>% arrange(desc(Round_4)) %>% 
  mutate(Ranking = rank(Round_4, ties.method = "min")) %>% 
  mutate(Ranking = 17-Ranking) %>% 
  mutate(Round = 4) %>% 
  select(Player_name, Ranking, Round)

round5 <- select(df, Player_name, Round_5) %>% arrange(desc(Round_5)) %>% 
  mutate(Ranking = rank(Round_5, ties.method = "min")) %>% 
  mutate(Ranking = 17-Ranking) %>% 
  mutate(Round = 5) %>% 
  select(Player_name, Ranking, Round)



ggplot(df, aes(year, rank, color = country)) +
  geom_bump()



####

round1 <- select(df, Player_name, Round_1) %>% arrange(desc(Round_1)) %>% 
  mutate(Ranking = rank(Round_1, ties.method = "min")) %>% 
  mutate(Ranking = 17-Ranking) %>% 
  mutate(Round = 1) %>% 
  select(-Round_1)

round2 <- select(df, Player_name,Round_1:Round_2) %>%
  mutate(Round_2 = Round_1 + Round_2) %>% 
  arrange(desc(Round_2)) %>% 
  mutate(Ranking = rank(Round_2, ties.method = "min")) %>% 
  mutate(Ranking = 17-Ranking) %>% 
  mutate(Round = 2) %>% 
  select(- Round_1, -Round_2)

round3 <- select(df, Player_name, Round_1, Round_2,Sweet_16) %>% 
  mutate(Sweet_16 = Round_1 + Round_2 + Sweet_16) %>%
  arrange(desc(Sweet_16)) %>% 
  mutate(Ranking = rank(Sweet_16, ties.method = "min")) %>% 
  mutate(Ranking = 17-Ranking) %>% 
  mutate(Round = 3) %>% 
  select(Player_name, Ranking, Round)

round4 <- select(df, Player_name, Round_1, Round_2, Sweet_16,Elite_8) %>% 
  mutate(Elite_8 = Round_1 + Round_2 + Sweet_16 + Elite_8) %>%
  arrange(desc(Elite_8)) %>% 
  mutate(Ranking = rank(Elite_8, ties.method = "min")) %>% 
  mutate(Ranking = 17-Ranking) %>% 
  mutate(Round = 4) %>% 
  select(Player_name, Ranking, Round)

round5 <- select(df, Player_name, Round_1, Round_2, Sweet_16,Elite_8, Final_roar) %>% 
  mutate(Final_roar = Round_1 + Round_2 + Sweet_16 + Elite_8 + Final_roar) %>% 
  arrange(desc(Final_roar)) %>% 
  mutate(Ranking = rank(Final_roar, ties.method = "min")) %>% 
  mutate(Ranking = 17-Ranking) %>% 
  mutate(Round = 5) %>% 
  select(Player_name, Ranking, Round)


rankall <- bind_rows(round1,round2,round3,round4,round5)

source(here::here("geom_bump.R"))
library(cowplot)
library(viridis)
library(ggrepel)
ggplot(rankall, aes(Round, Ranking, color = Player_name)) +
  geom_point(size = 7) +
  #geom_text(data = rankall %>% filter(Round == min(Round)),
           # aes(x = 0.5, label = Player_name), position=position_jitter(height=01),size = 4) +
  geom_text(data = rankall %>% filter(Round == max(Round)),
            aes(x = Round, label = Player_name),size = 4, hjust = -0.5) +
  geom_bump(aes(smooth = 8), size = 2) +
  scale_x_continuous(limits = c(1, 6),
                     breaks = seq(1, 5, 1)) +
  theme_minimal_grid(font_size = 14, line_size = 0) +
  theme(legend.position = "none",
        panel.grid.major = element_blank()) +
  labs(y = "RANK",
       x = "Round") +
  scale_y_reverse(breaks = seq(1, 16,1))+
  scale_color_manual(values = viridis(n = 16))

##

# checking 2020 file input ------------------------------------------------

library(readxl)

fils <- list.files (path = "2020MEP", pattern="*.xlsx") 

# create a list in which to store entries
fl <- list()

#loop through files and add to the list
#using here means that I can easily read files in a subdirectory
for (k in 1:length(fils)){
  fl[[k]] <- read_excel(here("2020MEP",fils[k]))
}


# format the data creating a single vector with all answers from each player
ans <- list()
for(j in 1:length(fl)){
  
  mast <- fl[[j]]
  wild <- mast %>%  select(`Wild Card`) %>%filter(!is.na(`Wild Card`)) %>% rename(Wildcard = `Wild Card`)
  a <- select(mast, Round_1...5:Round_5...9) %>% rename(Round_1 = Round_1...5,
                                                        Round_2 = Round_2...6,
                                                        Round_3 = Round_3...7,
                                                        Round_4 = Round_4...8,
                                                        Round_5 = Round_5...9)
  b <- select(mast, Round_5...11:Round_1...15) %>% rename(Round_1 = Round_1...15,
                                                          Round_2 = Round_2...14, 
                                                          Round_3 = Round_3...13, 
                                                          Round_4 = Round_4...12, 
                                                          Round_5 = Round_5...11 )
  
  cc <- bind_rows(a,b)
  r1 <- cc %>% select(Round_1) %>% filter(!is.na(Round_1))
  r1 <- r1$Round_1
  
  r2 <- cc %>% select(Round_2) %>% filter(!is.na(Round_2))
  r2 <- r2$Round_2
  
  r3 <- cc %>% select(Round_3) %>% filter(!is.na(Round_3))
  r3 <- r3$Round_3
  
  r4 <- cc %>% select(Round_4) %>% filter(!is.na(Round_4))
  r4 <- r4$Round_4
  
  r5 <- cc %>% select(Round_5) %>% filter(!is.na(Round_5))
  r5 <- r5$Round_5
  
  wild <- wild$Wildcard
  
  fin <- mast %>% select(Final) %>% filter(!is.na(Final))
  fin <- fin$Final
  
  out <- c(wild,r1,r2,r3,r4,r5,fin)
  # store the vector in a list
  ans[[j]] <- out
}


### counting points 

######################## generating the answers 
mast <- read_excel(here("2020AAnswers.xlsx"))
wild <- mast %>%  select(`Wild Card`) %>%filter(!is.na(`Wild Card`)) %>% rename(Wildcard = `Wild Card`)
a <- select(mast, Round_1...5:Round_5...9) %>% rename(Round_1 = Round_1...5,
                                                      Round_2 = Round_2...6,
                                                      Round_3 = Round_3...7,
                                                      Round_4 = Round_4...8,
                                                      Round_5 = Round_5...9)
b <- select(mast, Round_5...11:Round_1...15) %>% rename(Round_1 = Round_1...15,
                                                        Round_2 = Round_2...14, 
                                                        Round_3 = Round_3...13, 
                                                        Round_4 = Round_4...12, 
                                                        Round_5 = Round_5...11 )
cc <- bind_rows(a,b)
r1 <- cc %>% select(Round_1) %>% filter(!is.na(Round_1))
r1 <- r1$Round_1

r2 <- cc %>% select(Round_2) %>% filter(!is.na(Round_2))
r2 <- r2$Round_2

r3 <- cc %>% select(Round_3) %>% filter(!is.na(Round_3))
r3 <- r3$Round_3

r4 <- cc %>% select(Round_4) %>% filter(!is.na(Round_4))
r4 <- r4$Round_4

r5 <- cc %>% select(Round_5) %>% filter(!is.na(Round_5))
r5 <- r5$Round_5

wild <- wild$Wildcard

fin <- mast %>% select(Final) %>% filter(!is.na(Final))
fin <- fin$Final

master <- c(wild,r1,r2,r3,r4,r5,fin)

# 1 = same 0 = different -- ony get points for answers that are the same as the master


# check where in the list the master file is 
#ans


# create a list of players names

players <- sub("_", " ", fils) %>% sub(".xlsx", "",.)
#players <- sub(".csv", "", players)

### check answers 

scorelist <- list()
for (i in 1: length(players)){
  
  ## this checks answers for each round 
  playa <- ans[[i]]
  mstr <- master
  #mstr <- ans[[1]]
  rnd1 <- playa[1:33] == mstr[1:33]
  rnd2 <- playa[34:49] == mstr[34:49]
  sweet <- playa[50:57]==mstr[50:57]
  elite <- playa[58:61]==mstr[58:61]
  roar <- playa[62:63]==mstr[62:63]
  win <- playa[64]==mstr[64]
  
  
  pts <- c(sum(rnd1),sum(rnd2*2), sum(sweet*3), sum(elite*5), sum(roar*8),sum(win*13))
  scorelist[[i]] <- pts
}

leaderboard <- as.data.frame(do.call(rbind, scorelist))
colnames(leaderboard) <- c("Round_1", "Round_2", "Sweet_16", "Elite_8", "Final_roar", "Winner")
#tardy <- c(1,0,0,0,0,0,1,0,0,1,1,1,0)


leaderboard$Player_name <- players
#leaderboard$Tardigrade_tally <- tardy



leaderboard <- leaderboard %>% 
  select(Player_name,  Round_1, Round_2, Sweet_16, Elite_8, 
         Final_roar, Winner) %>% 
  mutate(Total= rowSums(.[2:7])) %>%
  arrange(desc(Total))

# creating a plot with cumulative points 
#create sum column for after each round 
pl_dat <- leaderboard %>% mutate(r2 = Round_1+Round_2) %>% mutate(r3 = r2+Sweet_16)

pl_dat <- leaderboard %>% 
  mutate(r1 =rowSums(.[2:3])) %>% 
  mutate(r2 =rowSums(.[2:4])) %>% 
  mutate(r3 =rowSums(.[2:5])) %>%
  mutate(r4 =rowSums(.[2:6])) %>% 
  mutate(r5 =rowSums(.[2:7])) %>% 
  rename(r6 = Total) %>%
  select(Player_name, r1, r2, r3, r4, r5, r6) %>% 
  gather("Round", "points", 2:7)

pl_dat$Round <- gsub("r","",pl_dat$Round)

p <- ggplot(data=pl_dat, aes(x=Round, y=points, group = Player_name, colour = Player_name)) + 
  geom_line() +
  ggtitle("Point accumulation")
#+ scale_colour_manual(values=cols) 

# working out the most popular winner
winners <- vector(length = length(players))

for (i in 1:length(winners)){
  
  this_one <- ans[[i]]
  winners[i] <- this_one[64]
  
}

outcomes <- data.frame(players, winners)
# creating line breaks for plotting 
levels(outcomes$winners) <- gsub(" ", "\n",levels(outcomes$winners))

