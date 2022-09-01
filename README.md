
# Mirnes Sabanovic - Data Analytics Portfolio Projects

### About


Hello, I'm Mirnes and welcome to my repository. I am a recent college graduate who discovered the world of data analytics in my final year of undergrad.
I developed a passion for this field which led to me learning many of the fundamental skills needed for data analysis. The below projects highlight the
skills that I have learned - from initial exploratory data analysis in MySQL, to visualizing insights in Tableau, cleaning data with SQL queries and even
discovering correlations using many popular data analysis libraries in Python like pandas, numpy, matplotlib and seaborn. I go into more depth on each
of these projects down below. I hope you enjoy and thank you for viewing!

### Table of Contents

- [About](#about)
- [Portfolio Projects](#portfolio-projects)
    + [Exploratory Data Analysis of NBA Box Score Statistics](#exploratory-data-analysis-of-nba-box-score-statistics)
    + [Interactive Tableau Dashboard of NBA Box Score Statistics](#interactive-tableau-dashboard-of-nba-box-score-statistics)
    + [Data Cleaning in MySQL of an Obesity Factors Dataset](#data-cleaning-in-mysql-of-an-obesity-factors-dataset)
    + [Fetal Health Correlations in Python](#fetal-health-correlations-in-python)
- [Acknowledgement and Inspiration](#acknowledgement-and-inspiration)
- [Contact](#contact)

# Portfolio Projects

Below, you will find details about all of the projects that I have created.

### Exploratory Data Analysis of NBA Box Score Statistics

**Code:** [GitHub Link](https://github.com/Mikano-S/PortfolioProjects/blob/main/NBA%20Exploratory%20Data%20Analysis.sql) <br />
**Description:** Some common advice given online when creating your own data analytics projects is to use datasets that are of interest to you. I love the
game of basketball and watching NBA games, so I decided to look into what are the most important factors for winning NBA games. To do this, I found a
dataset on [Kaggle](https://www.kaggle.com/datasets/nathanlauga/nba-games?select=teams.csv) which includes 19 seasons of box score statistics for every team. I imported the dataset into MySQL and used SQL queries to 
discover the most important statistics/factors for winning games. I utilized a wide variety of functions to accomplish this such as joins, temp
tables, common table expressions, joins, partition by statements, aggregate functions as well as creating views. <br />
**Skills:** Joins, Temporary Tables, Common Table Expressions, Partition By, Aggregate Functions, Views <br />
**Technology:** MySQL <br />
**Results:** I was able to narrow four of the most important statistics that are most associated with winning games and then created views for these results.
These views will be utilized in the next project to visualize the results in Tableau. <br />

### Interactive Tableau Dashboard of NBA Box Score Statistics

**Code:** [Tableau Public](https://public.tableau.com/app/profile/mirnes.sabanovic/viz/TheNBA-AMakeANDMissLeague/DBRESTORE) <br />
**Description:** Using Tableau Public, I visualize some of the most important factors associated with winning NBA games. These factors were
field-goal percentage, average points scored, average points allowed and average point differential. In this dashboard, the user is able to select any
of these statistics and see where each team in the league ranked for a given season. Furthermore, the user has the ability to only show the top ranking
teams for each statistic as well. For example, you can choose to highlight the top five teams based on average field-goal percentage for the 2005-2006
season. There is a high degree of interactivity in this dashboard for the end-user to utilize. <br />
**Skills:** Calculated Fields (applying a rank to various measures), Filtering Dimensions By Rank, Customizing Tooltips, Applying Custom Logos To Dimensions <br />
**Technology:** Tableau Public <br />
**Results:** Created an interactive dashboard which highlights the most important factors that NBA teams should focus on in order to win as many
games as possible. <br />

### Data Cleaning in MySQL of an Obesity Factors Dataset

**Code:** [GitHub Link](https://github.com/Mikano-S/PortfolioProjects/blob/main/Data%20Cleaning.sql) <br />
**Description:** Data cleaning is one of the most important skills for a data analyst to have in their toolbox which is why I wanted to devote an entire 
project just for this skill. I took a large [dataset](https://healthdata.gov/dataset/Nutrition-Physical-Activity-and-Obesity-Behavioral/fhdq-98vk)
which was a survey regarding factors related to obesity and I attempted to clean up the dataset
as best as possible. I employed standard data cleaning techniques such as deleting duplicate rows, populating empty/null values, removing irrelevant
characters from fields, combining columns and deleting unused columns. (Since this was a dataset for personal use, I wouldn't face much back-end issues with deleting unused columns,
although I would exercise extreme caution in doing so in a professional setting.) <br />
**Skills:** Data Cleaning <br />
**Technology:** MySQL <br />
**Results:** Transformed the dataset into a more complete, intuitive, and structurally sound dataset to allow for easier analysis in the future. <br />

### Fetal Health Correlations in Python

**Code:** [GitHub Link](https://github.com/Mikano-S/PortfolioProjects/blob/main/Fetal%20Health%20Correlations.ipynb) <br />
**Description:** For my final project, I utilized Python and some of the most popular data analysis libraries in order to determine correlations between
various test markers during pregnancy and fetal health outcomes. I obtained the dataset from [Kaggle](https://www.kaggle.com/datasets/andrewmvd/fetal-health-classification)
and imported it into Jupyter notebook to 
perform my analysis of the data. <br />
**Skills:** Python <br />
**Technology:** Python (numpy, pandas, matplotlib, pandas), Jupyter Notebook <br />
**Results:** Discovered moderate correlations between various fetal heart rate markers in utero and fetal health outcomes. Highlights the significance of
regular fetal health checkups. <br />

# Acknowledgement and Inspiration

I want to use this section to acknowledge GitHub user [Aleksandr Nikitin](https://github.com/nktnlx). His [ReadMe](https://github.com/nktnlx/data_analysis_portfolio)
from his data analysis portfolio repository was beautifully crafted and is where I got the inspiration to design my own ReadMe off of. <br />
A big thank you to Aleksandr for making that content publicly available. Great work!

# Contact

E-mail: sabanovicmirnes99@gmail.com <br />
LinkedIn: https://www.linkedin.com/in/mirnes-sabanovic/


