FUNCTION zubme_fg001_003.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_RSNUM) TYPE  RESB-RSNUM
*"     VALUE(IP_RSPOS) TYPE  RESB-RSPOS
*"  EXPORTING
*"     VALUE(EP_SORTF) TYPE  RESB-SORTF
*"----------------------------------------------------------------------


  zubme_cl002=>get_sortf_by_reservation(
    EXPORTING
      reservationordernumber = ip_rsnum
      reservationitemnumber  = ip_rspos
    IMPORTING
      sortf                  = ep_sortf
  ).


ENDFUNCTION.
