class ZCL_IM_BADI_MATMAS_ALE_CR definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_BADI_MATMAS_ALE_CR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BADI_MATMAS_ALE_CR IMPLEMENTATION.


  METHOD if_ex_badi_matmas_ale_cr~change_matmas.


    CHECK : f_idoc_header-rcvprn = 'ME1CLNT001'.

    BREAK : 18885, 52683.



    DATA : ls_idoc_zmaraaf LIKE LINE OF t_idoc_data,
           ls_zmaraaf      TYPE zmaraaf,
           ls_e1maram      TYPE e1maram.

    "drfout ile malzeme me ye gönderilirken mevcut uzantı tipi değiştirilmeli.
    f_idoc_header-cimtyp = 'ZMATMAS5'.

    DELETE t_idoc_data WHERE segnam = 'ZUBMM_S022'.

    READ TABLE t_idoc_data TRANSPORTING NO FIELDS
      WITH KEY segnam = 'E1MARA1'.
    IF sy-subrc EQ 0.
      DATA(lv_tabix) = sy-tabix + 1.
      READ TABLE t_idoc_data INTO DATA(ls_idoc_e1maram)
        WITH KEY segnam = 'E1MARAM'.
      IF sy-subrc = 0.
        ls_e1maram = ls_idoc_e1maram-sdata.
        SELECT SINGLE * FROM mara INTO @DATA(ls_mara)
          WHERE matnr = @ls_e1maram-matnr.
        IF sy-subrc = 0.
          ls_idoc_zmaraaf-segnam = 'ZMARAAF'.

          ls_zmaraaf-zzkimkt = ls_mara-zzkimkt.
          CONDENSE ls_zmaraaf-zzkimkt NO-GAPS.

          ls_zmaraaf-zzprcet = ls_mara-zzprcet.
          ls_zmaraaf-zzprntr = ls_mara-zzprntr.
          ls_zmaraaf-zztntet = ls_mara-zztntet.
          ls_idoc_zmaraaf-sdata = ls_zmaraaf.
          INSERT ls_idoc_zmaraaf INTO t_idoc_data INDEX lv_tabix.
        ENDIF.
      ENDIF.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
