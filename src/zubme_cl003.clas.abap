CLASS zubme_cl003 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES : BEGIN OF ty_mold,
              equnr TYPE equnr,
            END OF ty_mold.
    TYPES : tt_mold TYPE TABLE OF ty_mold.


    TYPES : BEGIN OF ty_routing,
              bmsch TYPE bmsch,
            END OF ty_routing.
    TYPES : tt_routing TYPE TABLE OF ty_routing.

    CLASS-METHODS get_pp_routing_molds IMPORTING !plnnr  TYPE plnnr
                                                 !plnty  TYPE plnty
                                                 !plnal  TYPE plnal
                                                 !vornr  TYPE vornr
                                       EXPORTING !t_mold TYPE tt_mold.

    CLASS-METHODS get_pp_routing_detail IMPORTING !plnnr     TYPE plnnr
                                                  !plnty     TYPE plnty
                                                  !plnal     TYPE plnal
                                                  !vornr     TYPE vornr
                                        EXPORTING !t_routing TYPE tt_routing.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZUBME_CL003 IMPLEMENTATION.


  METHOD get_pp_routing_detail.
    DATA(lv_plnal_numc2) = CONV numc2( plnal ).

    SELECT plpo~bmsch
      FROM plas
     INNER JOIN plpo ON plpo~plnty EQ plas~plnty
                    AND plpo~plnnr EQ plas~plnnr
                    AND plpo~plnkn EQ plas~plnkn
      INTO CORRESPONDING FIELDS OF TABLE @t_routing
     WHERE plas~plnnr = @plnnr
       AND plas~plnfl = '000000'
       AND plas~plnty = @plnty
       AND plas~plnal = @lv_plnal_numc2
       AND plas~loekz = ''
       AND plpo~vornr = @vornr.

  ENDMETHOD.


  METHOD get_pp_routing_molds.

    DATA(lv_plnal_numc2) = CONV numc2( plnal ).

    SELECT crve_a~equnr
      FROM plas
     INNER JOIN plpo ON plpo~plnty EQ plas~plnty
                    AND plpo~plnnr EQ plas~plnnr
                    AND plpo~plnkn EQ plas~plnkn
     INNER JOIN plfh ON plfh~plnty EQ plas~plnty
                    AND plfh~plnnr EQ plas~plnnr
                    AND plfh~plnkn EQ plas~plnkn
     INNER JOIN crve_a ON crve_a~objty = plfh~objty
                      AND crve_a~objid = plfh~objid
      INTO CORRESPONDING FIELDS OF TABLE @t_mold
     WHERE plas~plnnr = @plnnr
       AND plas~plnfl = '000000'
       AND plas~plnty = @plnty
       AND plas~plnal = @lv_plnal_numc2
       AND plas~loekz = ''
       AND plpo~vornr = @vornr
       AND plfh~loekz = ''.

    SORT t_mold.
    DELETE ADJACENT DUPLICATES FROM t_mold COMPARING ALL FIELDS.

  ENDMETHOD.
ENDCLASS.
