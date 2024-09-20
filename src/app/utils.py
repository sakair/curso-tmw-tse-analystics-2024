import matplotlib.pyplot as plt
import seaborn as sns
from adjustText import adjust_text
from sklearn import cluster


def make_scatter(data, cluster=False, size=False):

    config = {
        "data":data,
        "x":"tx_feminino",
        "y":"tx_raca_cor_preta",
        "size":"total_candidaturas",
        "sizes":(10, 200),
        "hue":"cluster",
        "palette":"viridis",
        "alpha":0.6
    }

    if not cluster:
        del config['hue']

    if not size:
        del config['size']
        del config['sizes']

    fig = plt.figure(dpi=200)

    sns.scatterplot(**config)

    texts = []
    for i in data["SG_PARTIDO"]:
        data_tmp = data[data["SG_PARTIDO"] == i]
        x = data_tmp["tx_feminino"].values[0]
        y = data_tmp["tx_raca_cor_preta"].values[0]
        texts.append(plt.text(x, y, i, fontsize=9))

    adjust_text(texts,
                only_move={"points": "y", "texts": "xy"},
                arrowprops=dict(arrowstyle="-", color='black', lw=0.2),
                pull_threshold=1000,
                )

    plt.grid(True)
    plt.suptitle("Cor vs Gênero - Eleições 2024")

    if size:
        plt.title("Quanto maior a bolha, maior o tamanho (número de candidaturas) do partido", fontdict={"size": 9})

    plt.xlabel("Taxa de mulheres")
    plt.ylabel("Taxa de pessoas pretas")

    tx_cor_raca_preta = data["total_raca_cor_preta"].sum() / data["total_candidaturas"].sum()
    tx_feminino = data["total_feminino"].sum() / data["total_candidaturas"].sum()

    plt.hlines(y=tx_cor_raca_preta,
               xmin=data["tx_feminino"].min(),
               xmax=data["tx_feminino"].max(),
               colors="black",
               linestyles="--",
               label=f"Taxa pretos: {100*tx_cor_raca_preta:.0f}%"
               )
    plt.vlines(x=tx_feminino,
               ymin=data["tx_raca_cor_preta"].min(),
               ymax=data["tx_raca_cor_preta"].max(),
               colors="tomato",
               linestyles="--",
               label=f"Taxa mulheres: {100*tx_feminino:.0f}%"
               )

    handles, labels = plt.gca().get_legend_handles_labels()
    handles = handles[-2:]
    labels = labels[-2:]

    plt.legend(handles=handles, labels=labels)

    return fig

def make_clusters(data, n=6):
    model = cluster.KMeans(n_clusters=n, random_state=42)
    model.fit(data[["tx_feminino", "tx_raca_cor_preta"]])
    data["cluster"] = model.labels_
    return data