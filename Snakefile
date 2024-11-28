rule all:
    input:
        "clean/top_10_words_frequency_over_time.png"

# Step 1: Run step1.sh to download PubMed IDs and article metadata
rule step1:
    output:
        "raw/pmids.xml"
    log:
        "logs/step1.log"
    shell:
        """
        mkdir -p raw logs
        bash step1.sh > {log} 2>&1
        """

# Step 2: Run step2.sh to process article XML files into a TSV
rule step2:
    input:
        "raw/pmids.xml"
    output:
        "clean/articles.tsv"
    log:
        "logs/step2.log"
    shell:
        """
        mkdir -p clean
        bash step2.sh > {log} 2>&1
        """

# Step 3: Run step3.R to process titles
rule step3:
    input:
        "clean/articles.tsv"
    output:
        "clean/processed_titles.tsv"
    log:
        "logs/step3.log"
    shell:
        """
        Rscript step3.R > {log} 2>&1
        """

# Step 4: Run step4.R to analyze and visualize the data
rule step4:
    input:
        "clean/processed_titles.tsv"
    output:
        "clean/top_10_words_frequency_over_time.png"
    log:
        "logs/step4.log"
    shell:
        """
        Rscript step4.R > {log} 2>&1
        """
