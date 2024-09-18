from cProfile import label

import pandas as pd
import sqlalchemy
import matplotlib.pyplot as plt
import seaborn as sns
from adjustText import adjust_text
from sklearn import cluster

with open ("partidos.sql", "r") as open_file:
    query = open_file.read()

engine = sqlalchemy.create_engine("sqlite:///../data/database.db")

df = pd.read_sql_query(query, engine)

tx_feminino = df["total_feminino"].sum() / df["total_candidaturas"].sum()
tx_cor_raca_preta = df["total_raca_cor_preta"].sum() / df["total_candidaturas"].sum()
tx_cor_raca_nao_branca = df["total_raca_cor_nao_branca"].sum() / df["total_candidaturas"].sum()
tx_cor_raca_preta_parda = df["total_raca_cor_preta_parda"].sum() / df["total_candidaturas"].sum()


X = df[["tx_femininoBR", "tx_raca_cor_pretaBR"]]
model = cluster.KMeans(n_clusters=6)
model.fit(X)
df["clusterBR"] = model.labels_

plt.figure(dpi=200)
sns.scatterplot(data=df,
                x="tx_femininoBR",
                y="tx_raca_cor_pretaBR",
                size="total_candidaturas",
                sizes=(10,200),
                hue="clusterBR",
                palette="viridis",
                alpha=0.6)

texts = []
for i in df["SG_PARTIDO"]:
    data = df[df["SG_PARTIDO"]==i]
    x = data["tx_femininoBR"].values[0]
    y = data["tx_raca_cor_pretaBR"].values[0]
    texts.append(plt.text(x, y, i, fontsize=9))

adjust_text(texts,
            only_move={"points": "y", "texts":"xy"},
            arrowprops=dict(arrowstyle="-", color='black', lw=0.2),
            pull_threshold=1000,
            )

plt.grid(True)
plt.suptitle("Cor vs Gênero - Eleições 2024")
plt.title("Quanto maior a bolha, maior o tamanho (número de candidaturas) do partido", fontdict={"size": 9})
plt.xlabel("Taxa de mulheres")
plt.ylabel("Taxa de pessoas pretas")
plt.hlines(y=tx_cor_raca_preta,
           xmin=0.3,
           xmax=0.55,
           colors="black",
           linestyles="--",
           label=f"Taxa pretos: {100*tx_cor_raca_preta:.2f}%"
           )
plt.vlines(x=tx_feminino,
           ymin=0.05,
           ymax=0.35,
           colors="tomato",
           linestyles="--",
           label=f"Taxa mulheres: {100*tx_feminino:.2f}%"
           )

handles, labels = plt.gca().get_legend_handles_labels()
handles = handles[13:]
labels = labels[13:]

plt.legend(handles=handles, labels=labels)

plt.savefig("../img/partidos_cor_raca_genero.png")
plt.show()

