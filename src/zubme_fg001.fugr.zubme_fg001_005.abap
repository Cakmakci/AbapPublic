FUNCTION zubme_fg001_005.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_KIOSK_NAME) TYPE  ZUBPP_DD171 OPTIONAL
*"     VALUE(IP_WERKS) TYPE  WERKS_D OPTIONAL
*"     VALUE(IP_MATNR) TYPE  MATNR OPTIONAL
*"     VALUE(IP_SHIFT) TYPE  ZUBPP_DD009 OPTIONAL
*"     VALUE(IP_UNAME) TYPE  UNAME OPTIONAL
*"     VALUE(IP_SHIFT_START_DATE) TYPE  DATUM OPTIONAL
*"  EXPORTING
*"     REFERENCE(EP_SUBRC) TYPE  SYSUBRC
*"     REFERENCE(EP_PRUEFLOS) TYPE  QPLOS
*"     REFERENCE(EP_REASON_CODE) TYPE  ZUBPP_DD393
*"----------------------------------------------------------------------
  DATA : lt_insplot_detail TYPE zubpp_tt049,
         ls_t020           TYPE zubpp_t020,
         lr_datum          TYPE RANGE OF datum,
         lv_datum          TYPE sy-datum,
         ls_t117           TYPE zubpp_t117.

  DEFINE add_range .
    APPEND VALUE #( sign = 'I'
                    option = 'EQ'
                    low = &1 ) TO &2.
  END-OF-DEFINITION.

  "günün tarihini ekle
  add_range sy-datum lr_datum.

  "gün geçişi olduysa..
  IF sy-datum <> ip_shift_start_date.
    add_range ip_shift_start_date lr_datum.
  ENDIF.

  "Değişim var mi? Varsa zubpp_t116 güncelleme işlemi
  CALL FUNCTION 'ZUBPP_FG028_004'
    EXPORTING
      ip_werks       = ip_werks
      ip_kiosk_name  = ip_kiosk_name
      ip_vardiya     = ip_shift
      ip_matnr       = ip_matnr
    IMPORTING
      ep_reason_code = ep_reason_code.
  IF ep_reason_code BETWEEN 01 AND 03.
    "Sürece yeni eklendi
    " Tablo 118 sürekli güncellendiği için 117 de logluyoruz.!!
    IF ep_reason_code = '03'." zubpp_t117'yi güncelle

      SELECT SINGLE * FROM zubpp_t118 INTO @DATA(ls_t118)
          WHERE kiosk_name = @ip_kiosk_name
            AND werks = @ip_werks.

      SELECT SINGLE mandt FROM zubpp_t117
            INTO sy-mandt
              WHERE kiosk_adi = ip_kiosk_name.
      IF sy-subrc = 0.
        UPDATE zubpp_t117 SET datum = ls_t118-aedat
                              uzeit = ls_t118-aezeit
                              inactive_reason = '03'
                              timestamp = ls_t118-timestamp
                        WHERE kiosk_adi = ip_kiosk_name.
      ELSE.
        ls_t117-kiosk_adi = ip_kiosk_name.
        ls_t117-datum = ls_t118-aedat.
        ls_t117-uzeit = ls_t118-aezeit.
        ls_t117-inactive_reason = '03'.
        ls_t117-timestamp = ls_t118-timestamp.
        MODIFY zubpp_t117 FROM ls_t117.
      ENDIF.
    ENDIF.

    CALL FUNCTION 'ZUBPP_FG028_002'
      EXPORTING
        ip_werks           = ip_werks
        ip_matnr           = ip_matnr
        ip_uzeit           = sy-uzeit
        ip_kiosk_name      = ip_kiosk_name
      IMPORTING
        et_insplot_detail  = lt_insplot_detail
      EXCEPTIONS
        etiket_bulunamadi  = 1
        vardiya_bulunamadi = 2
        OTHERS             = 3.
    IF lt_insplot_detail IS NOT INITIAL.
      " Tabloda olmayan aktif kontrol partilerini tabloya ekle
      LOOP AT lt_insplot_detail INTO DATA(ls_insplot_detail).

        CALL FUNCTION 'ZUBPP_FG028_003'
          EXPORTING
            ip_werks      = ip_werks
            ip_kiosk_name = ip_kiosk_name
            ip_matnr      = ip_matnr
            ip_shift      = ip_shift
            ip_prueflos   = ls_insplot_detail-prueflos
            ip_datum      = sy-datum.

      ENDLOOP.


    ENDIF.
    " Pasife çek
    CALL FUNCTION 'ZUBPP_FG028_003'
      EXPORTING
        ip_werks           = ip_werks
        ip_kiosk_name      = ip_kiosk_name
        ip_matnr           = ip_matnr
        ip_shift           = ip_shift
        ip_datum           = sy-datum
        ip_inactive_reason = ep_reason_code.

    ep_subrc = 4.
    EXIT.
  ELSE.
    CLEAR : ep_reason_code.
  ENDIF.

  SELECT SINGLE prueflos FROM zubpp_t116
    INTO ep_prueflos
      WHERE werks      EQ ip_werks
        AND kiosk_name EQ ip_kiosk_name
        AND matnr      EQ ip_matnr
        AND shift      EQ ip_shift
        AND datum      IN lr_datum
        AND inactive   EQ ''.
  IF sy-subrc = 0.
    ep_subrc = 0.
  ELSE.
    CALL FUNCTION 'ZUBPP_FG028_002'
      EXPORTING
        ip_werks           = ip_werks
        ip_matnr           = ip_matnr
        ip_uzeit           = sy-uzeit
        ip_kiosk_name      = ip_kiosk_name
      IMPORTING
        et_insplot_detail  = lt_insplot_detail
      EXCEPTIONS
        etiket_bulunamadi  = 1
        vardiya_bulunamadi = 2
        OTHERS             = 3.
    IF sy-subrc = 0 AND lt_insplot_detail[] IS NOT INITIAL.

      ep_subrc = 0.
      ep_prueflos = lt_insplot_detail[ 1 ]-prueflos.

      CALL FUNCTION 'ZUBPP_FG028_003'
        EXPORTING
          ip_werks      = ip_werks
          ip_kiosk_name = ip_kiosk_name
          ip_matnr      = ip_matnr
          ip_shift      = ip_shift
          ip_prueflos   = lt_insplot_detail[ 1 ]-prueflos
          ip_datum      = sy-datum.

    ELSE.
      ep_subrc = 4.
      CALL FUNCTION 'ZUBPP_FG028_004'
        EXPORTING
          ip_werks       = ip_werks
          ip_kiosk_name  = ip_kiosk_name
          ip_vardiya     = ip_shift
          ip_matnr       = ip_matnr
          ip_check_t117  = abap_on
        IMPORTING
          ep_reason_code = ep_reason_code.
      IF ep_reason_code IS INITIAL.
        ep_reason_code = 01.
      ENDIF.

      CALL FUNCTION 'ZUBPP_FG028_003'
        EXPORTING
          ip_werks           = ip_werks
          ip_kiosk_name      = ip_kiosk_name
          ip_matnr           = ip_matnr
          ip_shift           = ip_shift
          ip_datum           = sy-datum
          ip_inactive_reason = ep_reason_code.

    ENDIF.
  ENDIF.

ENDFUNCTION.
