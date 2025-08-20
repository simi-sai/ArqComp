# File saved with Nlview 7.0r4  2019-12-20 bk=1.5203 VDI=41 GEI=36 GUI=JA:9.0 TLS
# 
# non-default properties - (restore without -noprops)
property attrcolor #000000
property attrfontsize 8
property autobundle 1
property backgroundcolor #ffffff
property boxcolor0 #000000
property boxcolor1 #000000
property boxcolor2 #000000
property boxinstcolor #000000
property boxpincolor #000000
property buscolor #008000
property closeenough 5
property createnetattrdsp 2048
property decorate 1
property elidetext 40
property fillcolor1 #ffffcc
property fillcolor2 #dfebf8
property fillcolor3 #f0f0f0
property gatecellname 2
property instattrmax 30
property instdrag 15
property instorder 1
property marksize 12
property maxfontsize 12
property maxzoom 5
property netcolor #19b400
property objecthighlight0 #ff00ff
property objecthighlight1 #ffff00
property objecthighlight2 #00ff00
property objecthighlight3 #ff6666
property objecthighlight4 #0000ff
property objecthighlight5 #ffc800
property objecthighlight7 #00ffff
property objecthighlight8 #ff00ff
property objecthighlight9 #ccccff
property objecthighlight10 #0ead00
property objecthighlight11 #cefc00
property objecthighlight12 #9e2dbe
property objecthighlight13 #ba6a29
property objecthighlight14 #fc0188
property objecthighlight15 #02f990
property objecthighlight16 #f1b0fb
property objecthighlight17 #fec004
property objecthighlight18 #149bff
property objecthighlight19 #eb591b
property overlapcolor #19b400
property pbuscolor #000000
property pbusnamecolor #000000
property pinattrmax 20
property pinorder 2
property pinpermute 0
property portcolor #000000
property portnamecolor #000000
property ripindexfontsize 8
property rippercolor #000000
property rubberbandcolor #000000
property rubberbandfontsize 12
property selectattr 0
property selectionappearance 2
property selectioncolor #0000ff
property sheetheight 44
property sheetwidth 68
property showmarks 1
property shownetname 0
property showpagenumbers 1
property showripindex 4
property timelimit 1
#
module new multi_compuerta work:multi_compuerta:NOFILE -nosplit
load symbol IBUF hdi_primitives BUF pin O output pin I input fillcolor 1
load symbol OBUF hdi_primitives BUF pin O output pin I input fillcolor 1
load symbol LUT4 hdi_primitives BOX pin O output.right pin I0 input.left pin I1 input.left pin I2 input.left pin I3 input.left fillcolor 1
load symbol LUT2 hdi_primitives BOX pin O output.right pin I0 input.left pin I1 input.left fillcolor 1
load port a input -pg 1 -lvl 0 -x 0 -y 250
load port b input -pg 1 -lvl 0 -x 0 -y 180
load port c input -pg 1 -lvl 0 -x 0 -y 110
load port d input -pg 1 -lvl 0 -x 0 -y 40
load port e output -pg 1 -lvl 4 -x 520 -y 160
load port f output -pg 1 -lvl 4 -x 520 -y 270
load inst a_IBUF_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 1 -x 40 -y 250
load inst b_IBUF_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 1 -x 40 -y 180
load inst c_IBUF_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 1 -x 40 -y 110
load inst d_IBUF_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 1 -x 40 -y 40
load inst e_OBUF_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 3 -x 400 -y 160
load inst e_OBUF_inst_i_1 LUT4 hdi_primitives -attr @cell(#000000) LUT4 -pg 1 -lvl 2 -x 260 -y 130
load inst f_OBUF_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 3 -x 400 -y 270
load inst f_OBUF_inst_i_1 LUT2 hdi_primitives -attr @cell(#000000) LUT2 -pg 1 -lvl 2 -x 260 -y 260
load net a -port a -pin a_IBUF_inst I
netloc a 1 0 1 NJ 250
load net a_IBUF -pin a_IBUF_inst O -pin e_OBUF_inst_i_1 I3
netloc a_IBUF 1 1 1 180J 200n
load net b -port b -pin b_IBUF_inst I
netloc b 1 0 1 NJ 180
load net b_IBUF -pin b_IBUF_inst O -pin e_OBUF_inst_i_1 I2
netloc b_IBUF 1 1 1 NJ 180
load net c -port c -pin c_IBUF_inst I
netloc c 1 0 1 NJ 110
load net c_IBUF -pin c_IBUF_inst O -pin e_OBUF_inst_i_1 I1 -pin f_OBUF_inst_i_1 I1
netloc c_IBUF 1 1 1 160 110n
load net d -port d -pin d_IBUF_inst I
netloc d 1 0 1 NJ 40
load net d_IBUF -pin d_IBUF_inst O -pin e_OBUF_inst_i_1 I0 -pin f_OBUF_inst_i_1 I0
netloc d_IBUF 1 1 1 200 40n
load net e -port e -pin e_OBUF_inst O
netloc e 1 3 1 NJ 160
load net e_OBUF -pin e_OBUF_inst I -pin e_OBUF_inst_i_1 O
netloc e_OBUF 1 2 1 NJ 160
load net f -port f -pin f_OBUF_inst O
netloc f 1 3 1 NJ 270
load net f_OBUF -pin f_OBUF_inst I -pin f_OBUF_inst_i_1 O
netloc f_OBUF 1 2 1 NJ 270
levelinfo -pg 1 0 40 260 400 520
pagesize -pg 1 -db -bbox -sgen -60 0 580 330
show
zoom 0.721212
scrollpos -81 -35
#
# initialize ictrl to current module multi_compuerta work:multi_compuerta:NOFILE
ictrl init topinfo |
