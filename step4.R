# 加载必要的 R 包
library(tidyverse)
library(tidytext)

# 第一步：导入数据
articles <- read_tsv("clean/processed_titles.tsv")

# 第二步：分词
# 使用 tidytext 包的 unnest_tokens() 将标题分解为单词
titles_tokens <- articles %>%
  unnest_tokens(word, title)

# 第三步：计算词频
# 统计每个单词的总频率，并选择最常见的 12 个词
top_words <- titles_tokens %>%
  count(word, sort = TRUE) %>%
  top_n(12, n) %>%
  pull(word)

# 第四步：按年份计算这 12 个词的频率
# 过滤出最常见的词并按年份统计
word_year_counts <- titles_tokens %>%
  filter(word %in% top_words) %>%
  count(Year, word, sort = TRUE)

# 第五步：可视化
# 使用 ggplot2 绘制每个词在不同年份的频率变化
ggplot(word_year_counts, aes(x = Year, y = n, color = word, group = word)) +
  geom_line() +
  geom_point() +
  facet_wrap(~ word, scales = "free_y") +
  labs(title = "Top 10 Most Common Words Frequency Over Time",
       x = "Year",
       y = "Frequency",
       color = "Word") +
  theme_light() +
  theme(panel.grid.major.x = element_blank(), 
        panel.grid.minor = element_blank(), 
        legend.position = "bottom")

# 保存可视化图表到文件夹 "clean" 中
ggsave("clean/top_10_words_frequency_over_time.png", width = 12, height = 8)
