# CV-Analysis
Parsing and Analysis of Sociology Professors CV, to trace movement through universities over their educational and professional careers. Done to assist friends who close to completing their Ph.D. research and will soon be on the academic job market.


# Input Data
I am taking as an input the CV of every professor from US sociology departments, starting with the most popular. I have a goal of the top 100 departments, but every school requires additional manual cleaning and that will be a major limiting factor.
I've chosen to focus on one particular academic field, which is most pertinent to my research question, concerning my friend's sociology employment prospects. It also provides the important advantage of limiting the # of CVs per school and thus increasing the # of schools anlayzed.


# Initial Parsing
Parsing tools for resumes and CVs already exist, so I can use them instead of building my own. These are not perfect (and more commonly designed for resumes and not academic CVs), so manually reviewing and cleaning the results will be nececary.
I am using Sovern (sovren.com). There is a free trial for parsing 2 batches of 60 CVs if yo want to replicate with different professors.
Sovern produces, among other files, a JSON file, from which we will be extracting the data we care about. For now, the focus is only on education and employment, particularly the academic institution of each. 


# Manual Cleaning
Sovern does a good but not great job at parsing CVs. It requires a manual scrub after processing the JSON data before analysis. An inevitable roadbump when parsing text.

# Analysis
The principal concern is tracing the institutions each individual moves through, in a social network analysis-y fashion. 
Accounting for school ranking, and seeing when/what stages/how often people move up and down rankings is particularly important. 
