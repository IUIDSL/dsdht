library(plotly, quietly = T)

lex_raw <- read.csv("data/indicator life_expectancy_at_birth.csv", stringsAsFactors=FALSE)

#Need tidy CSV with year as integer column.

names(lex_raw)[names(lex_raw) == "Life.expectancy"] <- "country"
#lex_raw <- lex_raw[lex_raw$country !="", ]
lex_raw <- lex_raw[grepl("^\\w+", lex_raw$country, perl = T), ]
n_country <- length(lex_raw$country)


years <- colnames(lex_raw)[grepl("^X\\d+", colnames(lex_raw), perl = T)]
years <- as.integer(sub("^X", "", years))

lex <- data.frame(
  country = rep(lex_raw$country, length(years)), 
  year = rep(years, n_country), 
  val = rep(NA, n_country * length(years)))

lex$country <- as.factor(lex$country)

lex <- lex[order(lex$country, lex$year), ]


for (country in unique(lex$country))
{
  print(sprintf("DEBUG: %s\n", country))
  vals <- as.vector(lex_raw[lex_raw$country == country , -1])
  lex$val[lex$country == country] <- as.numeric(vals)
}

write.csv(lex, file = "data/gapminder_life_exp.csv")
p1 <- plot_ly(lex[lex$country == "Sweden", ], x = year, y = val, type = "scatter")
p1
