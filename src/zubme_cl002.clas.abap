CLASS zubme_cl002 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    CLASS-METHODS get_sortf_by_reservation
      IMPORTING !reservationordernumber TYPE resb-rsnum
                !reservationitemnumber  TYPE resb-rspos
      EXPORTING !sortf                  TYPE resb-sortf.



  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZUBME_CL002 IMPLEMENTATION.


  METHOD get_sortf_by_reservation.

    SELECT SINGLE sortf
      FROM resb
      INTO sortf
     WHERE rsnum = reservationordernumber
       AND rspos = reservationitemnumber
       AND rsart = ''.


  ENDMETHOD.
ENDCLASS.
