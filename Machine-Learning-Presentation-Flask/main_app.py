import random
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_auc_score, auc, roc_curve, precision_recall_curve
import matplotlib.pyplot as plt
plt.rc("font", size=14)
from flask import Flask,render_template,request
import numpy as np
from matplotlib.figure import Figure
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
from io import BytesIO
import base64


app_lulu = Flask(__name__)


class Generator:
    def __init__(self):
        self.expense_type = random.sample(['Air','Hotel'], 1)[0]
        self.amount = random.randint(5,21)*100


def store_dataframe(df, ob_dict):
    df_new = pd.DataFrame([ob_dict], columns = ob_dict.keys())
    return pd.concat([df, df_new], axis = 0)


def plot_roc(y_test, x_test, model):
    logit_roc_auc = roc_auc_score(y_test, model.predict(x_test))
    fpr, tpr, thresholds = roc_curve(y_test, model.predict_proba(x_test)[:, 1])
    plt.figure()
    plt.plot(fpr, tpr, label='Logistic Regression (area = %0.2f)' % logit_roc_auc)
    plt.plot([0, 1], [0, 1],'r--')
    plt.xlim([0.0, 1.0])
    plt.ylim([0.0, 1.05])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Receiver operating characteristic')
    plt.legend(loc="lower right")
    figfile = BytesIO()
    plt.savefig(figfile, format='png')
    figfile.seek(0)  # rewind to beginning of file
    figdata_png = base64.b64encode(figfile.getvalue())
    return figdata_png


def plot_auc_history(df):
    plt.figure()
    plt.plot(df['AUC'])
    plt.xlabel('Past AUCs')
    plt.ylabel('AUC Score')
    plt.title("AUC History")
    figfile = BytesIO()
    plt.savefig(figfile, format='png')
    figfile.seek(0)  # rewind to beginning of file
    figdata_png = base64.b64encode(figfile.getvalue())
    return figdata_png


def plot_coefficients(coef, intercept):
    plt.figure()
    objects = ('Intercept', 'Amount', 'Is_Air', 'Is_Hotel')
    y_pos = np.arange(len(objects))
    plt.barh(y_pos, np.append(intercept, coef), alpha=0.5)
    plt.yticks(y_pos, objects, fontsize=11)
    plt.xlabel('Coefficent value', fontsize=11)
    plt.title('Coefficients')
    figfile = BytesIO()
    plt.savefig(figfile, format='png')
    figfile.seek(0)  # rewind to beginning of file
    figdata_png = base64.b64encode(figfile.getvalue())
    return figdata_png


def plot_precision_recall_vs_threshold(precisions, recalls, thresholds):
    plt.figure()
    plt.title("Decision threshold")
    plt.plot(thresholds, precisions[:-1], "b--", label="Precision")
    plt.plot(thresholds, recalls[:-1], "g-", label="Recall")
    plt.ylabel("Score")
    plt.xlabel("Decision Threshold")
    plt.legend(loc='best')
    figfile = BytesIO()
    plt.savefig(figfile, format='png')
    figfile.seek(0)  # rewind to beginning of file
    figdata_png = base64.b64encode(figfile.getvalue())
    return figdata_png


# Generate a blank value - global var
obs = Generator()
df = pd.DataFrame(columns = ['Target', 'Amount', 'Expense Type'])
auc_history = []

@app_lulu.route('/review',methods=['POST', 'GET'])
def index_lulu():
    global obs
    global auc_history
    if request.method == 'GET':
        obs = Generator()
        amount_format = '${:.0f}'.format(obs.amount)
        return render_template('layout2.html', amount=amount_format, type=obs.expense_type)
    else:
        #POST
        # get data from user
        if request.form['User_Input'] == 'Fraud':
            target = 1
        elif request.form['User_Input'] == 'Not Fraud':
            target = 0
        amount = obs.amount
        expense_type = obs.expense_type
        ob_dict = {'Target': target, 'Amount': amount, 'Expense Type': expense_type}

        # append to existing data
        global df
        df = store_dataframe(df, ob_dict)
        features_df = pd.get_dummies(df, columns=['Expense Type'])


        if df.shape[0] < 10:
            obs = Generator()
            amount_format = '${:.0f}'.format(obs.amount)
            return render_template('layout2.html', amount=amount_format, type=obs.expense_type)
        else:
            # if enough data
            # create a new model
            logisticRegr = LogisticRegression()
            logisticRegr.fit(features_df.drop(columns=['Target']).values, features_df.Target.astype('int'))

            # predict on new data
            if expense_type == "Air":
                array1 = np.array([amount, 1, 0])
            else:
                array1 = np.array([amount, 0, 1])
            # estimate probability of new data
            y_proba_new = logisticRegr.predict_proba(array1.reshape(1, -1))[:, 1]


            # re-build model based on aggregated data
            features_df = pd.get_dummies(df, columns=['Expense Type'])
            x_train, x_test, y_train, y_test = train_test_split(features_df.drop(columns=['Target']).values,
                                                                features_df.Target.astype('int'), test_size=0.4,
                                                                random_state=0)


            logisticRegr = LogisticRegression()
            logisticRegr.fit(x_train, y_train)
            y_proba = logisticRegr.predict_proba(x_test)[:, 1]

            # change color
            if y_proba_new[0] > 0.5:
                risk_color = "#FF0000"
            elif y_proba_new[0] > 0:
                risk_color = "#00FF00"

            #plot roc curve
            fpr, tpr, thresholds = roc_curve(y_test, logisticRegr.predict_proba(x_test)[:, 1])
            auc_score = auc(fpr, tpr)
            auc_score = "%.2f" % auc_score
            roc_fig = plot_roc(y_test, x_test, logisticRegr)

            #plot AUC history
            auc_history.append(auc_score)
            auc_df = {'AUC': auc_history}
            auc_history_fig = plot_auc_history(auc_df)

            # plot coefficients
            coef_fig = plot_coefficients(logisticRegr.coef_, logisticRegr.intercept_)

            # plot decision threshold
            p, r, thresholds = precision_recall_curve(y_test, y_proba)
            decision_fig = plot_precision_recall_vs_threshold(p, r, thresholds)

            # Formatting
            y_proba_new = "%.2f%%" % (y_proba_new[0]*100)
            amount_format = '${:.0f}'.format(obs.amount)

            #generate a new value for next run
            obs = Generator()
            return render_template('layout2.html', amount=amount_format, type=obs.expense_type,
                                   risk = y_proba_new, risk_color = risk_color,
                                   roc_curve = roc_fig.decode('utf8'),
                                   auc_history = auc_history_fig.decode('utf8'),
                                   coef_fig = coef_fig.decode('utf8'),
                                   decision_fig=decision_fig.decode('utf8'))



if __name__ == '__main__':
    app_lulu.run(debug=True)
