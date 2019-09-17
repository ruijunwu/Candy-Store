# Campaign Strategy for Candy Store 

For binary variables, 1 means yes, 0 means no. The data(candy_data.csv) contains the following fields:

| **Header** | Description |
| --- | --- |
| chocolate | Does it contain chocolate? |
| fruity | Is it fruit flavored? |
|caramel	|Is there caramel in the candy?|
|peanutalmondy |	Does it contain peanuts, peanut butter or almonds?|
|nougat |	Does it contain nougat?|
|crispedricewafer|	Does it contain crisped rice, wafers, or a cookie component?|
|hard|	Is it a hard candy?|
|bar|	Is it a candy bar?|
|pluribus|	Is it one of many candies in a bag or box?|
|sugarpercent	| The percentile of sugar it falls under within the data set.|
|pricepercent|	The unit price percentile compared to the rest of the set.|
|winpercent|	The overall win percentage according to 269,000 matchups.|

The project includes three hypotheses, using t-test, proportion test and logistics regression to get the conclusion.

1. Hypothesis 1

We want to check among the candies with winpercent greater
than 50, if the proportion of chocolate is greater than fruity. 
H<sub>0</sub> : p<sub>chocolate</sub> = p<sub>fruity</sub> vs. H<sub>1</sub> : p<sub>chocolate</sub> > p<sub>fruity</sub>

2. Hypothesis 2

We would like to check if caramel candies contains more sugar than
the chocolate candies.

H<sub>0</sub> : &mu;<sub>chocolate</sub> = &mu;<sub>caramel</sub> vs. H<sub>1</sub> : &mu;<sub>chocolate</sub> < &mu;<sub>caramel</sub>


3. Hypothesis 3

It seems that the correlation between chocolate and winpercent, chocolate and bar is relatively
high(according to the heap map). So we want know whether a candy is a bar, whether a candy is fruity and overall win per-
centage are good predictors of whether the candy contains chocolate or not. Thus, we use generalizedlinearmodel in R.
