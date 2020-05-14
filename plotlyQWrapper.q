q)
facetplotdf:.p.eval["lambda x,y:facet_plot_df(x,y)";<]
plotlygo:.p.eval["lambda t: plotly_go(t['typ'],t['opts'])";<]
plotlyplot:.p.eval["lambda x: iplot(x)";<]


p)
import plotly.figure_factory as ff
from plotly.offline import iplot, init_notebook_mode
init_notebook_mode()
def facet_plot_df(qtable,options):
    return iplot(ff.create_facet_grid(pd.DataFrame(dict(qtable)),**dict(options)))
import plotly.graph_objs as go
def plotly_go(typ,options):
    fs=[getattr(go,x) for x in typ]
    data=[f(x) for x,f in zip(options,fs)]
    lay=([{}]+[elm for elm in data if isinstance(elm,go.Layout)])[-1]
    traces=[elm for elm in data if not isinstance(elm,go.Layout)]
    iplot(go.Figure(data=traces,layout=lay))
    return data
