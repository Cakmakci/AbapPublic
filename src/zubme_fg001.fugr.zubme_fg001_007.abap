FUNCTION ZUBME_FG001_007.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_KIOSK_NAME) TYPE  ZUBPP_DD171 OPTIONAL
*"     VALUE(IP_WERKS) TYPE  WERKS_D OPTIONAL
*"     VALUE(IP_MATNR) TYPE  MATNR OPTIONAL
*"     VALUE(IP_UNAME) TYPE  UNAME OPTIONAL
*"  EXPORTING
*"     VALUE(EP_SUBRC) TYPE  SYSUBRC
*"     REFERENCE(EP_PRUEFLOS) TYPE  QPLOS
*"     REFERENCE(EP_REASON_CODE) TYPE  ZUBPP_DD393
*"--------------------------------------------------------------------
  DATA : lt_insplot_detail TYPE zubpp_tt049.


  SELECT SINGLE * FROM zubpp_t117
    INTO @DATA(ls_t117)
       WHERE kiosk_adi = @ip_kiosk_name.
  IF sy-subrc = 0. " Burada bir kayıt olması gerekiyor..

    SELECT SINGLE prueflos FROM zubpp_t116
      INTO ep_prueflos
        WHERE werks      EQ ip_werks
          AND kiosk_name EQ ip_kiosk_name
          AND matnr      EQ ip_matnr
          AND inactive   EQ ''.
    IF sy-subrc NE 0.

      CALL FUNCTION 'ZUBPP_FG028_007'
        EXPORTING
          ip_werks           = ip_werks
          ip_matnr           = ip_matnr
          ip_uzeit           = ls_t117-uzeit
          ip_kiosk_name      = ip_kiosk_name
          ip_datum           = ls_t117-datum
        IMPORTING
          et_insplot_detail  = lt_insplot_detail
        EXCEPTIONS
          etiket_bulunamadi  = 1
          vardiya_bulunamadi = 2.
      IF lt_insplot_detail IS NOT INITIAL.

        SORT : lt_insplot_detail BY e_datum DESCENDING e_uzeit DESCENDING.

        CONVERT DATE lt_insplot_detail[ 1 ]-e_datum TIME lt_insplot_detail[ 1 ]-e_uzeit
                     INTO TIME STAMP DATA(lv_timestamp) TIME ZONE sy-zonlo.

        IF lv_timestamp GE ls_t117-timestamp.
          " kayıt var devam..
          CALL FUNCTION 'ZUBPP_FG028_003'
            EXPORTING
              ip_werks           = ip_werks
              ip_kiosk_name      = ip_kiosk_name
              ip_matnr           = ip_matnr
              ip_prueflos        = lt_insplot_detail[ 1 ]-prueflos
              ip_inactive_reason = ls_t117-inactive_reason.

          ep_prueflos = lt_insplot_detail[ 1 ]-prueflos.

        ELSE.
          ep_reason_code = ls_t117-inactive_reason.
          ep_subrc = 4.
        ENDIF.
      ELSE.
        ep_reason_code = ls_t117-inactive_reason.
        ep_subrc = 4.
      ENDIF.


    ENDIF.
  ENDIF.


ENDFUNCTION.
