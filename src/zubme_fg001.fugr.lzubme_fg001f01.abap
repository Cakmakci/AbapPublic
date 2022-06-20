*----------------------------------------------------------------------*
***INCLUDE LZUBME_FG001F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  CHANGE_BATCH_WITH_ZZSABIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_BFLUSHDATAGEN  text
*----------------------------------------------------------------------*
FORM change_batch_with_zzsabit CHANGING ps_bflushdatagen TYPE bapi_rm_datgen.

  SELECT SINGLE zzsabit FROM mara INTO @DATA(lv_zzsabit)
    WHERE matnr = @ps_bflushdatagen-materialnr.
  IF lv_zzsabit IS NOT INITIAL..
    SELECT SINGLE schrg FROM zubmm_t006 INTO @DATA(lv_schrg)
      WHERE werks = @ps_bflushdatagen-prodplant.
    IF sy-subrc = 0.
      ps_bflushdatagen-batch = lv_schrg.
    ENDIF.
  ENDIF.

  IF ps_bflushdatagen-batch IS INITIAL.
    ps_bflushdatagen-batch = 'SABIT'.
  ENDIF.

ENDFORM.
