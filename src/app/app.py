import pandas as pd
import sqlalchemy
import streamlit as st
from utils import make_scatter, make_clusters

engine = sqlalchemy.create_engine("sqlite:///../../data/database.db")

with open ("etl_partidos.sql", "r") as open_file:
    query = open_file.read()

df = pd.read_sql(query, engine)

st.markdown("## TSE Analytics - Eleições 2024")

uf_options = df["SG_UF"].unique().tolist()
uf_options.sort()
uf_options.remove("BR")
uf_options = ["BR"] + uf_options

estado = st.sidebar.selectbox(label="Estado", placeholder="Selecione o estado para análise", options=uf_options)
size = st.sidebar.checkbox("Tamanho das bolhas")
cluster = st.sidebar.checkbox("Definir cluster")
n_clusters = st.sidebar.number_input("Quantidade de clusters", min_value=1, max_value=10, format="%d")

data = df[df["SG_UF"] == estado]

if cluster:
    data = make_clusters(data, n_clusters)

fig = make_scatter(data, cluster=cluster, size=size)

st.pyplot(fig)