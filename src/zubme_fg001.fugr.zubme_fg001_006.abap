FUNCTION zubme_fg001_006.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_KIOSK_NAME) TYPE  ZUBPP_DD171 OPTIONAL
*"     VALUE(IP_MATNR) TYPE  MATNR OPTIONAL
*"     VALUE(IP_WERKS) TYPE  WERKS_D OPTIONAL
*"     VALUE(IP_SHIFT) TYPE  ZUBMM_DD019 OPTIONAL
*"----------------------------------------------------------------------


  DATA : ls_t118 TYPE zubpp_t118.
  GET TIME STAMP FIELD DATA(lv_timestamp).

  SELECT SINGLE mandt FROM zubpp_t118 INTO sy-mandt
    WHERE kiosk_name = ip_kiosk_name
      AND werks = ip_werks.
  IF sy-subrc = 0.
    UPDATE zubpp_t118 SET matnr = ip_matnr
                          shift = ip_shift
                          aedat = sy-datum
                          aezeit = sy-uzeit
                          timestamp = lv_timestamp
                    WHERE werks      = ip_werks
                      AND kiosk_name = ip_kiosk_name.
  ELSE.
    ls_t118-werks = ip_werks.
    ls_t118-kiosk_name = ip_kiosk_name.
    ls_t118-matnr = ip_matnr.
    ls_t118-shift = ip_shift.
    ls_t118-aedat = sy-datum.
    ls_t118-aezeit = sy-uzeit.
    ls_t118-timestamp = lv_timestamp.
    MODIFY zubpp_t118 FROM ls_t118.
    COMMIT WORK AND WAIT.
  ENDIF.


ENDFUNCTION.
