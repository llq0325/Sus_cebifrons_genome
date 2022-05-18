from ete3 import PhyloTree, TreeStyle,PhyloNode, SequenceFace, faces,NodeStyle,AttrFace,add_face_to_node,SeqMotifFace,TextFace

alg = """
>SCEB
tacagccagtgcaccatgaatggttccgacgtccccattcaaaacctctacagcaactacggtgactacaacaccacctattccattcaggcctgtattcgctcctgcttccaagagcacatgatccgtc
>pig
tacagccagtgcaccatgaatggttccgacgtccccattcaaaacctctacagcaactacggtgactacaacaccacctattccattcaggcctgtattcgctcctgcttccaagagcacatgatccgtc
>dog
tacagccagtgcaccgtgaacggctccgacgtccctgtgcgaaacctctacagtgactac---------aacacgacctactcaatccaggcctgtattcgctcctgcttccaagaccacatgatccaga
>human
tacagcccgtgcaccgtgaatggttctgaggtccccgtccaaaacttctacagtgactac---------aacacgacctactccatccaggcctgtcttcgctcctgcttccaagaccacatgatccgta
>horse
tacagccggtgcaccaagaacggctctgacgtccccatcccaaacctctacagcgaccac---------aacaccacctactccatccaggcctgtatccactcctgcttccaagaccacatgatccgta
>cattle
tacagccagtgcaccaagaacggctctgacgtccccatccaaaacctctacagcaactac---------aacacgacctactccatccaggcctgtattcgctcctgcttccaggagcacatgattcggg
>mouse
tacagtccctgcaccatgaacggctccgatgttgccataaagaacctctacagtgtctac---------aacaccacctattccatccaggcctgtcttcattcctgtttccaagaccacatgatccgta
"""
RS_file = open("RS.txt")
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
    gene_tree_nw = '(((cattle:0.07973223534364337617,(pig:0.00335611834393445812,SCEB:0.00309102218682263952):0.07172597467553934458):0.03410570905427974531,horse:0.08629206041372956826):0.00416755977587692124,(human:0.08771343351883632844,mouse:0.18758045536590248203):0.02959535075716982974,dog:0.06799886974097124615):0.0;'
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
ancestor = t.get_common_ancestor("human","mouse")
t.set_outgroup(ancestor)
ic_plot = faces.SequencePlotFace(RS, fsize=15, col_width=14, header="GERP score", kind='curve', ylabel="                    RS",hlines = [-0.48, 0.15, 0.58],hlines_col=['#b86254','#b86254','#b86254'])
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
t.render("phylotree.pdf",w=1750,tree_style=ts)
