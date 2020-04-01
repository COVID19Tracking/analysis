from IPython.display import display, HTML
import pandas as pd


def max_print(df):
    """Print the entire contents of a dataframe"""
    with pd.option_context('display.max_rows', None, 'display.max_columns', None):
         display(HTML(df.to_html()))

def format_date(date:str) -> str:
    """return YYYYmmdd as YYYY-mm-dd"""
    return f"{date[:4]}-{date[4:6]}-{date[6:]}"
