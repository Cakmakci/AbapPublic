FUNCTION zubme_fg001_004.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_WERKS) TYPE  WERKS_D
*"     VALUE(IP_SORTF) TYPE  SORTF
*"     VALUE(IP_ETKNO) TYPE  STRING
*"  EXPORTING
*"     VALUE(EP_MATNR) TYPE  MATNR
*"     VALUE(EP_CPUDT) TYPE  CRDAT
*"     VALUE(EP_CPUTM) TYPE  CR_TIME
*"     VALUE(EP_BLKAJ) TYPE  ZUBMM_DD023
*"----------------------------------------------------------------------


  SELECT SINGLE *
    FROM zubme_t003
    INTO @DATA(ls_003)
   WHERE werks = @ip_werks
     AND sortf = @ip_sortf.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.


  DATA(lv_etkno_conv) = CONV zubmm_dd018( |{ ip_etkno ALPHA = IN }| ).


  IF ls_003-is_box_etkno IS NOT INITIAL.
    SELECT SINGLE matnr cpudt cputm blkaj
      INTO (ep_matnr, ep_cpudt, ep_cputm, ep_blkaj)
      FROM zubmm_t001
     WHERE etkno = lv_etkno_conv.

  ELSEIF ls_003-is_part_etkno IS NOT INITIAL.
    SELECT SINGLE matnr cpudt cputm blkaj
      INTO (ep_matnr, ep_cpudt, ep_cputm, ep_blkaj)
      FROM zubmm_t002
    WHERE etkno = lv_etkno_conv.

  ELSEIF ls_003-is_matnr IS NOT INITIAL.
    DATA(lv_matnr) = CONV matnr( ip_etkno ).
    SELECT SINGLE matnr
      FROM mara
      INTO ep_matnr
     WHERE matnr = lv_matnr .

  ENDIF.



ENDFUNCTION.
