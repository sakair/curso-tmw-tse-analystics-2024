import pandas as pd
import sqlalchemy
import streamlit as st
from utils import make_scatter

engine = sqlalchemy.create_engine("sqlite:///../../data/database.db")

with open ("etl_partidos.sql", "r") as open_file:
    query = open_file.read()

df = pd.read_sql(query, engine)

st.markdown("## TSE Analytics - Eleições 2024")

uf_options = df["SG_UF"].unique().tolist()
uf_options.remove("BR")
uf_options = ["BR"] + uf_options

estado = st.sidebar.selectbox(label="Estado", placeholder="Selecione o estado para análise", options=uf_options)

data = df[df["SG_UF"] == estado]

fig = make_scatter(data, size=True)

st.pyplot(fig)