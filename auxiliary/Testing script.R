# Testing script
library(tidyverse)
library(lubridate)
# using tx housing data

txhousing

txhousing %>% distinct(city) %>% View
summary(txhousing$sales)
summary(txhousing$listings)


year <- 2010
month <- 10
cities <- c("Austin", "Fort Worth", "Dallas", "Houston", "San Antonio")
sales <- c(75:1000)
listings <- c(700:3000)


dat <- txhousing %>% 
  mutate(date = ym(paste(year, month, "-"))) %>% 
  filter(!is.na(median) & !is.na(listings)) %>% 
  filter(city %in% cities) %>%
  filter(sales %in% sales) %>% 
  filter(listings %in% listings)


mod <- lm(median ~ date + sales + listings, data = dat)
summary(mod)
date <- ym(paste(year, month, "-"))
pred <- predict(mod, newdata = data.frame(date = date))

plot <- dat %>% 
  ggplot(aes(date, median)) + 
  geom_point(alpha = 0.25) +
  geom_smooth(method = "lm") + 
  geom_hline(yintercept = pred, color = "red") +
  geom_vline(xintercept = date, color = "red") +
  labs(x = "Year/Month", y = "Median Sale Price") +
  scale_y_continuous(labels = scales::label_dollar(suffix =  "K", scale = 1/1000)) 
  

plot


pred2 <- predict(mod, newdata = data.frame(date = date),
                 interval = c("confidence"), level = 0.95)

pred2 <- paste0("$", format(pred2, digits = 2, big.mark = ","))


tibble("Predicted Median Price" = pred2[1],
       "95% Confidence Interval" = paste(pred2[2], pred2[3], sep = " - "))

paste0("$", format(pred2, digits = 2, big.mark = ","))

dat %>% 
  mutate(date = ym(paste0(year, month, "-"))) %>% 
  #filter(city == "Abilene") %>% 
  #filter(!is.na(median)) %>% 
  ggplot(aes(date, median)) + 
  geom_hline(yintercept = mean(dat$median), color = "red") +
  geom_point(alpha = 0.25) 
  # annotate("label", x = min(dat$date), y =  mean(dat$median), 
  #          label = "Average", color = "red") +
  # geom_hline(yintercept = c(quantile(dat$median, .25), quantile(dat$median, .75)), 
  #            color = "blue") +
  # annotate("label", x = c(min(dat$date), min(dat$date)), 
  #          y =  c(quantile(dat$median, .25), quantile(dat$median, .75)), 
  #          label = c("25%", "75%"), color = "blue") +
  # labs(x = "Year/Month", y = "Median Sale Price")





txhousing %>% 
  filter(!is.na(median) & !is.na(listings)) %>% nrow
  filter(if_any(everything(), is.na))


txhousing %>% distinct(city)

txhousing %>% 
  ggplot(ae)