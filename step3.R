library(tidyverse)
library(tidytext)
library(SnowballC)

# load data
dta <- read_tsv('clean/articles.tsv')

# process titles
tokens <- dta %>%
  unnest_tokens(word, Title) %>% # Segmentation
  anti_join(stop_words) %>%                  # Remove stop words
  filter(!str_detect(word, "\\d")) %>%       # Remove digits
  mutate(word = wordStem(word, language = "en")) %>%  #Reduce words to their stem


  # 重新组合
  group_by(PMID, Year) %>%
  summarize(title = paste(word, collapse = " "), .groups = "drop")

# 保存结果
write_tsv(tokens, "clean/processed_titles.tsv")


