Problem 1
=========

a\. First, we try a linear regression models for the sales series to see
if this regression model is suitable. The linear regression model is
represented as ${\hat{x}}_{t} = b_{0} + b_{1}t$

In which ${\hat{x}}_{t}$ is the monthly sales

b~0~ is the intercept, b~1~ is the coefficient for time, t is time

&gt; stime=time(sales)

&gt; sdata=coredata(sales)

We will regress monthly sales on time

&gt; salesreg=lm(sdata\~stime)

&gt; summary(salesreg)

  --------------------------------------------------------------------- --------------------------------------------------------------------
  Call:                                                                 ![](media/image1.png){width="3.5215277777777776in" height="2.5in"}
                                                                        
  lm(formula = sdata \~ stime)                                          
                                                                        
  Residuals:                                                            
                                                                        
  Min 1Q Median 3Q Max                                                  
                                                                        
  -274.80 -89.91 26.30 102.35 188.76                                    
                                                                        
  Coefficients:                                                         
                                                                        
  Estimate Std. Error t value Pr(&gt;|t|)                               
                                                                        
  (Intercept) -1.387e+05 2.473e+03 -56.07 &lt;2e-16 \*\*\*              
                                                                        
  stime 6.969e+01 1.234e+00 56.49 &lt;2e-16 \*\*\*                      
                                                                        
  ---                                                                   
                                                                        
  Signif. codes: 0 ‘\*\*\*’ 0.001 ‘\*\*’ 0.01 ‘\*’ 0.05 ‘.’ 0.1 ‘ ’ 1   
                                                                        
  Residual standard error: 117.3 on 248 degrees of freedom              
                                                                        
  Multiple R-squared: 0.9279, Adjusted R-squared: 0.9276                
                                                                        
  F-statistic: 3191 on 1 and 248 DF, p-value: &lt; 2.2e-16              
  --------------------------------------------------------------------- --------------------------------------------------------------------

As a result, the function obtained is
${\hat{x}}_{t} = - 1.387\  \times \ 10^{- 5} + 69.69t$

The residual standard error (RMSE) is 117.3. The residual plot for
linear regression exhibits a parabola trend around the mean (all
residuals tend to be positive for sales in the middle of time series and
negative for sales at the beginning and end of series). The parabolic
trend suggests that the addition of a second-order term may improve the
fit of the model. As a result, we will fit the quadratic regression
model.

&gt; salesreg2=lm(sdata\~stime + I(stime\^2))

&gt; summary(salesreg2)

lm(formula = sdata \~ stime + I(stime\^2))

Residuals:

Min 1Q Median 3Q Max

-105.519 -23.211 -2.175 24.703 95.641

Coefficients:

Estimate Std. Error t value Pr(&gt;|t|)

(Intercept) -1.393e+07 2.872e+05 -48.51 &lt;2e-16 \*\*\*

stime 1.383e+04 2.866e+02 48.27 &lt;2e-16 \*\*\*

I(stime\^2) -3.433e+00 7.147e-02 -48.03 &lt;2e-16 \*\*\*

---

Signif. codes: 0 ‘\*\*\*’ 0.001 ‘\*\*’ 0.01 ‘\*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 36.56 on 247 degrees of freedom

Multiple R-squared: 0.993, Adjusted R-squared: 0.993

F-statistic: 1.758e+04 on 2 and 247 DF, p-value: &lt; 2.2e-16

The quadratic regression model has a residual standard error of 36.56,
which is less than the RMSE of the linear regression model. The change
in time also explains about 99.3% of the variation in the data, compared
to 92.79% from the linear regression. Adding a second-term also
eliminates the parabola residual trend (Figure 3). As a result,
quadratic regression is more appropriate.

The equation for the quadratic model is:
${\hat{x}}_{t} = - 1.393 \times 10^{7} + 1.383 \times 10^{4}t - \ 3.43t^{2}$

