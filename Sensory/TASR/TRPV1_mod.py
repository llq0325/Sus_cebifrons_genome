from ete3 import PhyloTree, TreeStyle,PhyloNode, SequenceFace, faces,NodeStyle,AttrFace,add_face_to_node,SeqMotifFace,TextFace

alg = """
>SCEB
TTTTCCACAGCTGTGGTGACACTAATCGAGGATGGAAAGAATGACTCTGTGTCGACGGAG---GTGTTACACAAGTGTCGAGGGCTTGTCTGCCGGTCGCCAGACAGCTCCTACAACAGCCTGTACTCCACGTGCC
>pig
TTTTCCACAGCTGTGGTGACACTGATCGAGGATGGAAAGAATGACTCTGTGTCGACGGAG---------------TGTCGAGGGCTTGTCTGCCGGTCGCCAGACAGCTCCTACAACAGCCTGTACTCCACGTGCC
>human
TTTTCCACAGCGGTGGTGACGCTGATTGAAGACGGGAAGAATGACTCCCTGCCGTCTGAGTCCACGTCGCACAGGTGGCGGGGGCCTGCCTGCAGGCCCCCCGATAGCTCCTACAACAGCCTGTACTCCACCTGCC
>cattle
TTTTCCACAGCGGTGGTGACACTGATTGAGGATGAAAAGAATGACTCTGTGTCGGTCGAGTTGTCGCAACACAGGTGGCGAGGGCACGGCTGCCGGTCGGCCGAC---AGCTACAACAGCCTGTACTCCACGTGTC
>dog
TTTTCCACAGCGGTGGTGACGCTGATTGAGGATGGGAAGAATAACTCTGTGCCGACTGAGTCCACATTGCATAGGTGGCGAGGGCCTGGCTGCCGGCCACCTGACAGCTCCTACAATAGCCTGTACTCCACGTGTC
>mouse
TTTTCCACAGCCGTAGTGACACTGATCGAGGATGGGAAGAATAACTCACTGCCTGTGGAGTCCCCACCACACAAGTGTCGGGGATCTGCCTGCAGG---CCAGGTAACTCTTACAACAGCCTGTATTCCACATGTC
>horse
TTTTCCACAGCGGTGGTGACACTGATTGAGGACGGGAAGAATGACTCCGTGCTGGCTGAATCCACGTCACACAGGTGGCGAGGGCATGGCTGCCGGTCACCTGACAGCTCCTACAATAGCCTGTACTCCACGTGTC
"""
RS_file = open("TRPV1.RS.txt")
RS=[]
for i in RS_file:
    RS.append(i.strip())
#nameFace = faces.AttrFace("name", fsize=20, fgcolor="#009000")

#def mylayout(node):
#    if node.is_leaf():
#        N = AttrFace("name", fsize=20)
#        faces.add_face_to_node(N, node, 0, position="aligned")
def mylayout(node):
    F = TextFace(node.name, tight_text=True,fsize=20)
    add_face_to_node(F, node, column=0)
    if node.is_leaf():
        seq_face = SeqMotifFace(node.sequence, seqtype='nt', seq_format='seq',width=200,scale_factor=1.4,height=20)
        add_face_to_node(seq_face, node, column=0, position='aligned')


def get_example_tree():

    # Performs a tree reconciliation analysis
    gene_tree_nw = '(mouse:0.12933786513614103919,((cattle:0.06251612271394246800,(pig:0.00174965857541787640,SCEB:0.02911432898223225568):0.06049543811361113993):0.01691616004391359451,(dog:0.06918563033722766042,horse:0.08450452840922352549):0.00418700925912216318):0.02078368850452259886,human:0.07758636498313556396):0.0;'
    genetree = PhyloTree(gene_tree_nw)
    genetree.link_to_alignment(alg)
    ts=TreeStyle()
    ts.layout_fn = mylayout
    genetree.link_to_alignment(alg)
    return genetree, ts


# Visualize the reconciled tree
t, ts = get_example_tree()

#ts.layout_fn = mylayout

ts.show_leaf_name = False
ts.branch_vertical_margin = 25
#t.show(tree_style=ts)
#t.unroot()
#t.set_outgroup( t&"mouse" )
ancestor = t.get_common_ancestor("horse","pig")
t.set_outgroup(ancestor)
#R = t.get_midpoint_outgroup()
#t.set_outgroup(R)
ic_plot = faces.SequencePlotFace(RS, fsize=15, col_width=14, header="GERP score", kind='curve', ylabel="RS",hlines = [-0.56, 0.11, 0.47],ylim=[-1,1],hlines_col=['#b86254','#b86254','#b86254'])
ts.aligned_header.add_face(ic_plot, 0) 
style = NodeStyle()
style["fgcolor"] = "#3284d1"
style["size"] = 5
style["shape"] = "circle"
style["vt_line_color"] = "#0f0f0f"
style["hz_line_color"] = "#0f0f0f"
style["vt_line_width"] = 2.5
style["hz_line_width"] = 2.5
style["vt_line_type"] = 0 # 0 solid, 1 dashed, 2 dotted
style["hz_line_type"] = 0
t.set_style(style)
#t.children[0].img_style=style
#t.children[1].img_style=style
for l in t.traverse():
    l.set_style(style)
for l in t.iter_leaves():
    l.img_style = style
#t.link_to_alignment(alg)
t.show(tree_style=ts)
t.render("TRPV1.phylotree.pdf",w=1750,tree_style=ts)
