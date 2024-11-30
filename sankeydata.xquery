xquery version "3.1" encoding "UTF-8";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare function local:nodename($node) {
    replace($node, ',', '')
};

declare function local:container($file){
let $labels := (
   local:nodename($file//tei:titleStmt/tei:title[@type='full']/text()))
    return
        string-join($labels[not(.='')], ' - ')
};


declare function local:nodewithid($node) {
    let $fn := substring-before($node, '#')
    let $file := doc('/Users/pietro/Desktop/disegniludolf/disegniObjects/' || $fn)
    let $id := substring-after($node, '#')
    let $dn := $file//tei:decoNote[@xml:id = $id]
    
    let $labels := (
   if($dn/tei:desc/tei:idno) then 
    $dn/tei:desc/tei:idno[1]//text() 
    else if ($dn/ancestor::tei:msPart) then 
    $dn/ancestor::tei:msPart/tei:msIdentifier/tei:idno/text()
    else local:nodename($file//tei:titleStmt/tei:title[@type='full']/text()),
    $dn/tei:title[1]//text(),
    normalize-space(string-join($dn/tei:label/node()[text()]//text(), ' | '))
    )
    return
        string-join($labels[not(.='')], ' - ')
};

let $mss := (
doc('/Users/pietro/Desktop/disegniludolf/disegniObjects/KdZ_Verhagen.xml'),
doc('/Users/pietro/Desktop/disegniludolf/disegniObjects/Hoefnagel_FourElements.xml'),
doc('/Users/pietro/Desktop/disegniludolf/disegniObjects/SGSM.xml'),
doc('/Users/pietro/Desktop/disegniludolf/disegniObjects/GKS3471.xml'),
doc('/Users/pietro/Desktop/disegniludolf/disegniObjects/Amsterdam_RijksmuseumLombard.xml'),
doc('/Users/pietro/Desktop/disegniludolf/disegniObjects/Amsterdam_Rijksmuseum.xml'),
doc('/Users/pietro/Desktop/disegniludolf/disegniObjects/PisaMS_514.xml'),
doc('/Users/pietro/Desktop/disegniludolf/disegniObjects/OeBNCodMin42.xml'),
doc('/Users/pietro/Desktop/disegniludolf/disegniObjects/OeBNCodMin83.xml'),
doc('/Users/pietro/Desktop/disegniludolf/disegniObjects/OeBNCodMin129.xml'),
doc('/Users/pietro/Desktop/disegniludolf/disegniObjects/OeBNCodMin130.xml'),
doc('/Users/pietro/Desktop/disegniludolf/disegniObjects/OeBNCodMin131.xml')
)
let $rels := 
    (
    
    for $rel in $mss//tei:relation[contains(@active, '#')][contains(@passive, '#')]
    return
    if($rel[contains(@active, '#')]/@active and $rel[contains(@passive, '#')]/@passive) then
        local:nodewithid($rel/@active) || ',' || local:nodewithid($rel/@passive) || ',1'
        else 
        local:nodewithid(concat($rel/ancestor::tei:TEI/@xml:id, '.xml#', $rel/ancestor::tei:decoNote/@xml:id)) || ',' || string-join($rel/text()) || ',1'
    ,
    (:statement of relation with the object:)
    for $active in $mss//tei:relation[contains(@active, '#')][contains(@passive, '#')]/@active
    return
    if(contains($active, '#')) then
        local:nodewithid($active) || ',' || local:container($active/ancestor::tei:TEI) || ',1'
        else
        $active/text() || ',' || local:container($active/ancestor::tei:TEI) || ',1'
    ,
    
    for $passive in $mss//tei:relation[contains(@active, '#')][contains(@passive, '#')]/@passive
    return
      if(contains($passive, '#')) then
        local:nodewithid($passive) || ',' || 
        local:container(doc('/Users/pietro/Desktop/disegniludolf/disegniObjects/' || substring-before($passive, '#'))//tei:TEI) || ',1'
    else 
   $passive/text() || ',' || '???' || ',1'
   ,
   (:decoNote Statements:)
    for $drawing in $mss//tei:decoNote[not(descendant::tei:relation)]
    return
  local:nodewithid(concat($drawing/ancestor::tei:TEI/@xml:id, '.xml#', $drawing/@xml:id))
|| ',' || local:container($drawing/ancestor::tei:TEI) || ',1'
    
    )
    
    return string-join($rels, '
')