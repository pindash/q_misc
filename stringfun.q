
 #0 - Multiplicity
  f["fhqwhgads";"h"]
2
  f["mississippi";"s"]
4
  f["life";"."]
0

f:{sum x=y}

 #1 - Trapeze Part
  f "racecar"
1
  f "wasitaratisaw"
1
  f "palindrome"
0
f:{x~reverse x}
 #2 - Duplicity
  f "applause"
"ap"
  f "foo"
,"o"
  f "baz"
""
f:{where 1<count each group x} 
 #3 - Sort Yourself Out
  f["teapot";"toptea"]
1
  f["apple";"elap"]
0
  f["listen";"silent"]
1
f:{.[~] (count each group asc::) each (x;y)}
 #4 - Precious Snowflakes
  f "somewhat heterogenous"
"mwa rgnu"
  f "aaabccddefffgg"
"be"
f:{where 1=count each group x}
 #5 - Musical Chars
  f["foobar";"barfoo"]
1
  f["fboaro";"foobar"]
0
  f["abcde";"deabc"]
1
f:{any y~/:rotate[;x] each til count x}
 #6 - Size Matters
  f ("books";"apple";"peanut";"aardvark";"melon";"pie")
("pie"
 "books"
 "apple"
 "melon"
 "peanut"
 "aardvark")
f:{x iasc count each x}
 #7 - Popularity Contest
  f "abdbbac"
"b"
  f "CCCBBBAA"
"C"
  f "CCCBBBBAA"
"B"
f:{first key desc count each group x}
 #8 - esreveR A ecnetneS
  f "a few words in a sentence"
"a wef sdrow ni a ecnetnes"
  f "zoop"
"pooz"
  f "one two three four"
"eno owt eerht ruof"
f:{" " sv reverse each " " vs x}
 #9 - Compression Session
  f["foobar";1 0 0 1 0 1]
"fbr"
  f["embiggener";0 0 1 1 1 1 0 0 1 1]
"bigger"
f:{x where y}
 #10 - Expansion Mansion
  f["fbr";1 0 0 1 0 1]
"f__b_r"
  f["bigger";0 0 1 1 1 1 0 0 1 1]
"__bigg__er"
f:{@[count[y]#"_";where y;:;x]}
 #11 - C_ns_n_nts
  f "FLAPJACKS"
"FL_PJ_CKS"
  f "Several normal words"
"S_v_r_l n_rm_l w_rds"
f:{((l!l:.Q.a,.Q.A," "),"aeiouAEIOU"!"__________") x}
 #12 - Cnsnnts Rdx
  f "Several normal words"
"Svrl nrml wrds"
  f "FLAPJACKS"
"FLPJCKS"
f:{x where not x in "aeiouAEIOU"}
 #13 - TITLE REDACTED
  f["a few words in a sentence";"words"]
"a few XXXXX in a sentence"
  f["one fish two fish";"fish"]
"one XXXX two XXXX"
  f["I don't give a care";"care"]
"I don't give a XXXX"
f:{r:`$count[y]#"X";" " sv string @[c;d;:;count[d:where (c:`$" " vs x)=`$y]#r]}
 #14 - It’s More Fun to Permute
  f "xyz"
("xyz"
 "xzy"
 "yzx"
 "yxz"
 "zxy"
 "zyx")
/sourced out of at Play with J Eugene McDonald
fdb:{reverse 1+til x}
ar:{fdb[x] vs y}
ra:{fdb[x] sv y}
sr:{{rank y,x} over reverse x}
rs:{{sum x[0]>x} each {1 _ x} scan x}
allP:{(sr ar[x] ::)each til prd 1+til x}
f:{x allP[count x]}
f["xyz"]







