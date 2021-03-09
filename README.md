# Network Breaks Analysis, SAA 2021

This document provides code for conducting the "Network Breaks" analysis that was presented by Matt Peeples at the online 2021 Annual meeting of the Society for American Archaeology Meeting in Zoom-land, USA.

Peeples, Matthew A. (2021) Networks, Community Detection, and Critical Scales of Interaction in the U.S. Southwest/Mexican Northwest. Paper presented at the 86th Annual Meeting of the Society for American Archaeology, Zoom-land, USA. April 15-17.

This paper was part of the Session: Defining Communities and Neighborhoods with Social Network Analysis organized by Adrian Chase and April Kamp-Whittaker

## Abstract

Archaeologists have long recognized that spatial relationships are an important influence on and driver of all manner of social processes at scales from the local to the continental or even beyond. Recent research in the realm of complex networks focused on community detection in human networks suggests that there may be certain critical scales at which human spatial interactions can be partitioned, allowing researchers to draw boundaries that provide insights into a variety of social phenomena. Thus far, this research has been focused on short time scales and has not explored the legacies of historic relationships on the evolution of network communities and boundaries over the long-term. In this paper, I examine networks based on material cultural similarity drawing on a large settlement and material culture database from the U.S. Southwest/Mexican Northwest (ca. A.D 800-1800; encompassing over 1,000,000 square kilometers) divided into a series of short temporal intervals. With these temporally sequenced networks I: 1) explore the utility of several methods of network community detection, 2) evaluate whether there are key phase transitions in the scales of network communities, and 3) explore the role of previous network configurations in the evolution of network communities through time. 


## Example Data

Because this method relies on site locations and those cannot be freely posted online, I have created a set of modified site locations that are jittered between 10-20 kilometers from the original site location at random and then a randomly generated vector of numbers was subtracted from the resulitng locations. Thus, the locations in the file "site_locations.csv" are somewhat realistic in terms of spaces between settlements and clustering but do not represent actual site locations. The file "sim_matrix.csv" contains real similarity scores among settlements in the CyberSW study area but site names have been replaced with a sequential index. Thus, the example files presented here provide realistic but not real data to avoid issues of sharing sensitive location information.

## Code and Analyses

The code provided conducts the following steps in order:

1) Initialize required libraries and read in data from csv files.

2) Create a distance matrix among all sites based on location information.

3) Create networks constrained based on distances in percentiles from 1 to 100 and define partition membership for each distance using Louvain clustering. 

4) Compare the partition membership from every one of the 100 distance percentiles to every other distance percentile using the Adjusted Rand Index. 

5) Define breaks in the similarity matrix of Rand Indices defined above using an interative agglomerative algorithm across all distances.

6) Calculate prototypical distances for each partition defined as the distance that is most similar to all others in the partition.

7) Plot the matrix of Rand Indices with breakpoints and prototypical scales shown as a ggplot tile plot.

8) Create Voronoi polygons around all site locations with boundaries defined as polygon edges that have different partition memberships on either side for a selected distance.

9) Plot the results of the above on a map with sites colored by partition membership and Voronoi polygon boundaries between partitions shown.

Note that this code will likely take several minutes to run depending on the processing power available.

## Continuing Work

This project is a work in progress and I will continue to update this code and these analyses and will point to any new products generated based on this analysis within this GitHub page. If you have any questions or want to discuss/collaborate on this research email me at Matthew.Peeples@asu.edu.


