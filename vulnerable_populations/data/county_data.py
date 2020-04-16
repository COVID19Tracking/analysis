import pandas as pd
from util.munge import state_full_names

def nyt_county_data():
    """The NYT dataset provides a case report each day per county"""
    nyt = pd.read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv")
    nyt = nyt.loc[nyt["date"] == nyt["date"].max()]
    return nyt


def cds_county_data():
    cds = pd.read_csv("https://coronadatascraper.com/data.csv")
    cds = cds \
        .loc[(cds["country"] == "United States") & (~cds["county"].isnull())] \
        .drop(["name","city","country","countryId","stateId","lat","long","url","aggregate","tz",
               "countyId","featureId","level"], axis=1)
        
    cds["county"] = cds["county"].apply(lambda x: x.replace("County", "").strip())
    return cds
