FUNCTION zubme_fg001_008.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_KIOSK_NAME) TYPE  ZUBPP_DD171 OPTIONAL
*"     VALUE(IP_WERKS) TYPE  WERKS_D OPTIONAL
*"     VALUE(IP_MATNR) TYPE  MATNR OPTIONAL
*"     VALUE(IP_SHIFT) TYPE  ZUBPP_DD009 OPTIONAL
*"     VALUE(IP_UNAME) TYPE  UNAME OPTIONAL
*"     VALUE(IP_SHIFT_START_DATE) TYPE  DATUM OPTIONAL
*"     VALUE(IP_QM_CONTROL_TYPE) TYPE  ZUBPP_DD446 OPTIONAL
*"  EXPORTING
*"     VALUE(EP_SUBRC) TYPE  SYSUBRC
*"     VALUE(EP_PRUEFLOS) TYPE  QPLOS
*"     VALUE(EP_REASON_CODE) TYPE  ZUBPP_DD393
*"----------------------------------------------------------------------


  CASE ip_qm_control_type.
    WHEN 'N'.
      CALL FUNCTION 'ZUBME_FG001_005'
        EXPORTING
          ip_kiosk_name       = ip_kiosk_name
          ip_werks            = ip_werks
          ip_matnr            = ip_matnr
          ip_shift            = ip_shift
          ip_uname            = ip_uname
          ip_shift_start_date = ip_shift_start_date
        IMPORTING
          ep_subrc            = ep_subrc
          ep_prueflos         = ep_prueflos
          ep_reason_code      = ep_reason_code.

    WHEN 'T'.
      CALL FUNCTION 'ZUBME_FG001_007'
        EXPORTING
          ip_kiosk_name  = ip_kiosk_name
          ip_werks       = ip_werks
          ip_matnr       = ip_matnr
          ip_uname       = ip_uname
        IMPORTING
          ep_subrc       = ep_subrc
          ep_prueflos    = ep_prueflos
          ep_reason_code = ep_reason_code


          .



    WHEN OTHERS.
  ENDCASE.





ENDFUNCTION.
