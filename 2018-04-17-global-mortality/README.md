# Global Mortality

I decided to attempt to make some [sparklines](https://www.edwardtufte.com/bboard/q-and-a-fetch-msg?msg_id=0001OR) graphics. I used code from [Dr Lukasz Piwek](https://twitter.com/lukaszpiwek) and his [Tufte in R](http://www.motioninsocial.com/tufte/#sparklines) project. It's a great project and I hope I get chance to play with some of the other plots in the future.

I started off considering death by Cardiovascular diseases. 

I wrote some code which identified the 5 countries which the largest increase in share of death by cardiovascular diseases, and also the 5 countries with the largest decrease.
These 10 countries were then plotted as a sparkline, with the minimum and maximum values highlighted. 

I then wrapped this code as a function, and generated plots for all possible causes of death to look for interesting findings. 

![](https://github.com/trianglegirl/r4ds/blob/master/2018-04-17-global-mortality/figures/sparkline-Cardiovascular%20diseases.png)

As a quick plot, I'm fairly happy with this. However, as always there are many ways to improve. 

* Looping over all possible causes of death generates some weird plots, especially when the percentages are small.
* The Sparkline plots should probably be more information rich and have less white space to make Tufte happy.
* My function to create the sparkline plots should probably be chunked into smaller functions

Let me know what you think on [Twitter](https://twitter.com/trianglegirl). Suggestions/pull requests welcome!
