#!/bin/bash

# 文件路径设置
ARTICLES_XML="raw/article-data-*.xml"
OUTPUT_FILE="clean/articles.tsv"

#!/bin/bash

# 文件路径设置
ARTICLES_XML="raw/article-data-*.xml"
OUTPUT_FILE="clean/articles.tsv"

# 初始化输出文件，写入表头
echo -e "PMID\tYear\tTitle" > "$OUTPUT_FILE"

# 遍历每个 XML 文件
for file in $ARTICLES_XML
do

  # 读取整个文件内容
  content=$(cat "$file")

  # 提取 PMIDs
  pmid=$(echo "$content" | grep "<PMID" | sed 's/.*<PMID[^>]*>\(.*\)<\/PMID>.*/\1/')

  # 提取 Year
  year=$(echo "$content" | grep "<PubDate>" -A 3 | grep "<Year>" | sed 's/.*<Year>\(.*\)<\/Year>.*/\1/')

  # 提取 Title
  title=$(echo "$content" | grep "<ArticleTitle>" | sed 's/.*<ArticleTitle>\(.*\)<\/ArticleTitle>.*/\1/')

  #clean xml tag
  title=$(echo "$title" | sed 's/<i>//g')
  title=$(echo "$title" | sed 's/<\/i>//g')

  # 如果 Title 存在，则写入输出文件
  if [ -n "$pmid" ] && [ -n "$year" ] && [ -n "$title" ]; then
    echo -e "${pmid}\t${year}\t${title}" >> "$OUTPUT_FILE"
  fi
done

echo "Processing complete. Results saved to $OUTPUT_FILE"

echo "Done!"





