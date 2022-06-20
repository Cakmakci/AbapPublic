FUNCTION zubme_fg001_002.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_WERKS) TYPE  WERKS_D OPTIONAL
*"     VALUE(IP_ARBPL) TYPE  ARBPL OPTIONAL
*"     VALUE(IP_MATNR) TYPE  MATNR OPTIONAL
*"     VALUE(IP_GOOD_QTY) TYPE  MENGE_D OPTIONAL
*"     VALUE(IP_SCRAP) TYPE  MENGE_D OPTIONAL
*"     VALUE(IP_CHARG) TYPE  CHARG_D OPTIONAL
*"     VALUE(IP_SHIFT) TYPE  ZUBMM_DD019 OPTIONAL
*"     VALUE(IP_AUFNR) TYPE  AUFNR OPTIONAL
*"     VALUE(IP_PERNR) TYPE  PERNR_D OPTIONAL
*"     VALUE(IP_UNAME) TYPE  UNAME OPTIONAL
*"     VALUE(IP_SFC_NUMBER) TYPE  ZUBME_DD001 OPTIONAL
*"     VALUE(IP_USE_ETKNO) TYPE  ZUBMM_DD018 OPTIONAL
*"     VALUE(IP_PRINT_BOX_LABEL) TYPE  XFELD OPTIONAL
*"     VALUE(IP_PRINT_PART_LABEL) TYPE  XFELD OPTIONAL
*"     VALUE(IP_PRINT_REMAINING_BOX_LABEL) TYPE  XFELD OPTIONAL
*"     VALUE(IP_STATUS) TYPE  ZUBPP_DD394 OPTIONAL
*"  EXPORTING
*"     VALUE(EP_SUBRC) TYPE  SYSUBRC
*"     VALUE(ET_PART_LABEL_LIST) TYPE  ZUBPP_TT003
*"----------------------------------------------------------------------

  NEW zubme_cl001( is_import_label_data = VALUE #( werks                     = ip_werks
                                                   arbpl                     = ip_arbpl
                                                   good_qty                  = ip_good_qty
                                                   scrap                     = ip_scrap
                                                   matnr                     = ip_matnr
                                                   charg                     = ip_charg
                                                   aufnr                     = ip_aufnr
                                                   shift                     = ip_shift
                                                   pernr                     = ip_pernr
                                                   uname                     = ip_uname
                                                   sfc_number                = ip_sfc_number
                                                   use_etkno                 = ip_use_etkno
                                                   print_part_label          = ip_print_part_label
                                                   print_box_label           = ip_print_box_label
                                                   print_quality_label       = abap_off
                                                   print_remaining_box_label = ip_print_remaining_box_label
                                                   status                    = ip_status )
                   )->print_labels( IMPORTING et_part_label_list = et_part_label_list ).

ENDFUNCTION.