Diagnostic: the residual plot indicates a good fit, since there are no
distinctive patterns in the plot. The residuals also have relatively
constant variance, so the residual is homoscedastic. The histogram of
residuals show there are a little outliers. Looking at the QQ plot, we
can see that majority of points follow a linear pattern, suggesting the
data are distributed as a standard normal ((X\~N(0,1)). All of the
coefficients in the regression are significant.

  ---------------------------------------------------------------------------------- -----------------------------------------------------------------------------------
  ![](media/image2.png){width="3.0910323709536307in" height="2.097014435695538in"}   ![](media/image3.png){width="3.0910345581802274in" height="2.0970155293088366in"}
                                                                                     
  Figure 1. QQ plot                                                                  Figure 2. Histogram of the residual
  ---------------------------------------------------------------------------------- -----------------------------------------------------------------------------------

  ---------------------------------------------------------------------------------- -----------------------------------------------------------------------------------
  ![](media/image4.png){width="3.443036964129484in" height="2.3358213035870516in"}   ![](media/image5.png){width="2.8490299650043744in" height="1.9328357392825897in"}
                                                                                     
  Figure 3. Residual plot                                                            Figure 4. Acf of the residual
  ---------------------------------------------------------------------------------- -----------------------------------------------------------------------------------

Lastly, we test for serial correlation in the residuals. The Acf
indicates lags 1, 2, 3 exceeds the significance bound. We perform Acf
and test Box-Ljung at lag 6 and 12.

esalesreg2=resid(salesreg2)

&gt; Box.test(esalesreg2, type="Ljung", lag=6)

data: esalesreg2

X-squared = 171.93, df = 6, p-value &lt; 2.2e-16

&gt; Box.test(esalesreg2, type="Ljung", lag=12)

data: esalesreg2

X-squared = 173.48, df = 12, p-value &lt; 2.2e-16

The Box-Ljung test confirms that the p-value is very small, which
rejects the null hypothesis that all of the lags up to lag 6 and lag 12,
respectively, are 0 at the same time, which means the there is serial
correlation in the residuals. Thus the assumption for statistical
independence of the errors is violated in this quadratic regression
model.

Therefore, we fit an ARIMA model for the correlation. First, we convert
the residual into a time series object and check for its weakly
stationarity condition.

&gt; residual.ts=ts(esalesreg2,start=c(1994,5),frequency=12)

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ ----------------------------------------------------------------------------------
  The plot shows that the series is distributed around the mean, 7.06768 ×10^-16^ (essentially 0), so constant mean condition is satisfied. The variance band also is constant throughout the time, thus the constant variance condition is also satisfied. Thus the residuals series is weakly stationary and we can fit ARIMA model. The p-value for the mean is 0.5 &gt; 0.05, so we fail to reject the null hypothesis that the mean is 0, so the mean is not significant.   ![](media/image6.png){width="3.858208661417323in" height="2.4864009186351708in"}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Figure 5. Plot of the residuals
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ ----------------------------------------------------------------------------------

The Acf earlier (Figure 4) shows that the first three lags are
significant. Lag 14 and 15 also exceed the significance bound but
probably they are too far away to have any effect. The Box-Ljung test
confirms that the first three lags are significant, so we choose max q
as 3.

![](media/image7.png){width="3.813432852143482in"
height="2.45754593175853in"}

Figure 6. Pacf of the residuals

The pacf tails off after lag 1. Lag 13 and 19 also exceed the
significance line but probably too far out to have any effect. Thus we
choose max p as 1. We run the auto arima function.

&gt; residual.arima=auto.arima(residual.ts,max.p=1, max.q=3,
max.P=0,max.Q=0, stationary=TRUE, ic="aic", stepwise=FALSE, trace=TRUE)

  ------------------------------------------------------
  &gt; residual.arima
  
  Series: residual.ts
  
  ARIMA(1,0,0) with zero mean
  
  Coefficients:
  
  ar1
  
  0.6782
  
  s.e. 0.0467
  
  sigma\^2 estimated as 717.1: log likelihood=-1176.95
  
  AIC=2357.9 AICc=2357.95 BIC=2364.94
  ------------------------------------------------------

    --
    --
  
  ------------------------------------------------------

![](media/image8.png){width="4.566666666666666in"
height="2.9430555555555555in"}We obtain the AR(1) model which has the
lowest AIC. The t-value is 14.522 so the coefficient is significant. We
perform the diagnostic on the model.

The residuals of the error term have fairly constant variance, thus it
is homoscedastic. There is no volatility cluster. The p-value also
indicates that there are no serial correlation for all the lags up to
lag 10, thus the residual is independent. As a result, we conclude the
AR(1) model for the residual is fit.

With ar1= 0.6782, the AR(1) model can be written as:

$$x_{t} - 0.6782x_{t - 1} = a_{t}$$

In which, $x_{t}$ and $x_{t - 1}$is the residual at time t and t-1,
respectively, $a_{t}$ is the white noise term

d\. The complete model for sales can be written as:

$$x_{t} = - 1.393 \times 10^{7} + 1.383 \times 10^{4}t - \ 3.43t^{2} + \varepsilon_{t}$$

in which $\varepsilon_{t} = 0.6782\varepsilon_{t - 1} + a_{t}\ $

x~t~ is the sales at time t, t is time, $\varepsilon_{t}$ is the
residual of the quadratic regression model, a~t~ is the white noise

e\. In order to forecast the completed model, we will forecast the
quadratic regression model and the residuals and add back together.

  2015                      Mar           Apr           May           Jun           July          August
  ------------------------- ------------- ------------- ------------- ------------- ------------- -------------
  Regression forecast       1526.058      1525.859      1525.611      1525.316      1524.973      1524.583
  Residuals forecast        42.894        29.091        19.730        13.381        9.075         6.155
  Add back                  1568.952      1554.950      1545.341      1538.697      1534.048      1530.738
  Predicted sales (units)   156,895,211   155,495,037   154,534,117   153,869,727   153,404,836   153,073,804

f\. The last six values of the sales data (Sep 2014 to Feb 2015) are
1549.215, 1541.583, 1556.153, 1582.427, 1595.539, 1589.457. From January
2015, we can see from the model that the future sales within the next
six months are on the trend of declining.

Problem 2
=========

a\. Before fitting stationary model, we check the series for weakly
stationary condition

![](media/image9.png){width="6.5in" height="3.995138888888889in"}The
mean of the series is -0.0028849 (horizontal line in the graph). The
mean for all the values from August 2002 to 2005 are higher than the
overall mean. The mean starts to decrease after 2005 but not to the
overall mean level. The lower values of the series after 2007 helps to
bring the mean down to the overall mean. Therefore, throughout the
series, constant mean is not satisfied and thus the series is not weakly
stationary. We will try differencing:

![](media/image10.png){width="6.5in" height="4.0in"}

The mean of the differenced series is -2.444444x 10^-5^. Throughout the
time, the series fluctuates around this value, so it has constant mean.
The variance band is also constant over time. Although there is some
value between 2005 and 2006 which has a peak, the value around that is
within the variance band. So the differenced series is weakly
stationary, and we can fit ARIMA model.

First we test for significant mean. The p-value for the test is
0.4549332, which is greater than 0.05, so we fail to reject the null
hypothesis that mean is 0 and conclude that mean is insignificant.

We check for Acf and pacf of the series.

  ---------------------------------------------------------------------------------------------------------------------------------------------- ------------------------------------------------------------------------------------
  The Acf indicates that lag 1 and 7 are significant. Lag 12 and 15 are also significant but probably they are too far out to have any effect.   ![](media/image11.png){width="3.6016786964129484in" height="2.2164173228346455in"}
  ---------------------------------------------------------------------------------------------------------------------------------------------- ------------------------------------------------------------------------------------

We can confirm if lag 1 and 7 are significant by performing Box-Ljung
test at lag 10

&gt; Box.test(diffcpi, type="Ljung", lag=10)

Box-Ljung test

data: diffcpi

X-squared = 33.072, df = 10, p-value = 0.0002649

The p-value is smaller than 0.05, thus we reject the null hypothesis
that all the lags up to lag 10 are 0 at the same time, so at least one
lag is significant. Since the Acf tails off after lag 7, we choose max q
as 7.

  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- -----------------------------------------------------------------------------------
  The pacf shows that lag 1, 2, 4, and 7 are significant. Lag 10, 14 and 17 are also significant but the lags around them have relatively small value, and these lags might be too far out to have any effect, so they might be spurious. Since pacf tails off after lag 7, we choose max p=7.   ![](media/image12.png){width="3.552238626421697in" height="2.1859930008748907in"}
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- -----------------------------------------------------------------------------------

&gt; diff.arima1=auto.arima(diffcpi,max.p=7, max.q=7, max.P=0,max.Q=0,
stationary=TRUE, ic="aic", stepwise=FALSE, trace=TRUE)

&gt; diff.arima1

Series: diffcpi

ARIMA(0,0,1) with zero mean

Coefficients:

ma1

-0.8527

s.e. 0.0502

sigma\^2 estimated as 2.794e-06: log likelihood=491.89

AIC=-979.77 AICc=-979.65 BIC=-974.58

Note that in the above auto arima, we choose max p = 7 to be
conservative. If we choose max p=5 (since values before and after lag 7
are very small), it would result in the same ARIMA(0,1,1) model. After
fitting the auto arima function, we see that ARIMA(0,1,1) is the zero
mean model with the lowest AIC. We will proceed with this model and
check its coefficient.

The t-value for ma1 is -16.99&lt;-2, so the coefficient is significant.

The model for the change in CPI can be written as:

$$\left( 1 - B \right)x_{t} = \left( 1 - 0.8527 \right)a_{t}$$

$$equivalent\ to:\ x_{t} - x_{t - 1} = \ a_{t} - 0.8527a_{t - 1}$$

In which: x~t~ is the change in CPI at time t, a~t~ is the white noise
term

c\. Diagnostic

![](media/image13.png){width="6.5in" height="4.0in"}

The diagnostic shows that the residuals are homoscedastic, since the
variance band is relatively constant in the first graph. The p-value at
lag 10 is also above the significance line, so the residuals for all the
lags up to 10 are independent. As a result, we conclude that the model
is fit

d\. In order to forecast, we rewrite the model as differencing of the
original series in order to forecast

&gt; diff.arima2=arima(cpidat,order=c(0,1,1))

&gt; predict(diff.arima2,6)

Using the predict() function in R, the next 6 values for the change in
CPI rates are:

               Dec 2010   Jan 2011   Feb 2011   Mar 2011   Apr 2011   May 2011
  ------------ ---------- ---------- ---------- ---------- ---------- ----------
  Value        -0.0038    -0.0038    -0.0038    -0.0038    -0.0038    -0.0038
  Percentage   -0.3802%   -0.3802%   -0.3802%   -0.3802%   -0.3802%   -0.3802%

e\. Examine conditional heteroscesdasticity

We run the Acf for the residuals square in the above model

  -------------------------------------
  &gt; Acf(diff.arima2\$residuals\^2)
  -------------------------------------

    --
    --
  
  -------------------------------------

![](media/image14.png){width="6.5in" height="4.0in"}

There is no significant lag in the model. We can confirm this by
performing Archtest at lag 6 and 12.

&gt; ArchTest(diff.arima2\$residuals, lag = 6)

ARCH LM-test; Null hypothesis: no ARCH effects

data: diff.arima2\$residuals

Chi-squared = 7.7656, df = 6, p-value = 0.2558

&gt; ArchTest(diff.arima2\$residuals, lag = 12)

ARCH LM-test; Null hypothesis: no ARCH effects

data: diff.arima2\$residuals

Chi-squared = 10.539, df = 12, p-value = 0.5688

In both cases, the p-value is greater than 0.05, so we fail to reject
the null hypothesis that there is no Arch effect. As a result, there is
no conditional heteroscedasticity. We will estimate the standard error
of the model.

&gt;
rmse3=sqrt(sum(diff.arima2\$residuals\^2)/length(diff.arima2\$residuals))

&gt; rmse3

\[1\] 0.001663111

The standard error of the residuals is 0.001663111.
