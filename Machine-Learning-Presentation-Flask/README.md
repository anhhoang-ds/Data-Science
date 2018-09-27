# Building a simple Machine Learning application using Flask

<a href="https://imgflip.com/gif/2iupq6"><img src="https://i.imgflip.com/2iupq6.gif" title="made at imgflip.com"/></a>

This application intends to build a simple logistic regression to educate non-technical users about machine learning. The idea is to design a simple interface so users can input training data and see that the model can "learn" and output its classification.

## Getting Started

The scenario that we are trying to build is we are trying to detect fraudulent activity from employee expense submission. There are two main types of expense: Air Travel and Hotel. We want to generate a handful of examples by asking users to validate whether an expense is fradulent or not. After that, we will build a logistic regression model and provide prediction in real time.

### Prerequisites

In addition to building a machine learning model, deploying them will require some additional libraries.

Flask - building a web application on a remote port.
<br>
HTML - a one page layout to serve as an user input section and display the result


## Building the Application

There are multiple steps in this building this application. I will skim through the model building part - this can be any model that you have developed in the past. I tend to choose models that are easier to explain such as logistic regression and linear regression as their output graphs are easier to view and interpret. You could try other models such as SVM or classification tree for advanced users, in that case, you would need to rethink what graphs/outputs you want to show for effective presentation.

### Getting the Data

We would build a class `Generator` which contains two data attributes: `expense_type` and `amount`:
```
class Generator:
    def __init__(self):
        self.expense_type = random.sample(['Air','Hotel'], 1)[0]
        self.amount = random.randint(5,21)*100
```

<b>Expense Type</b>: Air or Hotel
<br>
<b>Amount</b>: Random number between 500 and 2100, increment by 100.

After these two attributes are generated, we would need the target variable `Target`, which contains two value: 0 for non-fraud, and 1 for fraud. We then convert these attributes to a row and append to an existing dataframe. For simplicity, any hotel transaction more than `$1500` or any air travel transaction more than `$1000` will be classified as fraud. 


### Building a logistic regression model

After we have a big enough dataframe (in this case, when the total rows is greater than 10). We will start to build a simple logistic classifier using sci-kit learn

### Plotting graphs 
Since the goal of the application is to educate non-technical users about machine learning, we prefer to use graph to display how models improve (or learn) over time. The four graphs that I chose to present:

- Coefficients: display how each coefficients affect the outcome of the target
- ROC Curve: a good classifier stays as far away from the diagonal line as possible
- AUC History: tracking how the model performs over time
- Decision Thresholds: display the threshold when the classifer makes the decision Fraud/Not Fraud

### Web layout
My webpage consists of a very simple template with one sidebar to interact with users, and a large space to display four graphs above.

Please view the `templates` folder for the Web HTML layout


### Deployment

When the application is deployed, head over to `127.1.0.0/review/` on your local machine to see the results

## Learning Outcomes

- The model needs some data to begin with to distinctly classify the difference between Fraud and Non-Fraud. As can be seen, when the number of data is small, the model behaves erratically. After a certain number of data points, the model will improve its performance. This can be demonstrated by the ROC Curve and AUC History
- Once an user makes a mistake, for example, he/she classify a non-fraud transaction as a fraud transaction or vice versa, the model's performance will drop. Eventually after a few more iteration, it will start to pick up again.
